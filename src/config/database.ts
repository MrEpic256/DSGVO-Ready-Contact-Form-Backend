import { Pool, PoolConfig } from 'pg';
import * as dotenv from 'dotenv';

dotenv.config();

const poolConfig: PoolConfig = {
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432', 10),
  database: process.env.DB_NAME || 'dsgvo_contacts',
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
};

// Create PostgreSQL connection pool
export const pool = new Pool(poolConfig);

// Handle pool errors
pool.on('error', (err) => {
  console.error('Unexpected error on idle client', err);
  process.exit(-1);
});

/**
 * Test database connection
 */
export async function testConnection(): Promise<boolean> {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT NOW()');
    console.log('✓ Database connected successfully at:', result.rows[0].now);
    client.release();
    return true;
  } catch (error) {
    console.error('✗ Database connection failed:', error);
    return false;
  }
}

/**
 * Initialize database schema
 */
export async function initializeDatabase(): Promise<void> {
  const client = await pool.connect();
  
  try {
    await client.query(`
      CREATE TABLE IF NOT EXISTS contact_submissions (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        message TEXT NOT NULL,
        consent_given BOOLEAN NOT NULL DEFAULT FALSE,
        anonymized_ip VARCHAR(15),
        user_agent VARCHAR(500),
        submitted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        
        CONSTRAINT consent_must_be_true CHECK (consent_given = TRUE)
      );
      
      CREATE INDEX IF NOT EXISTS idx_contact_email ON contact_submissions(email);
      CREATE INDEX IF NOT EXISTS idx_contact_submitted_at ON contact_submissions(submitted_at);
    `);
    
    console.log('✓ Database schema initialized');
  } catch (error) {
    console.error('✗ Database initialization failed:', error);
    throw error;
  } finally {
    client.release();
  }
}
