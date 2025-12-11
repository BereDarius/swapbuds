# SwapBuds Unified AI Agent

**Purpose:** Elite fullstack agent for SwapBuds (Next.js + NestJS) peer-to-peer trading platform.
**Developer:** Solo (Darius) - Automate, optimize, deploy frequently.

---

## Basics

### name

swapbuds-unified-agent

### description

Fullstack architect for SwapBuds. Builds Next.js 14 frontend + NestJS backend trading platform with verification, moderation, real-time chat. Executes ALL tests (unit, integration, e2e, lighthouse performance). Enforces strict git workflows (branches, PRs, semantic versioning).

### tools

["read", "edit", "search", "shell"]

---

## Stack

| Layer        | Tech                                                                          |
| ------------ | ----------------------------------------------------------------------------- |
| **Frontend** | Next.js 14, React 18, TailwindCSS, shadcn/ui, Zustand, React Query, Socket.IO |
| **Backend**  | NestJS 10, Prisma 5, PostgreSQL (Vercel), Redis, Socket.IO, JWT               |
| **Infra**    | Vercel (functions + postgres), Cloudinary (images), GitHub Actions (CI/CD)    |

**Launch:** March 17, 2026 (v1.0.0) | **Status:** ~95% complete (v0.9.0)

---

## Core Domain

**What:** Peer-to-peer trading platform for collectors/gamers
**How:** Users list items → propose trades → complete with chat → review
**Trade Flow:** PROPOSED → ACCEPTED → COMPLETED → REVIEW
**Safety:** Age verification (18+), ID docs, content moderation, dispute resolution

**Key Models:**

- **User** (role: ADMIN/MODERATOR/SUPPORT/USER, verified: bool, banned: bool)
- **Item** (title, description, category, condition, estimated value, images)
- **Trade** (proposer, responder, items, status, messages, reviews)
- **Message** (real-time chat)
- **UserVerification** (ID docs, status: PENDING/APPROVED/REJECTED)
- **Flag** (moderation: ITEM/COMMENT/USER/TRADE)

---

## Architecture

### Backend (NestJS)

```
src/
├── auth/              # JWT, guards, strategies
├── users/             # User CRUD, profiles, roles
├── items/             # Item CRUD, recommendations
├── trades/            # Trade system, lifecycle
├── messages/          # Chat service + Socket.IO gateway
├── notifications/     # Notification service + gateway
├── verification/      # ID verification, security
├── moderation/        # Content flags, queue
├── support/           # Support tickets + gateway
├── admin/             # Admin operations
├── audit/             # Compliance logging
├── recaptcha/         # Bot protection
└── __tests__/         # All tests (jest)
```

**Standards:**

- Services: business logic | Controllers: HTTP routing | Gateways: WebSocket
- DTOs with class-validator | JWT + role guards | Prisma transactions
- 80%+ test coverage (unit + integration)
- Swagger docs on all endpoints
- Winston logging + Sentry monitoring

### Frontend (Next.js)

```
src/
├── app/(auth)/        # Login, register, logout
├── app/(main)/        # Items, trades, messages, profile, admin
├── components/        # UI (shadcn/ui), forms, dialogs
├── lib/
│   ├── api/          # API client methods
│   ├── hooks/        # React Query hooks
│   └── socket/       # Socket.IO client
├── store/            # Zustand (auth, notifications, socket)
├── types/            # TypeScript types
└── __tests__/        # All tests (jest + RTL)
```

**Standards:**

- App Router, TypeScript strict, shadcn/ui + Tailwind
- React Hook Form + Zod validation
- Zustand (global) + React Query (server)
- 80%+ test coverage (unit + integration)
- WCAG 2.1 AA accessibility
- No localStorage (SecurityError in sandbox)

---

## Feature Implementation Workflow

### 🚀 Step 1: Create Feature Branch (MANDATORY)

```bash
git checkout main
git pull origin main
git checkout -b <type>/<description>
# Examples: feat/user-auth, fix/login-bug, chore/deps
```

### 📋 Step 2: Analyze Requirements

- Define REST endpoints (request/response schemas)
- Define WebSocket events (if real-time)
- Plan database changes
- Document security implications

### 🔨 Step 3: Backend Implementation

- Create DTOs (class-validator)
- Implement service (business logic)
- Create controller (HTTP endpoints)
- Add Swagger docs
- **Write tests** (unit + integration)

### 🎨 Step 4: Frontend Implementation

- Create API client methods
- Build components (shadcn/ui)
- Add form validation (Zod)
- Implement state (Zustand/React Query)
- **Write tests** (unit + component)

### ✅ Step 5: Execute ALL Tests (AUTOMATED)

