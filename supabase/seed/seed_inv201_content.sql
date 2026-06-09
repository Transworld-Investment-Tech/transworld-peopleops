-- =============================================================================
-- seed_inv201_content.sql  (v0.65.0)
-- INV-201: Equity research & financial statement analysis — lesson + 20-question check (Proficient).
-- Authored BUILD (Tier B) to the house style; teaches no binding policy. Open foundation per External Source Register v1.1 row INV-201.
-- DATA, not schema. Run AFTER seed_lms_curriculum.sql (the shell exists from it).
-- Idempotent: body UPDATE + question upsert by id. PUBLISHES the module.
-- NO firmwide ALL rule and NO role-matrix row: the canonical role matrix already
--   maps INV-201 to live job profiles (Investment Analyst PUBLISHED + reserved roles;
--   confirm live: verify_p6.sql). Publish-only (the REG/OPS/CLA pattern).
-- =============================================================================
BEGIN;

-- 1) lesson body + PUBLISH + reaffirm pass mark
UPDATE "learning_modules"
SET body = $body$Before anyone at Transworld puts a number on a company — the work of the next two modules — someone has to read the company honestly. That is equity research, and it begins not with a forecast but with a set of audited accounts. The market will hand you a price every second of the trading day; the financial statements are where you find out whether that price is attached to a real business. An analyst's edge is rarely a secret tip. It is almost always a closer, more skeptical reading of documents anyone can download — a willingness to put two statements side by side, to read the notes nobody else reads, and to ask why a number is what it is rather than simply recording it. Valuation, which comes next, is only as good as this reading: a beautiful model built on numbers you never interrogated is a confident way to be wrong.

## What you will be able to do

1. Source a Nigerian listed company's financial statements from the right places and know what each filing is for.
2. Read the income statement, balance sheet and cash flow statement as one connected system.
3. Compute and interpret the ratios that actually carry information — profitability, efficiency, leverage, liquidity, returns.
4. Spot the accounting-quality red flags that separate reported profit from real cash.
5. Hold your own research to the independence and conduct standard the Nigerian regime requires.

## Where the numbers come from

In the United States an analyst pulls a company's 10-K from the SEC's EDGAR system. The discipline travels; the filing system does not. For an NGX-listed company your primary source is the issuer's audited annual report, filed with the Exchange and prepared under IFRS as adopted in Nigeria, with the Financial Reporting Council of Nigeria standing behind the standards. The Exchange's X-Compliance and corporate-disclosure pages, the issuer's own investor-relations site, and the regulatory announcements the company is required to make are the rest of your raw material.

Know what each filing is for. The audited annual report is the anchor: the full financial statements, the directors' and auditor's reports, and the notes. The quarterly and half-year accounts give you freshness between annuals, but they are usually unaudited and easier to flatter, so you lean on them for direction and on the audited set for trust. A prospectus or rights-issue circular tells you what the company says about itself when it is raising money, and corporate-action and price-sensitive announcements tell you what has changed since the last accounts. Work from the audited set wherever it exists, and read the auditor's report itself — a qualified or "emphasis of matter" opinion is information, not boilerplate. Above all, read the notes: the most important sentences in a set of accounts are often in the notes, not on the face of the statements, because that is where accounting policies, contingencies, related parties and segment detail actually live.

## The three statements are one story

The three primary statements are not three separate documents; they are three views of the same business, and a serious read ties them together.

The income statement tells the story of a year — revenue down through cost of sales, operating costs, finance costs and tax to profit. It answers "how did the company perform over the period?" The balance sheet is a snapshot at a single moment of what the company owns (assets), what it owes (liabilities), and what is left for owners (equity). It answers "what does the company look like right now?" The cash flow statement is the truth-teller, because cash is far harder to flatter than profit: it sorts the year's cash into operating, investing and financing flows and reconciles the profit the company reported to the cash that actually moved.

They connect, and the connections are the analyst's check. Profit retained after dividends flows into the equity section of the balance sheet. The cash flow statement begins with profit and adjusts it — for non-cash charges like depreciation and for changes in working capital — back to the change in the cash line on the balance sheet. Capital spending on the cash flow statement shows up as new assets on the balance sheet; new borrowing shows up as both cash in and debt. If the three do not reconcile in your reading, you have misunderstood something — and finding that break is often where the real analysis starts.

