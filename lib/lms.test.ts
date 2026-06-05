// lib/lms.test.ts — pure-engine tests for the WS7 LMS (run: npm run lms:test).
// Mirrors the node:test style of lib/ws5.test.ts; no DB, runnable under tsx.
import { test as t } from "node:test";
import assert from "node:assert/strict";
import {
  currentPeriodFor,
  requiredSetFor,
  gradeQuiz,
  isComplete,
  rankGaps,
  isGap,
  type AssignmentRule,
  type QuizQuestion,
} from "./lms";

// ── currentPeriodFor ─────────────────────────────────────────────────────────
t("currentPeriodFor: ON_JOIN and ON_RENEWAL are once-per-person ('JOIN')", () => {
  const d = new Date(Date.UTC(2026, 5, 4));
  assert.equal(currentPeriodFor("ON_JOIN", d), "JOIN");
  assert.equal(currentPeriodFor("ON_RENEWAL", d), "JOIN");
  assert.equal(currentPeriodFor(null, d), "JOIN");
});

t("currentPeriodFor: recurring cadences key on the calendar year", () => {
  const d = new Date(Date.UTC(2026, 0, 1));
  assert.equal(currentPeriodFor("ANNUAL", d), "2026");
  assert.equal(currentPeriodFor("ON_JOIN_ANNUAL", d), "2026");
  assert.equal(currentPeriodFor("PERIODIC", new Date(Date.UTC(2027, 11, 31))), "2027");
});

// ── requiredSetFor ───────────────────────────────────────────────────────────
const rules: AssignmentRule[] = [
  { moduleId: "FND-103", scope: "ALL", grade: null, jobProfileId: null, requirement: "REQUIRED", active: true },
  { moduleId: "INV-201", scope: "GRADE", grade: "G2", jobProfileId: null, requirement: "REQUIRED", active: true },
  { moduleId: "CLA-203", scope: "JOB_PROFILE", grade: null, jobProfileId: "jp_bd", requirement: "REQUIRED", active: true },
  { moduleId: "LDR-101", scope: "ALL", grade: null, jobProfileId: null, requirement: "RECOMMENDED", active: true },
  { moduleId: "OLD-001", scope: "ALL", grade: null, jobProfileId: null, requirement: "REQUIRED", active: false },
];

t("requiredSetFor: ALL applies to everyone; inactive rules ignored", () => {
  const r = requiredSetFor("G1", null, rules);
  assert.ok(r.required.includes("FND-103"));
  assert.ok(!r.required.includes("OLD-001"));
  assert.ok(r.recommended.includes("LDR-101"));
});

t("requiredSetFor: GRADE applies only to the matching grade", () => {
  assert.ok(requiredSetFor("G2", null, rules).required.includes("INV-201"));
  assert.ok(!requiredSetFor("G1", null, rules).required.includes("INV-201"));
});

t("requiredSetFor: JOB_PROFILE applies only to the matching role", () => {
  assert.ok(requiredSetFor("G3", "jp_bd", rules).required.includes("CLA-203"));
  assert.ok(!requiredSetFor("G3", "jp_other", rules).required.includes("CLA-203"));
});

t("requiredSetFor: required outranks recommended for the same module", () => {
  const both: AssignmentRule[] = [
    { moduleId: "X", scope: "ALL", grade: null, jobProfileId: null, requirement: "RECOMMENDED", active: true },
    { moduleId: "X", scope: "GRADE", grade: "G2", jobProfileId: null, requirement: "REQUIRED", active: true },
  ];
  const r = requiredSetFor("G2", null, both);
  assert.ok(r.required.includes("X"));
  assert.ok(!r.recommended.includes("X"));
  assert.equal(r.requirementByModule["X"], "REQUIRED");
});

// ── gradeQuiz ────────────────────────────────────────────────────────────────
const quiz: QuizQuestion[] = [
  { id: "q1", type: "SINGLE", options: [{ key: "a", text: "" }, { key: "b", text: "" }], correct: ["a"] },
  { id: "q2", type: "TRUE_FALSE", options: [{ key: "t", text: "" }, { key: "f", text: "" }], correct: ["t"] },
  { id: "q3", type: "MULTI", options: [{ key: "a", text: "" }, { key: "b", text: "" }, { key: "c", text: "" }], correct: ["a", "c"] },
  { id: "q4", type: "SINGLE", options: [{ key: "a", text: "" }, { key: "b", text: "" }], correct: ["b"] },
];

