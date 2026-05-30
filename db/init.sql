-- Transworld PeopleOps & Payroll Control Portal — v0.1.1
-- Reference DDL equivalent to prisma/schema.prisma (Prisma owns migrations).
-- IDs are application-generated (cuid); supply them on insert.

-- ===== Enums =====
CREATE TYPE "EmploymentType"      AS ENUM ('FULL_TIME','PART_TIME','CONTRACT','OUTSOURCED','FRACTIONAL','CONSULTANT','EXTERNAL_REVIEWER');
CREATE TYPE "EmploymentStatus"    AS ENUM ('ACTIVE','PROBATION','ON_LEAVE','EXITED','SUSPENDED');
CREATE TYPE "TaxTreatment"        AS ENUM ('PAYE','EXEMPT','FLAT_RATE');
CREATE TYPE "JdStatus"            AS ENUM ('DRAFT','PUBLISHED');
CREATE TYPE "PayCycleStatus"      AS ENUM ('DRAFT','IN_REVIEW','APPROVED','GENERATED','LOCKED');
CREATE TYPE "PayItemReviewStatus" AS ENUM ('CARRIED_FORWARD','CHANGED','NEW','CONFIRMED');
CREATE TYPE "DocAccessLevel"      AS ENUM ('EMPLOYEE','HR','EXEC','RESTRICTED');
CREATE TYPE "LeaveRequestStatus"  AS ENUM ('PENDING','APPROVED','REJECTED','CANCELLED');

-- ===== Identity & access =====
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  password_hash TEXT,
  status TEXT NOT NULL DEFAULT 'active',
  mfa_enabled BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE roles (
  id TEXT PRIMARY KEY, key TEXT UNIQUE NOT NULL, name TEXT NOT NULL, description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE permissions ( id TEXT PRIMARY KEY, key TEXT UNIQUE NOT NULL, label TEXT NOT NULL );
CREATE TABLE user_roles (
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role_id TEXT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, role_id)
);
CREATE TABLE role_permissions (
  role_id TEXT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
  permission_id TEXT NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
  PRIMARY KEY (role_id, permission_id)
);

-- ===== Organization =====
CREATE TABLE entities ( id TEXT PRIMARY KEY, name TEXT NOT NULL, code TEXT UNIQUE NOT NULL, created_at TIMESTAMPTZ NOT NULL DEFAULT now() );
CREATE TABLE departments ( id TEXT PRIMARY KEY, name TEXT NOT NULL, created_at TIMESTAMPTZ NOT NULL DEFAULT now() );
CREATE TABLE pay_categories ( id TEXT PRIMARY KEY, name TEXT UNIQUE NOT NULL, code TEXT UNIQUE NOT NULL, created_at TIMESTAMPTZ NOT NULL DEFAULT now() );