## Reading for quality, not just level

Most analysts can read the level of a number. The skill that pays is reading its quality. A company can report rising revenue it has not yet collected and rising profit that never becomes cash. The single most useful quality signal is the gap between net income and operating cash flow. In a healthy business they track each other over time. When reported profit marches up while operating cash flow stalls or falls, ask why: receivables that balloon faster than sales, revenue recognized aggressively, inventory building up unsold, or costs quietly capitalized onto the balance sheet rather than expensed through the income statement.

Three habits sharpen the skeptic's eye. Read the related-party note — sales to or from connected companies can manufacture growth that is not genuinely arm's-length. Read the revenue-recognition policy and ask whether it has changed, because a change in policy can move profit between years without any change in the underlying business. And strip out the one-offs: a disposal gain, a revaluation, or a one-time provision release can dress up a weak operating year, so separate what recurs from what does not before you judge the trend. None of these on its own is proof of anything; together they are the difference between taking the accounts at face value and actually reading them.

## The ratios that actually carry information

Ratios are not a checklist to fill in; each answers a question, and a ratio you cannot tie to a question is noise.

How profitable is it? Gross, operating and net margins, read as a trend rather than a single year, tell you whether the business keeps more of each naira of sales over time and where in the chain — production, overhead, financing — the money is being lost or kept. How efficiently does it use its assets? Asset turnover, and the days of sales tied up in receivables and inventory, tell you how hard the balance sheet is working to generate that revenue. How much leverage is it carrying? Debt-to-equity and interest cover tell you how much room the company has before debt service becomes a problem, which in a high-rate naira environment can change quickly. How liquid is it? The current and quick ratios tell you whether it can meet near-term obligations without a fire sale.

Returns to owners deserve a closer look. Return on equity is the headline, but decompose it before you trust it: ROE is net margin multiplied by asset turnover multiplied by the equity multiplier — the DuPont identity. Two companies can post the same ROE, one earned through fat margins and efficient assets and one manufactured by piling on debt. They are not the same investment, and the decomposition is exactly what shows you the difference between earned returns and borrowed ones.

Finally, never read a ratio in a vacuum. Read it three ways: against the company's own history, against its peers, and against the macro environment. A 25% naira margin in a year of 28% inflation is a very different achievement from the same margin in a year of 5% inflation, and an analyst who ignores the nominal-versus-real distinction will misread every Nigerian company on the board. The macro lens is not optional in our market; it is the difference between a number that means something and one that merely looks impressive.

## A worked example

**Illustration — "Naija Foods Plc" (entirely hypothetical).** The company and every figure are invented for teaching; this is not a real company and not a recommendation. Naija Foods reports revenue up 20% to ₦60 billion and net profit up a healthy-looking 15%. The headline reads like a strong year, and a careless note would stop there. Then you put the income statement next to the cash flow statement and the story changes: operating cash flow is roughly flat, and the receivables note shows debtors up far faster than sales. The growth is real on paper but uncollected in cash — a quality flag, not a fraud verdict, but a question that belongs in the note: is the company buying revenue by extending generous credit it may never collect? Next you decompose the ROE, which also rose, and find it climbed only because the company took on more debt; margins and asset turnover were flat. One set of accounts, two findings the headline hid: the profit is softer than it looks because it is not converting to cash, and the improved returns are leverage rather than operating strength. That is the entire difference between reading the level of a number and reading its quality.

## From the statements to a view

