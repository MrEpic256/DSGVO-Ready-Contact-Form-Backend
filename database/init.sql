-- DSGVO Contact Form Database Schema
-- Created with data minimization and privacy by design principles

CREATE TABLE IF NOT EXISTS contact_submissions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    consent_given BOOLEAN NOT NULL DEFAULT FALSE,
    anonymized_ip VARCHAR(15),
    user_agent VARCHAR(500),
    submitted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes for efficient querying
    CONSTRAINT consent_must_be_true CHECK (consent_given = TRUE)
);

-- Index for email-based deletion (Right to be Forgotten)
CREATE INDEX idx_contact_email ON contact_submissions(email);

-- Index for automatic cleanup based on age
CREATE INDEX idx_contact_submitted_at ON contact_submissions(submitted_at);

-- Comments for documentation
COMMENT ON TABLE contact_submissions IS 'DSGVO-compliant storage for contact form submissions';
COMMENT ON COLUMN contact_submissions.anonymized_ip IS 'IP address with last octet removed for anonymization';
COMMENT ON COLUMN contact_submissions.consent_given IS 'User consent for data processing - required by DSGVO';
COMMENT ON COLUMN contact_submissions.submitted_at IS 'Timestamp for data retention policy enforcement';
