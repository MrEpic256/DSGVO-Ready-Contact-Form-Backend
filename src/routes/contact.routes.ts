import { Router } from 'express';
import contactController from '../controllers/contact.controller';
import {
  validateContactSubmission,
  handleValidationErrors,
  validateAdminKey,
} from '../middleware/validation.middleware';

const router = Router();

/**
 * Public endpoint for contact form submission
 * POST /api/v1/contact/submit
 * 
 * Body: {
 *   name: string,
 *   email: string,
 *   message: string,
 *   consent_checkbox: boolean
 * }
 */
router.post(
  '/submit',
  validateContactSubmission,
  handleValidationErrors,
  contactController.submitContact.bind(contactController)
);

/**
 * Admin endpoint to delete submissions by email (Right to be Forgotten)
 * DELETE /api/v1/contact/delete/:email
 * 
 * Headers: {
 *   x-admin-key: string
 * }
 */
router.delete(
  '/delete/:email',
  validateAdminKey,
  contactController.deleteByEmail.bind(contactController)
);

/**
 * Admin endpoint to manually trigger cleanup of old records
 * POST /api/v1/contact/cleanup
 * 
 * Headers: {
 *   x-admin-key: string
 * }
 */
router.post(
  '/cleanup',
  validateAdminKey,
  contactController.cleanupOldRecords.bind(contactController)
);

export default router;
