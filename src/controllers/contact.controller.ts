import { Request, Response } from 'express';
import contactService from '../services/contact.service';
import { ContactSubmissionInput } from '../models/contact.model';
import { anonymizeIPv4, sanitizeUserAgent } from '../utils/anonymization.utils';

/**
 * Controller for handling contact form requests
 * Implements DSGVO-compliant data processing
 */

export class ContactController {
  /**
   * Handle contact form submission
   * POST /api/v1/contact/submit
   */
  async submitContact(req: Request, res: Response): Promise<void> {
    try {
      const input: ContactSubmissionInput = req.body;

      // Extract and anonymize IP address
      const clientIP = (req.headers['x-forwarded-for'] as string)?.split(',')[0] 
                       || req.socket.remoteAddress 
                       || 'unknown';
      const anonymizedIP = anonymizeIPv4(clientIP);

      // Sanitize user agent
      const userAgent = sanitizeUserAgent(req.headers['user-agent']);

      // Create submission object with anonymized data
      const submission = {
        name: input.name,
        email: input.email,
        message: input.message,
        consent_given: input.consent_checkbox,
        anonymized_ip: anonymizedIP,
        user_agent: userAgent,
      };

      // Save to database
      const result = await contactService.createSubmission(submission);

      // Return success response (without sensitive IP data)
      res.status(201).json({
        success: true,
        message: 'Contact form submitted successfully',
        data: {
          id: result.id,
          submitted_at: result.submitted_at,
        },
      });
    } catch (error) {
      console.error('Error in submitContact:', error);
      res.status(500).json({
        success: false,
        error: 'Failed to process contact form submission',
      });
    }
  }

  /**
   * Delete all submissions for a specific email
   * DELETE /api/v1/contact/delete/:email
   * Requires admin authentication
   */
  async deleteByEmail(req: Request, res: Response): Promise<void> {
    try {
      const { email } = req.params;

      if (!email) {
        res.status(400).json({
          success: false,
          error: 'Email parameter is required',
        });
        return;
      }

      // Check if any records exist before deletion
      const count = await contactService.getSubmissionCountByEmail(email);

      if (count === 0) {
        res.status(404).json({
          success: false,
          message: 'No submissions found for this email',
          email,
        });
        return;
      }

      // Perform deletion (Right to be Forgotten)
      const deletedCount = await contactService.deleteByEmail(email);

      res.status(200).json({
        success: true,
        message: 'All submissions deleted successfully (DSGVO compliance)',
        email,
        deleted_count: deletedCount,
      });
    } catch (error) {
      console.error('Error in deleteByEmail:', error);
      res.status(500).json({
        success: false,
        error: 'Failed to delete submissions',
      });
    }
  }

  /**
   * Manually trigger cleanup of old records
   * POST /api/v1/contact/cleanup
   * Requires admin authentication
   */
  async cleanupOldRecords(req: Request, res: Response): Promise<void> {
    try {
      const retentionMonths = parseInt(
        process.env.DATA_RETENTION_MONTHS || '6',
        10
      );

      const deletedCount = await contactService.deleteOlderThan(retentionMonths);

      res.status(200).json({
        success: true,
        message: `Cleanup completed: ${deletedCount} old record(s) deleted`,
        retention_policy: `${retentionMonths} months`,
        deleted_count: deletedCount,
      });
    } catch (error) {
      console.error('Error in cleanupOldRecords:', error);
      res.status(500).json({
        success: false,
        error: 'Failed to execute cleanup',
      });
    }
  }
}

export default new ContactController();
