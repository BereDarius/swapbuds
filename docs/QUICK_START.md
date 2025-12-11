# 🚀 Quick Start Guide

> **Get SWAPBUDS running in 5 minutes**

This guide will help you set up and run SWAPBUDS locally for development.

---

## Prerequisites

Before you begin, ensure you have:

- **Node.js 20+** (LTS recommended)
- **Yarn** package manager
- **PostgreSQL 15+** database
- **Redis** (for caching)
- **Docker** (optional, for containerized services)

---

## Option 1: Quick Start with Docker (Recommended)

The fastest way to get everything running:

```bash
# Clone the repository
git clone https://github.com/BereDarius/swapbuds.git
cd swapbuds

# Start all services with Docker
yarn docker:up

# Install dependencies
yarn install:all

# Setup environment files
cp swapbuds-backend/.env.example swapbuds-backend/.env
cp swapbuds-frontend/.env.example swapbuds-frontend/.env

# Run database migrations
cd swapbuds-backend
yarn prisma:migrate

# Start development servers
cd ..
yarn dev
```

✅ **Done!** Your application should now be running:

- Frontend: http://localhost:3000
- Backend API: http://localhost:3001
- API Docs: http://localhost:3001/api/docs

---

## Option 2: Manual Setup

### Step 1: Clone and Install

```bash
# Clone the repository
git clone https://github.com/BereDarius/swapbuds.git
cd swapbuds

# Install all dependencies
yarn install:all
```

### Step 2: Setup Database

```bash
# Start PostgreSQL (if not running)
# On macOS with Homebrew:
brew services start postgresql@15

# Create database
createdb swapbuds

# Start Redis
brew services start redis
```

### Step 3: Configure Environment

**Backend** (`swapbuds-backend/.env`):

```env
NODE_ENV=development
PORT=3001

# Database
DATABASE_URL="postgresql://localhost:5432/swapbuds"

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-this

# API
API_PREFIX=api
```

**Frontend** (`swapbuds-frontend/.env.local`):

```env
NEXT_PUBLIC_API_URL=http://localhost:3001/api
```

### Step 4: Initialize Database

```bash
cd swapbuds-backend

# Run migrations
yarn prisma:migrate

# (Optional) Seed with sample data
yarn prisma:seed
```

### Step 5: Start Development Servers

```bash
# From project root
yarn dev

# Or start individually:
cd swapbuds-backend && yarn dev  # Terminal 1
cd swapbuds-frontend && yarn dev  # Terminal 2
```

---

## Verify Installation

### Check Backend API

Visit http://localhost:3001/api/health

You should see:

```json
{
  "status": "ok",
  "database": "connected",
  "redis": "connected"
}
```

### Check Frontend

Visit http://localhost:3000

You should see the SWAPBUDS landing page.

### Check API Documentation

Visit http://localhost:3001/api/docs

Interactive Swagger/OpenAPI documentation.

---

## Common Tasks

### Run Tests

```bash
# Backend tests
cd swapbuds-backend
yarn test

# Frontend tests
cd swapbuds-frontend
yarn test
```

### View Database

```bash
cd swapbuds-backend
yarn prisma:studio
```

Opens Prisma Studio at http://localhost:5555

### Reset Database

```bash
cd swapbuds-backend
yarn prisma:reset
```

### Format Code

```bash
# Format all code
yarn format

# Lint and fix
yarn lint:fix
```

---

## VS Code Tasks

We provide VS Code tasks for common operations. Press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Windows/Linux) and type "Run Task":

- **🚀 Start Both Apps** - Runs frontend and backend
- **🔵 Start Backend** - Backend only
- **🟠 Start Frontend** - Frontend only
- **🐳 Docker: Start Services** - Start PostgreSQL + Redis
- **🗄️ Database: Studio** - Open Prisma Studio

---

## Troubleshooting

### Port Already in Use

```bash
# Find and kill process on port 3001 (backend)
lsof -ti:3001 | xargs kill -9

# Find and kill process on port 3000 (frontend)
lsof -ti:3000 | xargs kill -9
```

### Database Connection Issues

```bash
# Check PostgreSQL is running
pg_isready

# Check connection string in .env
# Ensure DATABASE_URL format is correct
```

### Redis Connection Issues

```bash
# Check Redis is running
redis-cli ping
# Should return: PONG
```

### Clean Install

```bash
# Remove all dependencies
yarn clean

# Reinstall everything
yarn install:all
```

---

## Next Steps

Now that you're up and running:

1. **Explore the API** - Visit http://localhost:3001/api/docs
2. **Read Architecture Docs** - See [Architecture Overview](./ARCHITECTURE.md)
3. **Start Developing** - Check [Development Setup](./development/SETUP.md)
4. **Run Tests** - Follow [Testing Guide](./development/TESTING.md)

---

## Need Help?

- **Documentation**: See [docs/README.md](./README.md)
- **Issues**: Open a GitHub issue
- **Backend Details**: [swapbuds-backend/README.md](../swapbuds-backend/README.md)
- **Frontend Details**: [swapbuds-frontend/README.md](../swapbuds-frontend/README.md)

---

_For detailed setup instructions, see [Development Setup](./development/SETUP.md)_
