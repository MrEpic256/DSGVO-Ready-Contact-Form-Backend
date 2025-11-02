import * as dotenv from 'dotenv';
import { pool } from '../config/database';
import contactService from '../services/contact.service';

dotenv.config();

/**
 * Cleanup Job for DSGVO Data Retention Compliance
 * 
 * This job automatically deletes contact submissions older than
 * the configured retention period (default: 6 months).
 * 
 * Usage:
 *   npm run cleanup
 * 
 * Or configure as a cron job:
 *   0 0 * * * cd /path/to/project && npm run cleanup
 */

async function runCleanup(): Promise<void> {
  console.log('='.repeat(50));
  console.log('DSGVO Data Retention Cleanup Job');
  console.log('='.repeat(50));
  console.log(`Started at: ${new Date().toISOString()}`);

  try {
    const retentionMonths = parseInt(
      process.env.DATA_RETENTION_MONTHS || '6',
      10
    );

    console.log(`Retention policy: ${retentionMonths} months`);
    console.log('Searching for old records...');

    const deletedCount = await contactService.deleteOlderThan(retentionMonths);

    console.log('='.repeat(50));
    console.log(`✓ Cleanup completed successfully`);
    console.log(`✓ Records deleted: ${deletedCount}`);
    console.log(`✓ Completed at: ${new Date().toISOString()}`);
    console.log('='.repeat(50));

    process.exit(0);
  } catch (error) {
    console.error('='.repeat(50));
    console.error('✗ Cleanup failed:', error);
    console.error('='.repeat(50));
    process.exit(1);
  } finally {
    await pool.end();
  }
}

// Run the cleanup job
runCleanup();
