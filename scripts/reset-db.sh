#!/bin/bash

# SWAPBUDS - Reset Database Script
# WARNING: This will DELETE all data in your local database!

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}⚠️  WARNING: This will DELETE all data in your local database!${NC}"
echo ""
read -p "Are you sure you want to continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "🗄️  Resetting database..."
echo ""

# Check if backend exists
if [ ! -d "swapbuds-backend" ]; then
    echo -e "${RED}❌ Backend directory not found${NC}"
    exit 1
fi

cd swapbuds-backend

# Reset Prisma migrations
echo "→ Resetting Prisma migrations..."
yarn prisma migrate reset --force

echo ""
echo -e "${GREEN}✅ Database reset complete!${NC}"
echo ""
echo "The database has been:"
echo "  1. Dropped"
echo "  2. Recreated"
echo "  3. All migrations re-applied"
echo "  4. Seed data added (if configured)"
