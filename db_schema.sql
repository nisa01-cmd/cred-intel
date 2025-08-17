CREATE TABLE IF NOT EXISTS companies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE,
    ticker VARCHAR(20),
    sector VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS financials (
    id SERIAL PRIMARY KEY,
    company_id INT REFERENCES companies(id) ON DELETE CASCADE,
    report_date DATE NOT NULL,
    debt_ratio FLOAT,
    pe_ratio FLOAT,
    revenue FLOAT,
    profit_margin FLOAT,
    cash_ratio FLOAT,
    interest_coverage FLOAT
);

CREATE TABLE IF NOT EXISTS macro (
    id SERIAL PRIMARY KEY,
    report_date DATE NOT NULL,
    gdp_growth FLOAT,
    interest_rate FLOAT,
    inflation FLOAT,
    credit_spread FLOAT
);

CREATE TABLE IF NOT EXISTS events (
    id SERIAL PRIMARY KEY,
    company_id INT REFERENCES companies(id) ON DELETE CASCADE,
    event_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    event_text TEXT,
    sentiment FLOAT,     -- -1 to +1
    tags TEXT[],         -- e.g. {'debt_restructuring','lawsuit','guidance_cut'}
    impact_score FLOAT   -- -100..+100 adjustment, optional
);

CREATE TABLE IF NOT EXISTS scores (
    id SERIAL PRIMARY KEY,
    company_id INT REFERENCES companies(id) ON DELETE CASCADE,
    score_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    score FLOAT NOT NULL,
    base_score FLOAT,           -- model-only score before events
    event_adjustment FLOAT,     -- events impact added to base
    explanation TEXT
);

-- helpful indexes
CREATE INDEX IF NOT EXISTS idx_financials_company ON financials(company_id, report_date);
CREATE INDEX IF NOT EXISTS idx_events_company_date ON events(company_id, event_date);
CREATE INDEX IF NOT EXISTS idx_scores_company_date ON scores(company_id, score_date);
