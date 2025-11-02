import express, { Application, Request, Response } from 'express';
import helmet from 'helmet';
import cors from 'cors';
import * as dotenv from 'dotenv';
import contactRoutes from './routes/contact.routes';
import { testConnection, initializeDatabase } from './config/database';

// Load environment variables
dotenv.config();

const app: Application = express();
const PORT = process.env.PORT || 3000;

/**
 * Security middleware
 */
app.use(helmet()); // Security headers
app.use(cors({
  origin: process.env.CORS_ORIGIN || '*',
  credentials: true,
}));

/**
 * Body parsing middleware
 */
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

/**
 * Request logging middleware
 */
app.use((req: Request, _res: Response, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

/**
 * Health check endpoint
 */
app.get('/health', (_req: Request, res: Response) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'DSGVO Contact Form Backend',
  });
});

/**
 * API Routes
 */
app.use('/api/v1/contact', contactRoutes);

/**
 * 404 handler
 */
app.use((_req: Request, res: Response) => {
  res.status(404).json({
    success: false,
    error: 'Endpoint not found',
  });
});

/**
 * Global error handler
 */
app.use((err: Error, _req: Request, res: Response, _next: any) => {
  console.error('Unhandled error:', err);
  res.status(500).json({
    success: false,
    error: 'Internal server error',
  });
});

/**
 * Start server
 */
async function startServer(): Promise<void> {
  try {
    // Test database connection
    const dbConnected = await testConnection();
    if (!dbConnected) {
      console.error('Failed to connect to database. Exiting...');
      process.exit(1);
    }

    // Initialize database schema
    await initializeDatabase();

    // Start listening
    app.listen(PORT, () => {
      console.log('='.repeat(50));
      console.log('🚀 DSGVO Contact Form Backend');
      console.log('='.repeat(50));
      console.log(`✓ Server running on port ${PORT}`);
      console.log(`✓ Environment: ${process.env.NODE_ENV || 'development'}`);
      console.log(`✓ Data retention: ${process.env.DATA_RETENTION_MONTHS || 6} months`);
      console.log('='.repeat(50));
      console.log('\nAvailable endpoints:');
      console.log(`  POST   /api/v1/contact/submit   - Submit contact form`);
      console.log(`  DELETE /api/v1/contact/delete/:email - Delete by email (admin)`);
      console.log(`  POST   /api/v1/contact/cleanup  - Trigger cleanup (admin)`);
      console.log(`  GET    /health                  - Health check`);
      console.log('='.repeat(50));
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

// Start the server
startServer();

export default app;