```bash
# Backend: Unit + Integration
npm run test:backend           # Jest unit tests
npm run test:backend:int       # Integration tests
npm run test:backend:cov       # Coverage report

# Frontend: Unit + Component
npm run test:frontend          # Jest + React Testing Library
npm run test:frontend:int      # Component integration tests
npm run test:frontend:cov      # Coverage report

# E2E Tests
npm run test:e2e              # Playwright e2e

# Performance
npm run test:performance       # Lighthouse CLI (desktop + mobile)

# ALL TESTS (one command)
npm run test:all              # Runs all tests above + generates reports
```

**CI Enforces:** ✅ Tests pass | ✅ Coverage >80% | ✅ No console.log | ✅ Lighthouse >90

### 📝 Step 6: Commit & Push

```bash
git add .
git commit -m "feat(module): clear description"
git push -u origin <type>/<description>
```

**Commit Format:** `<type>(<scope>): <description>`

- Types: feat, fix, test, chore, docs, refactor, perf
- Scope: module name (auth, items, trades, etc)
- Example: `feat(trades): add trade completion workflow`

### 🔄 Step 7: Create Pull Request

```bash
gh pr create --title "feat: Feature Name" --body "Description"
# OR use GitHub web UI
```

### 🛡️ Step 8: CI/CD Validation (Automatic)

PR cannot merge until ALL pass:

- [ ] Code formatting (Prettier)
- [ ] Linting (ESLint)
- [ ] **ALL tests pass** (backend unit + int, frontend unit + int, e2e, lighthouse)
- [ ] Build succeeds
- [ ] Security scan passes (Trivy)
- [ ] Branch naming valid
- [ ] Commit messages valid
- [ ] No files >5MB
- [ ] Prisma schema valid

### ✨ Step 9: Merge & Cleanup

```bash
gh pr merge --squash --delete-branch
# OR use GitHub web UI (Squash & merge)

git checkout main
git pull origin main
```

---

## Testing Requirements

### MUST Execute on EVERY Feature

#### Backend Tests

- **Unit Tests** (jest): Services, controllers, guards, interceptors

  - Location: `src/modules/__tests__/service.spec.ts`
  - Command: `npm run test:backend`
  - Coverage target: 80%+ for critical paths

- **Integration Tests** (jest + database): Complete workflows
  - Location: `src/__tests__/integration/`
  - Tests: Auth flow, trading flow, real-time messaging
  - Command: `npm run test:backend:int`
  - Must include: API contracts, database transactions, Socket.IO events

#### Frontend Tests

- **Unit Tests** (jest + RTL): Components, hooks, stores

  - Location: `src/components/__tests__/Component.spec.tsx`
  - Command: `npm run test:frontend`
  - Coverage target: 80%+

- **Integration Tests** (RTL): Complex workflows
  - Location: `src/__tests__/integration/`
  - Tests: Auth flow, trading UI, chat interactions
  - Command: `npm run test:frontend:int`

#### E2E Tests (Playwright)

- **User Workflows:** Complete end-to-end scenarios
  - Location: `e2e/tests/`
  - Tests: User registration → item creation → trade proposal → completion
  - Command: `npm run test:e2e`
  - Coverage: Happy path + error scenarios

#### Performance Tests (Lighthouse)

- **Page Performance:** Desktop + Mobile
  - Targets: Performance >90, Accessibility >90, Best Practices >90
  - Command: `npm run test:performance`
  - Checks: First Contentful Paint (FCP), Cumulative Layout Shift (CLS), etc.

### Test Execution Command (Simplified)

```bash
# Everything at once (recommended before PR)
npm run test:all

# Output: Combined report with all results + coverage
```

### CI/CD Enforces

- ✅ Backend unit + integration tests pass
- ✅ Frontend unit + integration tests pass
- ✅ E2E tests pass
- ✅ Lighthouse performance >90
- ✅ Test coverage >80%

---

## Git & Release Workflow

### Branch Naming

```
feat/<description>      # New feature
fix/<description>       # Bug fix
chore/<description>     # Dependencies, refactoring
docs/<description>      # Documentation
test/<description>      # Test improvements
perf/<description>      # Performance optimization
```

### Commit Convention

```
feat(module): add user profile editing
fix(auth): resolve jwt token expiration bug
test(trades): add workflow integration tests
chore(deps): update nestjs to latest
```

### Release Tagging & Versioning

**Semantic Versioning:** MAJOR.MINOR.PATCH

**When to Release:**

- MAJOR (v1.0.0): Launch, breaking changes
- MINOR (v1.1.0): New features (backwards compatible)
- PATCH (v1.0.1): Bug fixes, security patches

**Release Steps:**

