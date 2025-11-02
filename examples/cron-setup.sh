#!/bin/bash

# DSGVO Contact Form - Automated Cleanup Cron Job Setup
# This script sets up a daily cron job to automatically clean old records

# Configuration
PROJECT_DIR="/path/to/DSGVO-Ready Contact Form Backend"
LOG_DIR="/var/log/dsgvo-cleanup"
NODE_PATH=$(which node)
NPM_PATH=$(which npm)

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Cron job command
CRON_COMMAND="0 2 * * * cd '$PROJECT_DIR' && $NPM_PATH run cleanup >> $LOG_DIR/cleanup.log 2>&1"

# Check if cron job already exists
if crontab -l 2>/dev/null | grep -q "dsgvo.*cleanup"; then
    echo "⚠️  Cron job already exists. Please remove it manually if you want to reinstall."
    echo "Run: crontab -e"
    exit 1
fi

# Add cron job
(crontab -l 2>/dev/null; echo "# DSGVO Contact Form - Daily Cleanup (runs at 2 AM)") | crontab -
(crontab -l 2>/dev/null; echo "$CRON_COMMAND") | crontab -

echo "✓ Cron job installed successfully!"
echo "✓ Cleanup will run daily at 2:00 AM"
echo "✓ Logs will be written to: $LOG_DIR/cleanup.log"
echo ""
echo "To view current cron jobs, run: crontab -l"
echo "To edit cron jobs, run: crontab -e"
echo "To view cleanup logs, run: tail -f $LOG_DIR/cleanup.log"