Reading is not the end; it is the foundation for a view. By the time you close the accounts you should be able to say, in a few plain sentences, what kind of business this is, how it makes money, how durable that money is, and where the risks sit — before a single valuation cell is filled in. Those sentences become the thesis the next two modules build on: the forecast in a valuation is only your reading of the company projected forward, and a recommendation is only that reading turned into a decision for a specific client. This is also why the research and the valuation must stay honest about each other. If the accounts tell you growth is uncollected and returns are borrowed, a model that assumes smooth growth and rising margins is not analysis, it is wishful thinking dressed up in a spreadsheet. The discipline of this module — source the real filings, tie the three statements together, read for quality, and judge every ratio in context — is what keeps the work that follows grounded in the company as it actually is. Profit without cash is a claim, not a fact; always put the cash flow statement beside it.
- **Comparing ratios blindly across industries or accounting policies.** A bank's balance sheet and a manufacturer's are not comparable on the same ratios.
- **Ignoring the macro lens.** Nominal naira growth is not real growth; read every figure against inflation.
- **Treating "audited" as infallible.** Read the auditor's opinion and the notes — the qualifications live there.
- **Mistaking size for quality.** A large company with a widening accruals gap is a large problem.

## Key takeaways

- Equity research begins with the audited accounts; the analyst's edge is a closer, more skeptical read of public documents.
- Source from NGX issuer filings and X-Compliance plus the audited IFRS accounts the FRC of Nigeria stands behind; the concept of structured filing data travels from EDGAR, but the filing system is Nigerian.
- Read the three statements as one connected system; the cash flow statement is the truth-teller.
- The gap between net income and operating cash flow is the single most useful accounting-quality signal.
- Read every ratio against history, peers and the macro, and decompose ROE before you trust it.

*Build mode: BUILD — a general professional craft taught to the house style; this module teaches no binding Transworld policy. House style: Internal Control Framework v3.0 (canonical voice). Standard: External Source Register v1.1 (200-level: 2,000–2,500-word body; 20-question check). Open foundation: Aswath Damodaran, NYU Stern (OPEN-ADAPT) for the research and analysis framing, supported by OpenTuition ACCA Financial Accounting and MIT OpenCourseWare 15.401 (READ-REF) for accounting fundamentals, and the SEC EDGAR concept of structured filing data (GOV-PUBLIC) localized to NGX and FRC of Nigeria sources. Conduct framed under the Investments and Securities Act 2025 and SEC Nigeria. Authored original to the house voice; no text reproduced from any source. See External Source Register v1.1, row INV-201.*$body$,
    status = 'PUBLISHED',
    pass_mark = 80,
    updated_at = CURRENT_TIMESTAMP
WHERE code = 'INV-201';

