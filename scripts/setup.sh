#!/bin/bash

# SWAPBUDS - First-time Setup Script
# This script sets up your local development environment

set -e  # Exit on error

echo "🚀 SWAPBUDS Setup Script"
echo "========================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if running from project root
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ Error: Please run this script from the project root${NC}"
    exit 1
fi

# Check prerequisites
echo "📋 Checking prerequisites..."
echo ""

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed${NC}"
    echo "   Please install Docker Desktop: https://www.docker.com/products/docker-desktop"
    exit 1
else
    echo -e "${GREEN}✅ Docker found${NC}"
fi

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed${NC}"
    exit 1
else
    echo -e "${GREEN}✅ Docker Compose found${NC}"
fi

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed${NC}"
    echo "   Please install Node.js 18+: https://nodejs.org/"
    exit 1
else
    NODE_VERSION=$(node -v)
    echo -e "${GREEN}✅ Node.js found ($NODE_VERSION)${NC}"
fi

# Check Yarn
if ! command -v yarn &> /dev/null; then
    echo -e "${YELLOW}⚠️  Yarn is not installed. Installing...${NC}"
    npm install -g yarn
    echo -e "${GREEN}✅ Yarn installed${NC}"
else
    YARN_VERSION=$(yarn -v)
    echo -e "${GREEN}✅ Yarn found ($YARN_VERSION)${NC}"
fi

echo ""
echo "📦 Installing dependencies..."
echo ""

# Install root dependencies
echo "→ Installing root dependencies..."
yarn install

# Install backend dependencies
if [ -d "swapbuds-backend" ]; then
    echo "→ Installing backend dependencies..."
    cd swapbuds-backend
    yarn install
    cd ..
else
    echo -e "${YELLOW}⚠️  Backend submodule not found. Run: git submodule update --init${NC}"
fi

# Install frontend dependencies
if [ -d "swapbuds-frontend" ]; then
    echo "→ Installing frontend dependencies..."
    cd swapbuds-frontend
    yarn install
    cd ..
else
    echo -e "${YELLOW}⚠️  Frontend submodule not found. Run: git submodule update --init${NC}"
fi

echo ""
echo "🐳 Starting Docker services..."
echo ""

# Start Docker services
docker-compose up -d

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 5

# Check if PostgreSQL is ready
until docker-compose exec -T postgres pg_isready -U swapbuds_dev > /dev/null 2>&1; do
    echo "   Still waiting for PostgreSQL..."
    sleep 2
done

echo -e "${GREEN}✅ PostgreSQL is ready${NC}"

echo ""
echo "🗄️  Setting up database..."
echo ""

# Run Prisma migrations if backend exists
if [ -d "swapbuds-backend" ] && [ -f "swapbuds-backend/prisma/schema.prisma" ]; then
    echo "→ Running Prisma migrations..."
    cd swapbuds-backend
    yarn prisma migrate dev --name init || echo -e "${YELLOW}⚠️  No migrations to run yet${NC}"
    cd ..
else
    echo -e "${YELLOW}⚠️  Prisma schema not found yet. You'll need to run migrations later.${NC}"
fi

echo ""
echo "📝 Creating environment files..."
echo ""

# Create backend .env if it doesn't exist
if [ -d "swapbuds-backend" ] && [ ! -f "swapbuds-backend/.env" ]; then
    echo "→ Creating backend/.env from .env.example..."
    if [ -f "swapbuds-backend/.env.example" ]; then
        cp swapbuds-backend/.env.example swapbuds-backend/.env
        echo -e "${GREEN}✅ Created backend/.env${NC}"
        echo -e "${YELLOW}⚠️  Don't forget to update it with your Cloudinary credentials!${NC}"
    fi
fi

# Create frontend .env.local if it doesn't exist
if [ -d "swapbuds-frontend" ] && [ ! -f "swapbuds-frontend/.env.local" ]; then
    echo "→ Creating frontend/.env.local from .env.example..."
    if [ -f "swapbuds-frontend/.env.example" ]; then
        cp swapbuds-frontend/.env.example swapbuds-frontend/.env.local
        echo -e "${GREEN}✅ Created frontend/.env.local${NC}"
    fi
fi

echo ""
echo "✨ Setup complete!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📚 Next steps:"
echo ""
echo "  1. Update environment variables in backend/.env"
echo "     - Add your Cloudinary credentials"
echo "     - Update JWT_SECRET"
echo ""
echo "  2. Start the development servers:"
echo "     $ yarn dev"
echo ""
echo "  3. Or start them individually:"
echo "     $ yarn dev:backend   # Starts on port 3001"
echo "     $ yarn dev:frontend  # Starts on port 3000"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🌐 Services:"
echo "   Frontend:  http://localhost:3000"
echo "   Backend:   http://localhost:3001"
echo "   Adminer:   http://localhost:8080 (DB admin)"
echo "   PostgreSQL: localhost:5432"
echo "   Redis:     localhost:6379"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${GREEN}Happy coding! 🎮${NC}"
