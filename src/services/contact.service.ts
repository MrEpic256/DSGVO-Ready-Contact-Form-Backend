import { pool } from '../config/database';
import { ContactSubmission, ContactSubmissionDTO } from '../models/contact.model';

/**
 * Service layer for contact form operations
 * Implements DSGVO-compliant data handling
 */

export class ContactService {
  /**
   * Create a new contact submission
   * @param submission - Contact form data with anonymized IP
   * @returns Created submission DTO
   */
  async createSubmission(submission: ContactSubmission): Promise<ContactSubmissionDTO> {
    const query = `
      INSERT INTO contact_submissions 
        (name, email, message, consent_given, anonymized_ip, user_agent)
      VALUES 
        ($1, $2, $3, $4, $5, $6)
      RETURNING id, name, email, message, submitted_at
    `;

    const values = [
      submission.name,
      submission.email,
      submission.message,
      submission.consent_given,
      submission.anonymized_ip,
      submission.user_agent,
    ];

    try {
      const result = await pool.query(query, values);
      return result.rows[0];
    } catch (error) {
      console.error('Database error during submission:', error);
      throw new Error('Failed to save contact submission');
    }
  }

  /**
   * Delete all submissions associated with an email
   * Implements "Right to be Forgotten" (Recht auf Vergessenwerden)
   * 
   * @param email - Email address to delete
   * @returns Number of deleted records
   */
  async deleteByEmail(email: string): Promise<number> {
    const query = `
      DELETE FROM contact_submissions 
      WHERE email = $1
      RETURNING id
    `;

    try {
      const result = await pool.query(query, [email]);
      const deletedCount = result.rowCount || 0;
      
      console.log(`DSGVO deletion: Removed ${deletedCount} record(s) for email: ${email}`);
      
      return deletedCount;
    } catch (error) {
      console.error('Database error during deletion:', error);
      throw new Error('Failed to delete contact submissions');
    }
  }

  /**
   * Delete submissions older than specified months
   * Implements automatic data retention policy
   * 
   * @param months - Number of months to retain data
   * @returns Number of deleted records
   */
  async deleteOlderThan(months: number): Promise<number> {
    const query = `
      DELETE FROM contact_submissions 
      WHERE submitted_at < NOW() - INTERVAL '${months} months'
      RETURNING id
    `;

    try {
      const result = await pool.query(query);
      const deletedCount = result.rowCount || 0;
      
      console.log(`Auto-cleanup: Removed ${deletedCount} record(s) older than ${months} months`);
      
      return deletedCount;
    } catch (error) {
      console.error('Database error during auto-cleanup:', error);
      throw new Error('Failed to execute auto-cleanup');
    }
  }

  /**
   * Get submission count for a specific email (for auditing)
   * @param email - Email address
   * @returns Number of submissions
   */
  async getSubmissionCountByEmail(email: string): Promise<number> {
    const query = `
      SELECT COUNT(*) as count
      FROM contact_submissions 
      WHERE email = $1
    `;

    try {
      const result = await pool.query(query, [email]);
      return parseInt(result.rows[0].count, 10);
    } catch (error) {
      console.error('Database error during count query:', error);
      throw new Error('Failed to count submissions');
    }
  }
}

export default new ContactService();