t("gradeQuiz: all correct → 100 and passed", () => {
  const r = gradeQuiz(quiz, { q1: ["a"], q2: ["t"], q3: ["a", "c"], q4: ["b"] }, 80);
  assert.equal(r.score, 100);
  assert.equal(r.correctCount, 4);
  assert.equal(r.passed, true);
});

t("gradeQuiz: MULTI needs the exact set (no partial credit)", () => {
  const r = gradeQuiz(quiz, { q1: ["a"], q2: ["t"], q3: ["a"], q4: ["b"] }, 80);
  assert.equal(r.perQuestion["q3"], false);
  assert.equal(r.score, 75);
  assert.equal(r.passed, false);
});

t("gradeQuiz: MULTI order does not matter", () => {
  const r = gradeQuiz(quiz, { q1: ["a"], q2: ["t"], q3: ["c", "a"], q4: ["b"] }, 80);
  assert.equal(r.perQuestion["q3"], true);
});

t("gradeQuiz: pass mark is inclusive (score === passMark passes)", () => {
  const r = gradeQuiz(quiz, { q1: ["a"], q2: ["t"], q3: ["a", "c"], q4: ["a"] }, 75);
  assert.equal(r.score, 75);
  assert.equal(r.passed, true);
});

t("gradeQuiz: a missing answer is wrong, not a crash", () => {
  const r = gradeQuiz(quiz, { q1: ["a"] }, 50);
  assert.equal(r.correctCount, 1);
  assert.equal(r.passed, false);
});

t("gradeQuiz: SINGLE with two keys chosen is wrong", () => {
  const r = gradeQuiz(quiz, { q1: ["a", "b"], q2: ["t"], q3: ["a", "c"], q4: ["b"] }, 80);
  assert.equal(r.perQuestion["q1"], false);
});

// ── isComplete ───────────────────────────────────────────────────────────────
t("isComplete: graded module requires a pass", () => {
  assert.equal(isComplete({ status: "COMPLETED", passed: true }, { passMark: 80 }), true);
  assert.equal(isComplete({ status: "COMPLETED", passed: false }, { passMark: 80 }), false);
  assert.equal(isComplete({ status: "COMPLETED", passed: null }, { passMark: 80 }), false);
});

t("isComplete: ungraded module completes on COMPLETED", () => {
  assert.equal(isComplete({ status: "COMPLETED" }, { passMark: null }), true);
  assert.equal(isComplete({ status: "IN_PROGRESS" }, { passMark: null }), false);
});

t("isComplete: WAIVED always counts as complete", () => {
  assert.equal(isComplete({ status: "WAIVED" }, { passMark: 80 }), true);
});

// ── rankGaps / isGap ─────────────────────────────────────────────────────────
t("isGap: only unmet REQUIRED rows are gaps", () => {
  assert.equal(isGap({ requirement: "REQUIRED", status: "ASSIGNED" }), true);
  assert.equal(isGap({ requirement: "REQUIRED", status: "COMPLETED" }), false);
  assert.equal(isGap({ requirement: "RECOMMENDED", status: "MISSING" }), false);
});

t("rankGaps: required-overdue-missing sorts to the top", () => {
  const asOf = new Date(Date.UTC(2026, 5, 4));
  const past = new Date(Date.UTC(2026, 0, 1));
  const future = new Date(Date.UTC(2026, 11, 1));
  const rows = [
    { employeeId: "e", moduleId: "rec", requirement: "RECOMMENDED", status: "MISSING", dueDate: null },
    { employeeId: "e", moduleId: "future", requirement: "REQUIRED", status: "ASSIGNED", dueDate: future },
    { employeeId: "e", moduleId: "overdue", requirement: "REQUIRED", status: "ASSIGNED", dueDate: past },
    { employeeId: "e", moduleId: "missing", requirement: "REQUIRED", status: "MISSING", dueDate: past },
  ];
  const sorted = rankGaps(rows, asOf).map((r) => r.moduleId);
  // both overdue REQUIRED first; among them MISSING (worse) before ASSIGNED
  assert.deepEqual(sorted.slice(0, 2), ["missing", "overdue"]);
  assert.equal(sorted[sorted.length - 1], "rec");
});

console.log("lms: all tests defined");
