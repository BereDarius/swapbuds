# 🎮 SWAPBUDS

> **Your Community Trading Platform** - Discover. Trade. Connect.

A peer-to-peer item trading platform built for collectors, gamers, anime fans, and anyone looking to swap items with their community.

[![TypeScript](https://img.shields.io/badge/TypeScript-5.0-blue.svg)](https://www.typescriptlang.org/)
[![NestJS](https://img.shields.io/badge/NestJS-10-red.svg)](https://nestjs.com/)
[![Next.js](https://img.shields.io/badge/Next.js-14-black.svg)](https://nextjs.org/)

---

## 📖 Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Quick Start](#-quick-start)
- [Development](#-development)
- [Documentation](#-documentation)

---

## ✨ Features

- 🔄 **Item Trading** - Propose and manage trades with other users
- 📸 **Image Upload** - Upload multiple images via Cloudinary
- 💬 **Real-time Chat** - Live messaging for trade negotiations
- 🔔 **Notifications** - Stay updated on trades and messages
- ⭐ **Reputation System** - Build trust through successful trades
- 🔍 **Search & Filter** - Find items by category, condition, and more
- 👤 **User Profiles** - Showcase your collection and trading history
- 📱 **Responsive Design** - Works seamlessly on desktop and mobile

---

## 🛠️ Tech Stack

### Backend

- **NestJS** - Progressive Node.js framework
- **Prisma** - Next-generation ORM
- **PostgreSQL** - Reliable relational database
- **Socket.IO** - Real-time bidirectional communication
- **JWT** - Secure authentication
- **TypeScript** - Type-safe development

### Frontend

- **Next.js 14** - React framework with App Router
- **TanStack Query** - Powerful data fetching
- **Zustand** - Lightweight state management
- **TailwindCSS** - Utility-first CSS framework
- **Socket.IO Client** - Real-time updates
- **TypeScript** - Type-safe development

### Infrastructure

- **Vercel** - Serverless deployment (Frontend & Backend)
- **Vercel Postgres** - Managed PostgreSQL database
- **Cloudinary** - Image hosting and optimization
- **Docker** - Local development environment
- **GitHub Actions** - CI/CD pipeline

---

## 📁 Project Structure

This is a **coordination repository** that manages two independent submodules:

```
swapbuds/                       # 📦 Coordination Repo (this repo)
├── .vscode/                    # VS Code workspace configuration
│   ├── settings.json           # Editor settings
│   ├── extensions.json         # Recommended extensions
│   ├── launch.json             # Debug configurations
│   └── tasks.json              # Task definitions
├── docs/                       # 📚 Documentation
│   ├── ARCHITECTURE.md         # System architecture
│   ├── API.md                  # API documentation
│   └── CONTRIBUTING.md         # Contribution guidelines
├── scripts/                    # 🔧 Helper scripts
│   ├── setup.sh                # First-time setup
│   └── reset-db.sh             # Database reset
├── swapbuds-backend/           # 🔵 Backend (Git Submodule)
│   └── → Separate repo: github.com/BereDarius/swapbuds-backend
├── swapbuds-frontend/          # 🟠 Frontend (Git Submodule)
│   └── → Separate repo: github.com/BereDarius/swapbuds-frontend
├── docker-compose.yml          # 🐳 Local services
├── package.json                # 📦 Convenience scripts
├── swapbuds.code-workspace     # 💻 VS Code workspace file
└── README.md                   # 📖 You are here
```

### Submodules

- **Backend:** [github.com/BereDarius/swapbuds-backend](https://github.com/BereDarius/swapbuds-backend)
- **Frontend:** [github.com/BereDarius/swapbuds-frontend](https://github.com/BereDarius/swapbuds-frontend)

---

## 🚀 Quick Start

### Prerequisites

- **Node.js** 18+ ([Download](https://nodejs.org/))
- **Yarn** 1.22+ (`npm install -g yarn`)
- **Docker Desktop** ([Download](https://www.docker.com/products/docker-desktop))
- **Git** ([Download](https://git-scm.com/))

### Installation

1. **Clone with Submodules**

   ```bash
   git clone --recurse-submodules https://github.com/BereDarius/swapbuds.git
   cd swapbuds
   ```

   Or if already cloned:

   ```bash
   git submodule update --init --recursive
   ```

2. **Run Setup Script**

   ```bash
   ./scripts/setup.sh
   ```

   This will:

   - ✅ Install all dependencies
   - ✅ Start Docker services (PostgreSQL, Redis, Adminer)
   - ✅ Run database migrations
   - ✅ Create environment files

3. **Configure Environment**

   ```bash
   # Backend
   cd swapbuds-backend
   cp .env.example .env
   # Edit .env and add your Cloudinary credentials

   # Frontend
   cd ../swapbuds-frontend
   cp .env.example .env.local
   ```

4. **Start Development Servers**

   ```bash
   cd ..
   yarn dev
   ```

5. **Open in Browser**
   - Frontend: http://localhost:3000
   - Backend: http://localhost:3001
   - Adminer: http://localhost:8080

---

## 💻 Development

### Open in VS Code

```bash
code swapbuds.code-workspace
```

This opens a multi-root workspace with all three repos (parent, backend, frontend).

### Available Scripts

```bash
# Development
yarn dev                # Start both backend and frontend
yarn dev:backend        # Start backend only
yarn dev:frontend       # Start frontend only

# Building
yarn build              # Build both apps
yarn build:backend      # Build backend only
yarn build:frontend     # Build frontend only

# Code Quality
yarn lint               # Lint both apps
yarn format             # Format both apps

# Docker
yarn docker:up          # Start PostgreSQL, Redis, Adminer
yarn docker:down        # Stop all services
yarn docker:logs        # View logs
yarn docker:clean       # Remove all volumes

# Database
yarn db:migrate         # Run Prisma migrations
yarn db:studio          # Open Prisma Studio
yarn db:reset           # Reset database (DESTRUCTIVE!)

# Maintenance
yarn clean              # Remove all node_modules
yarn install:all        # Install deps in all projects
yarn update:submodules  # Pull latest from submodules
```

### VS Code Tasks

Press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Windows/Linux) and type "Run Task":

- 🚀 Start Both Apps
- 🔵 Start Backend
- 🟠 Start Frontend
- 🐳 Docker: Start/Stop Services
- 🗄️ Database: Migrate/Studio/Reset
- 🧹 Clean All
- 📦 Install All Dependencies
- 🔍 Lint All
- ✨ Format All

### Debugging

Use VS Code's debug panel (F5):

- **🚀 Full Stack (Both)** - Debug both apps simultaneously
- **🔵 Backend (NestJS)** - Debug backend only
- **🟠 Frontend (Next.js)** - Debug frontend only

---

## 📚 Documentation

- [Architecture Overview](./docs/ARCHITECTURE.md)
- [API Documentation](./docs/API.md)
- [Backend README](./swapbuds-backend/README.md)
- [Frontend README](./swapbuds-frontend/README.md)

---

## 🗄️ Database

### Local Development (Docker)

PostgreSQL runs locally via Docker:

```bash
yarn docker:up
```

**Connection Details:**

- Host: `localhost`
- Port: `5432`
- Database: `swapbuds_dev`
- User: `swapbuds_dev`
- Password: `swapbuds_dev_password`

### Adminer (Database UI)

Access at http://localhost:8080

- System: `PostgreSQL`
- Server: `postgres`
- Username: `swapbuds_dev`
- Password: `swapbuds_dev_password`
- Database: `swapbuds_dev`

### Prisma Studio

```bash
yarn db:studio
```

Opens at http://localhost:5555

---

## 🌐 Deployment

### Vercel (Recommended)

Both backend and frontend deploy to Vercel:

1. **Backend**

   ```bash
   cd swapbuds-backend
   vercel
   ```

2. **Frontend**

   ```bash
   cd swapbuds-frontend
   vercel
   ```

3. **Set Environment Variables** in Vercel dashboard
   - Backend: DATABASE*URL, JWT_SECRET, CLOUDINARY*\*
   - Frontend: NEXT*PUBLIC_API_URL, NEXT_PUBLIC_CLOUDINARY*\*

---

## 🐛 Troubleshooting

### Submodules Not Initialized

```bash
git submodule update --init --recursive
```

### Docker Issues

```bash
# Restart services
yarn docker:down
yarn docker:up

# Clean everything (removes volumes)
yarn docker:clean
```

### Port Already in Use

```bash
# Find process on port 3000 (macOS/Linux)
lsof -ti:3000 | xargs kill -9

# Find process on port 3000 (Windows)
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

### Prisma Issues

```bash
# Regenerate Prisma Client
cd swapbuds-backend
yarn prisma generate

# Reset database
cd ..
yarn db:reset
```

---

## 🙏 Acknowledgments

- [NestJS](https://nestjs.com/) - Progressive Node.js framework
- [Next.js](https://nextjs.org/) - The React Framework
- [Prisma](https://www.prisma.io/) - Next-generation ORM
- [Cloudinary](https://cloudinary.com/) - Image and video management
- [Vercel](https://vercel.com/) - Deployment platform
- [TailwindCSS](https://tailwindcss.com/) - CSS framework

---

## 📬 Contact

- **GitHub:** [@BereDarius](https://github.com/BereDarius)
- **Project:** [github.com/BereDarius/swapbuds](https://github.com/BereDarius/swapbuds)

---

<div align="center">
  <p>Made with ❤️ by BereDarius</p>
  <p>⭐ Star this repo if you find it useful!</p>
</div>