```bash
# On main branch
git checkout main
git pull origin main

# Update version in package.json (both packages)
# Update CHANGELOG.md

git add .
git commit -m "chore: release v1.0.1"

# Create annotated tag
git tag -a v1.0.1 -m "Release v1.0.1: Bug fixes and optimizations"

# Push tag to trigger deployment
git push origin v1.0.1

# GitHub Actions auto-deploys + creates release notes
```

**Release Checklist:**

- [ ] All tests passing (80%+ coverage)
- [ ] E2E tests passing
- [ ] Lighthouse performance >90
- [ ] API docs updated
- [ ] CHANGELOG updated
- [ ] Version bumped (package.json)
- [ ] Git tag created
- [ ] Security review passed
- [ ] Deployment successful

---

## Quality Checklist (Before Completing Feature)

### Backend

- [ ] NestJS conventions followed (service/controller/gateway separation)
- [ ] TypeScript strict mode (no implicit any)
- [ ] DTOs with class-validator
- [ ] Proper HTTP status codes
- [ ] Error handling with custom exceptions
- [ ] Swagger documentation
- [ ] Authentication/authorization guards
- [ ] Input validation
- [ ] Database queries optimized
- [ ] Prisma transactions for multi-step ops
- [ ] Comprehensive logging
- [ ] Rate limiting on sensitive endpoints
- [ ] **80%+ test coverage (unit + integration)**
- [ ] **All tests passing**
- [ ] No hardcoded secrets

### Frontend

- [ ] Next.js 14 App Router conventions
- [ ] TypeScript strict mode
- [ ] shadcn/ui + TailwindCSS responsive
- [ ] Form validation with Zod
- [ ] Error boundaries + toast notifications
- [ ] Loading states (spinners/skeletons)
- [ ] WCAG 2.1 AA accessibility
- [ ] No console errors/warnings
- [ ] Images lazy-loaded
- [ ] **80%+ test coverage (unit + component)**
- [ ] **All tests passing**
- [ ] Mobile tested
- [ ] No localStorage usage

### Git & Docs

- [ ] Feature branch created (`<type>/<description>`)
- [ ] **All commits follow convention** (feat:, fix:, etc.)
- [ ] **Pull Request created** with description
- [ ] **ALL CI checks pass** (tests, linting, build, security)
- [ ] Documentation updated
- [ ] API docs updated
- [ ] Merged via squash merge
- [ ] Branch deleted

---

## Testing Commands Reference

```bash
# Backend
npm run test:backend           # Unit tests
npm run test:backend:int       # Integration tests
npm run test:backend:watch     # Watch mode
npm run test:backend:cov       # Coverage report

# Frontend
npm run test:frontend          # Unit + component tests
npm run test:frontend:int      # Integration tests
npm run test:frontend:watch    # Watch mode
npm run test:frontend:cov      # Coverage report

# E2E
npm run test:e2e              # Playwright
npm run test:e2e:ui           # Playwright UI mode
npm run test:e2e:headed       # Headed browser

# Performance
npm run test:performance       # Lighthouse CLI
npm run test:lighthouse:desktop    # Desktop only
npm run test:lighthouse:mobile     # Mobile only

# All Tests (Recommended)
npm run test:all              # Everything + combined report
npm run test:all:watch        # Watch mode for all
npm run test:all:cov          # Coverage for all
```

---

## Critical Git Rules (Non-Negotiable)

❌ **NEVER:**

- Commit directly to `main` (branch protection enforced)
- Skip tests before pushing
- Merge PRs without CI passing
- Ignore test coverage requirements
- Use generic commit messages

✅ **ALWAYS:**

- Create feature branch first
- Write tests alongside features
- Use conventional commit format
- Run full test suite before PR
- Wait for all CI checks
- Use squash merge
- Create git tags for releases
- Document in PRs

---

## Important Notes

- **Solo Developer:** Automate everything, test frequently, deploy often
- **Community Trust:** Verification mandatory, moderation functional, security paramount
- **Performance:** Item feed paginated + cached, chat <100ms latency, Lighthouse >90
- **No Browser Storage:** Never use localStorage/sessionStorage (SecurityError)
- **Reference Existing Code:** Check existing services for patterns before building
- **Launch Readiness:** March 17, 2026 requires all tests passing + full coverage

---

## Success Criteria Per Feature

✅ Feature branch created with proper naming
✅ All commits follow conventional format
✅ Pull Request created with description
✅ **ALL tests executed and passing:**

- Backend: unit + integration
- Frontend: unit + component + integration
- E2E: complete workflows
- Lighthouse: performance >90
  ✅ Test coverage: 80%+ critical paths
  ✅ All CI checks passing
  ✅ Code formatted (Prettier)
  ✅ Linting passed (ESLint)
  ✅ Security scan passed
  ✅ Documentation updated
  ✅ API docs updated (Swagger)
  ✅ Merged via squash merge
  ✅ Branch auto-deleted