-- 2) twenty graded questions (80 percent pass)
INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_01$id$, m.id, $p$For an NGX-listed company, the analyst's primary source of trustworthy financials is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the issuer's audited annual report filed with the NGX, prepared under IFRS"}, {"key": "b", "text": "a US 10-K filed on SEC EDGAR"}, {"key": "c", "text": "a brokerage tip sheet"}, {"key": "d", "text": "the company's advertising"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$In Nigeria the primary source is the issuer's audited IFRS annual report filed with the Exchange and standing behind the FRC's standards — EDGAR is the US analogue.$e$, 1, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_02$id$, m.id, $p$Which statement is the 'truth-teller' because cash is harder to flatter than profit?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the income statement"}, {"key": "b", "text": "the cash flow statement"}, {"key": "c", "text": "the balance sheet"}, {"key": "d", "text": "the chairman's letter"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The cash flow statement reconciles reported profit to the cash that actually moved, and is the hardest to manipulate.$e$, 2, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_03$id$, m.id, $p$A company reports rising profit while operating cash flow is flat and receivables balloon. This is best read as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "proof of fraud"}, {"key": "b", "text": "irrelevant"}, {"key": "c", "text": "an accounting-quality flag worth a question in the note"}, {"key": "d", "text": "a reason to buy immediately"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$A widening gap between net income and operating cash flow is the most useful quality signal — a question to raise, not a fraud verdict.$e$, 3, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_04$id$, m.id, $p$The three primary statements should be read as...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "three unrelated documents"}, {"key": "b", "text": "only the income statement, in practice"}, {"key": "c", "text": "optional once you have the share price"}, {"key": "d", "text": "one connected system that ties together"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Profit flows to equity, and the cash flow statement reconciles profit to the change in cash — they connect, and a break means a misreading.$e$, 4, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_05$id$, m.id, $p$Two firms post identical ROE; one earns it through margin, one through heavy debt. The right conclusion is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "they differ materially — decompose ROE before trusting it"}, {"key": "b", "text": "they are equivalent investments"}, {"key": "c", "text": "the debt-driven one is always better"}, {"key": "d", "text": "ROE is meaningless"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$ROE is margin x asset turnover x leverage; the DuPont decomposition shows whether returns are operating strength or borrowed.$e$, 5, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_06$id$, m.id, $p$A 25% naira net margin is reported in a year of 28% inflation. The analyst should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "celebrate it without context"}, {"key": "b", "text": "read it against the macro — nominal naira figures are not real growth"}, {"key": "c", "text": "ignore inflation entirely"}, {"key": "d", "text": "assume the company is failing"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$Every Nigerian figure must be read against inflation; nominal naira growth is not real growth.$e$, 6, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_07$id$, m.id, $p$Where do the most important qualifications in a set of accounts often appear?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "on the cover"}, {"key": "b", "text": "in the marketing deck"}, {"key": "c", "text": "in the notes and the auditor's report"}, {"key": "d", "text": "nowhere — audited accounts are infallible"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$The notes and the auditor's opinion (including any qualification or emphasis of matter) carry information that the face of the statements omits.$e$, 7, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_08$id$, m.id, $p$Which ratio set best answers 'how much room before debt becomes a problem?'$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "gross and net margins"}, {"key": "b", "text": "current and quick ratios"}, {"key": "c", "text": "asset turnover"}, {"key": "d", "text": "debt-to-equity and interest cover"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Leverage is read through debt-to-equity and interest cover; margins answer profitability and current/quick answer liquidity.$e$, 8, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_09$id$, m.id, $p$Comparing a bank's and a manufacturer's balance sheets on the same ratios is...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a trap — ratios are not comparable across very different business models"}, {"key": "b", "text": "good practice"}, {"key": "c", "text": "required by IFRS"}, {"key": "d", "text": "the only valid method"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Ratios must be compared within a like business model and accounting policy; cross-industry comparison without adjustment misleads.$e$, 9, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_10$id$, m.id, $p$An analyst's real edge usually comes from...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "a secret tip"}, {"key": "b", "text": "a closer, more skeptical reading of documents anyone can download"}, {"key": "c", "text": "trading on rumours"}, {"key": "d", "text": "the largest screen"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$The module's thesis: the edge is disciplined, skeptical reading of public filings, not secret information.$e$, 10, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_11$id$, m.id, $p$Unaudited quarterly accounts versus the audited annual report — the analyst should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "trust the quarterly over the annual"}, {"key": "b", "text": "ignore the audited set"}, {"key": "c", "text": "use quarterlies for freshness but anchor trust in the audited annual set"}, {"key": "d", "text": "never read either"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Quarterlies give freshness but are easier to flatter; the audited annual report is the signed-off document to anchor on.$e$, 11, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_12$id$, m.id, $p$Related-party transactions in the notes deserve attention because they...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "are always immaterial"}, {"key": "b", "text": "reduce tax only"}, {"key": "c", "text": "replace the cash flow statement"}, {"key": "d", "text": "can manufacture growth that is not genuinely arm's-length"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Sales to or from connected companies can inflate growth that is not real; the related-party note is part of the skeptic's read.$e$, 12, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_13$id$, m.id, $p$'Reading the level' versus 'reading the quality' of a number means...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the level is the figure; the quality is whether it is durable and backed by cash"}, {"key": "b", "text": "they are the same thing"}, {"key": "c", "text": "quality is irrelevant to research"}, {"key": "d", "text": "only the level matters to a PM"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Most analysts can read the figure; the skill that pays is judging whether the profit is durable and cash-backed.$e$, 13, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_14$id$, m.id, $p$A disposal gain makes a weak operating year look strong. The analyst should...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "treat it as recurring"}, {"key": "b", "text": "separate one-offs from what recurs"}, {"key": "c", "text": "add it to next year's forecast"}, {"key": "d", "text": "ignore the operating result"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$One-off items must be stripped out so the recurring operating performance is visible.$e$, 14, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_15$id$, m.id, $p$Which is the single most useful accounting-quality signal taught in this module?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "the share price"}, {"key": "b", "text": "the number of employees"}, {"key": "c", "text": "the gap between net income and operating cash flow"}, {"key": "d", "text": "the dividend date"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$A persistent or widening gap between reported profit and operating cash flow is the key quality warning.$e$, 15, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_16$id$, m.id, $p$The X-Compliance and corporate-disclosure pages of the NGX are useful because they...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "set the share price"}, {"key": "b", "text": "are private to the firm"}, {"key": "c", "text": "replace the audited accounts"}, {"key": "d", "text": "are part of the structured public-filing record for a listed issuer"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$They are part of the public filing/disclosure record — the Nigerian counterpart to the structured-filing concept that travels from EDGAR.$e$, 16, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_17$id$, m.id, $p$Asset turnover and receivable days primarily tell you...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "how efficiently the firm uses its assets"}, {"key": "b", "text": "how profitable the firm is"}, {"key": "c", "text": "how leveraged it is"}, {"key": "d", "text": "its dividend policy"}]$o$::jsonb, $c$["a"]$c$::jsonb, $e$Efficiency ratios — turnover and days tied up in receivables/inventory — show how hard the balance sheet is working.$e$, 17, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_18$id$, m.id, $p$Reading a ratio 'three ways' means against...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "three analysts' opinions"}, {"key": "b", "text": "the company's own history, its peers, and the macro environment"}, {"key": "c", "text": "three share prices"}, {"key": "d", "text": "three currencies"}]$o$::jsonb, $c$["b"]$c$::jsonb, $e$A ratio is only meaningful against the company's history, its peers, and the prevailing macro conditions.$e$, 18, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_19$id$, m.id, $p$Which is a fair characterization of IFRS as adopted in Nigeria for research purposes?$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "it is irrelevant to listed-company analysis"}, {"key": "b", "text": "it is a US-only standard"}, {"key": "c", "text": "it is the reporting framework, overseen by the FRC of Nigeria, behind the audited accounts"}, {"key": "d", "text": "it bans ratio analysis"}]$o$::jsonb, $c$["c"]$c$::jsonb, $e$Nigerian listed issuers report under IFRS as adopted in Nigeria, with the FRC standing behind the standards — the basis of the accounts you analyse.$e$, 19, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

