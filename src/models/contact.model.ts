/**
 * Contact Submission Model
 * Represents the data structure for contact form submissions
 */

export interface ContactSubmission {
  id?: number;
  name: string;
  email: string;
  message: string;
  consent_given: boolean;
  anonymized_ip?: string;
  user_agent?: string;
  submitted_at?: Date;
}

export interface ContactSubmissionInput {
  name: string;
  email: string;
  message: string;
  consent_checkbox: boolean;
}

export interface ContactSubmissionDTO {
  id: number;
  name: string;
  email: string;
  message: string;
  submitted_at: Date;
}
