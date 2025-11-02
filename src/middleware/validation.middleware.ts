import { Request, Response, NextFunction } from 'express';
import { body, validationResult } from 'express-validator';

/**
 * Validation rules for contact form submission
 * Ensures DSGVO compliance by validating consent
 */
export const validateContactSubmission = [
  body('name')
    .trim()
    .notEmpty()
    .withMessage('Name is required')
    .isLength({ min: 2, max: 255 })
    .withMessage('Name must be between 2 and 255 characters')
    .escape(),
  
  body('email')
    .trim()
    .notEmpty()
    .withMessage('Email is required')
    .isEmail()
    .withMessage('Valid email is required')
    .normalizeEmail()
    .isLength({ max: 255 })
    .withMessage('Email is too long'),
  
  body('message')
    .trim()
    .notEmpty()
    .withMessage('Message is required')
    .isLength({ min: 10, max: 5000 })
    .withMessage('Message must be between 10 and 5000 characters')
    .escape(),
  
  body('consent_checkbox')
    .notEmpty()
    .withMessage('Consent is required')
    .isBoolean()
    .withMessage('Consent must be a boolean value')
    .custom((value) => {
      if (value !== true) {
        throw new Error('Consent must be explicitly granted for DSGVO compliance');
      }
      return true;
    }),
];

/**
 * Middleware to handle validation errors
 */
export function handleValidationErrors(
  req: Request,
  res: Response,
  next: NextFunction
): void {
  const errors = validationResult(req);
  
  if (!errors.isEmpty()) {
    res.status(400).json({
      success: false,
      error: 'Validation failed',
      details: errors.array().map(err => ({
        field: err.type === 'field' ? err.path : undefined,
        message: err.msg
      }))
    });
    return;
  }
  
  next();
}

/**
 * Middleware to validate admin API key
 */
export function validateAdminKey(
  req: Request,
  res: Response,
  next: NextFunction
): void {
  const apiKey = req.headers['x-admin-key'] as string;
  const validKey = process.env.ADMIN_API_KEY;

  if (!validKey) {
    res.status(500).json({
      success: false,
      error: 'Admin functionality not configured'
    });
    return;
  }

  if (!apiKey || apiKey !== validKey) {
    res.status(401).json({
      success: false,
      error: 'Unauthorized - Invalid admin key'
    });
    return;
  }

  next();
}