INSERT INTO "learning_quiz_questions"
  ("id","module_id","prompt","type","options","correct","explanation","sort_order","active","created_at","updated_at")
SELECT $id$q_inv201_20$id$, m.id, $p$'Mistaking size for quality' is a trap because...$p$, $t$SINGLE$t$, $o$[{"key": "a", "text": "large companies cannot have problems"}, {"key": "b", "text": "size guarantees cash generation"}, {"key": "c", "text": "only small firms are analysed"}, {"key": "d", "text": "a large firm with a widening accruals gap is simply a large problem"}]$o$::jsonb, $c$["d"]$c$::jsonb, $e$Scale does not equal quality; a big company with poor cash conversion is a big risk, not a safe one.$e$, 20, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM "learning_modules" m WHERE m.code = 'INV-201'
ON CONFLICT ("id") DO UPDATE SET
  prompt = EXCLUDED.prompt, type = EXCLUDED.type, options = EXCLUDED.options, correct = EXCLUDED.correct,
  explanation = EXCLUDED.explanation, sort_order = EXCLUDED.sort_order, active = true, updated_at = CURRENT_TIMESTAMP;

-- 3) fail-loud guard
DO $guard$
DECLARE mid text; n int;
BEGIN
  SELECT id INTO mid FROM "learning_modules" WHERE code = 'INV-201';
  IF mid IS NULL THEN RAISE EXCEPTION 'Guard: INV-201 module missing'; END IF;
  SELECT count(*) INTO n FROM "learning_modules" WHERE code = 'INV-201' AND status = 'PUBLISHED';
  IF n <> 1 THEN RAISE EXCEPTION 'Guard: INV-201 not PUBLISHED (got %)', n; END IF;
  SELECT count(*) INTO n FROM "learning_quiz_questions" WHERE module_id = mid AND active = true;
  IF n <> 20 THEN RAISE EXCEPTION 'Guard: INV-201 expected 20 active questions (got %)', n; END IF;
END
$guard$;

COMMIT;
