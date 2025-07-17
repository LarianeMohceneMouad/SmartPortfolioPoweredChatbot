-- Portfolio Website Database Schema
-- PostgreSQL Database Setup

-- Create database (run this separately as a superuser)
-- CREATE DATABASE portfolio_db;

-- Connect to the portfolio_db database before running the rest

-- Create contacts table
CREATE TABLE IF NOT EXISTS contacts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_contacts_email ON contacts(email);
CREATE INDEX IF NOT EXISTS idx_contacts_created_at ON contacts(created_at DESC);

-- Add some constraints
ALTER TABLE contacts 
ADD CONSTRAINT chk_name_not_empty CHECK (LENGTH(TRIM(name)) > 0),
ADD CONSTRAINT chk_email_not_empty CHECK (LENGTH(TRIM(email)) > 0),
ADD CONSTRAINT chk_message_not_empty CHECK (LENGTH(TRIM(message)) > 0);

-- Optional: Create a view for recent contacts (last 30 days)
CREATE OR REPLACE VIEW recent_contacts AS
SELECT 
    id,
    name,
    email,
    LEFT(message, 100) || '...' AS message_preview,
    created_at
FROM contacts 
WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY created_at DESC;

-- Optional: Create a function to get contact statistics
CREATE OR REPLACE FUNCTION get_contact_stats()
RETURNS TABLE(
    total_contacts BIGINT,
    contacts_this_month BIGINT,
    contacts_today BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        (SELECT COUNT(*) FROM contacts) AS total_contacts,
        (SELECT COUNT(*) FROM contacts WHERE created_at >= DATE_TRUNC('month', CURRENT_DATE)) AS contacts_this_month,
        (SELECT COUNT(*) FROM contacts WHERE created_at >= CURRENT_DATE) AS contacts_today;
END;
$$ LANGUAGE plpgsql;

-- Grant permissions (adjust username as needed)
-- GRANT ALL PRIVILEGES ON TABLE contacts TO your_username;
-- GRANT USAGE, SELECT ON SEQUENCE contacts_id_seq TO your_username;