-- ===== Job & competency framework =====
CREATE TABLE job_profiles (
  id TEXT PRIMARY KEY, title TEXT NOT NULL, grade TEXT, department_id TEXT, description TEXT,
  status "JdStatus" NOT NULL DEFAULT 'DRAFT',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(), updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE competencies ( id TEXT PRIMARY KEY, name TEXT UNIQUE NOT NULL, category TEXT );
CREATE TABLE job_profile_competencies (
  job_profile_id TEXT NOT NULL REFERENCES job_profiles(id) ON DELETE CASCADE,
  competency_id TEXT NOT NULL REFERENCES competencies(id) ON DELETE CASCADE,
  level INT NOT NULL DEFAULT 1,
  PRIMARY KEY (job_profile_id, competency_id)
);

-- ===== People =====
CREATE TABLE employees (
  id TEXT PRIMARY KEY,
  ee_id TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  preferred_name TEXT,
  work_email TEXT,
  phone TEXT,
  user_id TEXT UNIQUE REFERENCES users(id),
  entity_id TEXT REFERENCES entities(id),
  department_id TEXT REFERENCES departments(id),
  job_profile_id TEXT REFERENCES job_profiles(id),
  pay_category_id TEXT REFERENCES pay_categories(id),
  manager_id TEXT REFERENCES employees(id),
  employment_type "EmploymentType" NOT NULL DEFAULT 'FULL_TIME',
  status "EmploymentStatus" NOT NULL DEFAULT 'ACTIVE',
  start_date TIMESTAMPTZ,
  exit_date TIMESTAMPTZ,
  bank_name_masked TEXT,
  bank_acct_masked TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE employment_records (
  id TEXT PRIMARY KEY,
  employee_id TEXT NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  title TEXT, department_id TEXT, manager_id TEXT,
  status "EmploymentStatus" NOT NULL,
  effective_date TIMESTAMPTZ NOT NULL, note TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
-- Standing payroll INPUTS that carry forward each cycle
CREATE TABLE compensation_profiles (
  id TEXT PRIMARY KEY,
  employee_id TEXT NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  effective_date TIMESTAMPTZ NOT NULL,
  basic_salary NUMERIC(14,2) NOT NULL,
  utility_allowance NUMERIC(14,2) NOT NULL DEFAULT 0,
  quarterly_allowance NUMERIC(14,2) NOT NULL DEFAULT 0,
  tax_treatment "TaxTreatment" NOT NULL DEFAULT 'PAYE',
  pension_applicable BOOLEAN NOT NULL DEFAULT true,
  nhf_applicable BOOLEAN NOT NULL DEFAULT true,
  is_current BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_comp_emp_current ON compensation_profiles (employee_id, is_current);

-- ===== Documents & policy =====
CREATE TABLE employee_documents (
  id TEXT PRIMARY KEY,
  employee_id TEXT NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  category TEXT NOT NULL, file_key TEXT NOT NULL, version INT NOT NULL DEFAULT 1,
  expiry_date TIMESTAMPTZ, access_level "DocAccessLevel" NOT NULL DEFAULT 'HR',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE policies (
  id TEXT PRIMARY KEY, title TEXT NOT NULL, version TEXT NOT NULL DEFAULT '1.0',
  file_key TEXT, is_current BOOLEAN NOT NULL DEFAULT true, created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE policy_acknowledgments (
  id TEXT PRIMARY KEY,
  policy_id TEXT NOT NULL REFERENCES policies(id) ON DELETE CASCADE,
  employee_id TEXT NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  acknowledged_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (policy_id, employee_id)
);

-- ===== Leave =====
CREATE TABLE leave_types ( id TEXT PRIMARY KEY, name TEXT UNIQUE NOT NULL, days_per_year INT NOT NULL DEFAULT 0 );
CREATE TABLE leave_balances (
  id TEXT PRIMARY KEY,
  employee_id TEXT NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  leave_type_id TEXT NOT NULL REFERENCES leave_types(id),
  year INT NOT NULL, days_taken NUMERIC(6,1) NOT NULL DEFAULT 0,
  UNIQUE (employee_id, leave_type_id, year)
);
CREATE TABLE leave_requests (
  id TEXT PRIMARY KEY,
  employee_id TEXT NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  leave_type_id TEXT NOT NULL REFERENCES leave_types(id),
  start_date TIMESTAMPTZ NOT NULL, end_date TIMESTAMPTZ NOT NULL, days NUMERIC(6,1) NOT NULL,
  status "LeaveRequestStatus" NOT NULL DEFAULT 'PENDING', approver_id TEXT, note TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ===== Payroll: configurable tax engine =====
CREATE TABLE tax_rule_sets (
  id TEXT PRIMARY KEY, name TEXT NOT NULL, effective_from TIMESTAMPTZ NOT NULL,
  exempt_threshold_annual NUMERIC(14,2) NOT NULL,
  pension_employee_rate NUMERIC(6,4) NOT NULL,
  pension_employer_rate NUMERIC(6,4) NOT NULL,
  nhf_rate NUMERIC(6,4) NOT NULL,
  rent_relief_rate NUMERIC(6,4) NOT NULL,
  rent_relief_cap_annual NUMERIC(14,2) NOT NULL,
  pension_on_basic_only BOOLEAN NOT NULL DEFAULT true,
  is_active BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE tax_bands (
  id TEXT PRIMARY KEY,
  tax_rule_set_id TEXT NOT NULL REFERENCES tax_rule_sets(id) ON DELETE CASCADE,
  sequence INT NOT NULL,
  lower_bound NUMERIC(14,2) NOT NULL,
  upper_bound NUMERIC(14,2),  -- NULL = no ceiling
  rate NUMERIC(6,4) NOT NULL
);

-- ===== Payroll: cycles & items =====
CREATE TABLE pay_cycles (
  id TEXT PRIMARY KEY, label TEXT NOT NULL,
  period_month INT NOT NULL, period_year INT NOT NULL,
  status "PayCycleStatus" NOT NULL DEFAULT 'DRAFT',
  tax_rule_set_id TEXT REFERENCES tax_rule_sets(id),
  carried_forward_from_id TEXT,
  total_gross NUMERIC(16,2), total_net NUMERIC(16,2),
  total_employer_pension NUMERIC(16,2), total_quarterly NUMERIC(16,2), total_payable NUMERIC(16,2),
  approved_by_id TEXT, approved_at TIMESTAMPTZ, generated_at TIMESTAMPTZ, locked_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(), updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (period_year, period_month)
);
-- Per-employee snapshot: inputs carried forward + computed outputs
CREATE TABLE pay_items (
  id TEXT PRIMARY KEY,
  pay_cycle_id TEXT NOT NULL REFERENCES pay_cycles(id) ON DELETE CASCADE,
  employee_id TEXT NOT NULL REFERENCES employees(id),
  pay_category_id TEXT REFERENCES pay_categories(id),
  basic_salary NUMERIC(14,2) NOT NULL,
  utility_allowance NUMERIC(14,2) NOT NULL DEFAULT 0,
  quarterly_allowance NUMERIC(14,2) NOT NULL DEFAULT 0,
  tax_treatment "TaxTreatment" NOT NULL DEFAULT 'PAYE',
  gross_pay NUMERIC(14,2) NOT NULL,
  employee_pension NUMERIC(14,2) NOT NULL DEFAULT 0,
  nhf NUMERIC(14,2) NOT NULL DEFAULT 0,
  taxable_income NUMERIC(14,2) NOT NULL DEFAULT 0,
  paye_tax NUMERIC(14,2) NOT NULL DEFAULT 0,
  net_pay NUMERIC(14,2) NOT NULL,
  employer_pension NUMERIC(14,2) NOT NULL DEFAULT 0,
  review_status "PayItemReviewStatus" NOT NULL DEFAULT 'CARRIED_FORWARD',
  previous_values JSONB,
  change_note TEXT,
  confirmed_by_id TEXT,
  confirmed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (pay_cycle_id, employee_id)
);

-- ===== System =====
CREATE TABLE audit_logs (
  id TEXT PRIMARY KEY, actor_id TEXT REFERENCES users(id),
  action TEXT NOT NULL, entity_type TEXT NOT NULL, entity_id TEXT, metadata JSONB, ip TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_audit_entity ON audit_logs (entity_type, entity_id);
CREATE TABLE notifications (
  id TEXT PRIMARY KEY, user_id TEXT, title TEXT NOT NULL, body TEXT, read_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
