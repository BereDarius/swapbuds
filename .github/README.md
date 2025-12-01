# CI/CD Documentation

This directory contains GitHub Actions workflows for the SwapBuds **root repository** (orchestration layer).

## 🏗️ Architecture Overview

SwapBuds uses a **Git submodule architecture**:

```
swapbuds (root)                     ← Root repository (orchestration)
├── swapbuds-backend/               ← Submodule with own CI/CD
└── swapbuds-frontend/              ← Submodule with own CI/CD
```

### Repository Structure

1. **Root Repository** (`swapbuds`):

   - Orchestrates infrastructure (Docker Compose)
   - Manages submodule updates
   - Coordinates releases
   - Minimal dependencies

2. **Backend Submodule** (`swapbuds-backend`):

   - Independent repository with full CI/CD
   - Runs on: https://github.com/BereDarius/swapbuds-backend
   - CI triggers on pushes/PRs to backend repo

3. **Frontend Submodule** (`swapbuds-frontend`):
   - Independent repository with full CI/CD
   - Runs on: https://github.com/BereDarius/swapbuds-frontend
   - CI triggers on pushes/PRs to frontend repo

## 📋 Root Repository Workflows

These workflows run in the **root repository only**:

#### 1. **Docker Compose** (`docker-compose.yml`)

Validates Docker infrastructure configuration

**Jobs:**

- **Validate**: Checks docker-compose.yml syntax
- **Test**: Spins up services and validates health checks

#### 2. **Submodules Update** (`submodules-update.yml`)

Automatically updates submodules to latest versions

**Triggers:**

- Daily at 2 AM UTC (scheduled)
- Manual dispatch

**Features:**

- Creates PR when submodules have updates
- Shows changed submodule versions
- Allows updating specific submodule or all

### Quality & Security

#### 3. **Code Quality** (`code-quality.yml`)

Security scanning for root repository only

**Jobs:**

- **Security Scan**: Trivy scanning (skips submodules)
- **Dependency Review**: Root dependencies only

**Note**: Submodules have their own security scanning

#### 4. **PR Checks** (`pr-checks.yml`)

Validation for PRs to root repository

**Features:**

- Semantic PR title validation (conventional commits)
- PR size warning (>1000 lines)
- Merge conflict detection
- Automatic labeling based on changed files

### Automation

#### 5. **Dependabot** (`dependabot.yml`)

Root repository dependencies only

**Configuration:**

- Weekly updates (Mondays 9:00 AM)
- Root npm packages
- GitHub Actions
- Auto-merge for patch/minor updates (`dependabot-auto-merge.yml`)

**Note**: Backend and frontend have their own Dependabot configs

#### 6. **Stale Issues** (`stale.yml`)

Issue/PR management

**Configuration:**

- Issues: 60 days inactive → stale, 7 more days → close
- PRs: 30 days inactive → stale, 14 more days → close
- Exempt labels: `pinned`, `security`, `bug`, `wip`

#### 7. **Release** (`release.yml`)

Coordinated releases with submodule versions

**Triggers:**

- Tag push (`v*.*.*`)
- Manual workflow dispatch

**Features:**

- Tracks submodule versions in release
- Automatic changelog generation
- Installation instructions with submodules

## 🚀 Getting Started

### Repository Setup

#### Root Repository

1. **Enable GitHub Actions** in repository settings
2. **Enable Dependabot** security updates
3. **Configure branch protection** (see below)

#### Submodule Repositories

Each submodule needs its own setup:

**Backend** (`swapbuds-backend`):

- Enable GitHub Actions
- Enable Dependabot
- Set up secrets: `CODECOV_TOKEN` (optional)
- Configure branch protection

**Frontend** (`swapbuds-frontend`):

- Enable GitHub Actions
- Enable Dependabot
- Set up secrets: `CODECOV_TOKEN` (optional)
- Configure branch protection

### Branch Protection Rules

#### Root Repository (`main` branch)

```yaml
Require status checks to pass before merging:
  - Docker Compose / validate
  - Code Quality / security
  - PR Checks / validate-pr

Require branches to be up to date: true
Require conversation resolution: true
```

#### Backend Submodule (`main` branch)

```yaml
Require status checks to pass before merging:
  - CI / lint
  - CI / test
  - CI / build
  - Code Quality / security

Require branches to be up to date: true
```

#### Frontend Submodule (`main` branch)

```yaml
Require status checks to pass before merging:
  - CI / lint
  - CI / unit-test
  - CI / e2e-test (chromium)
  - CI / build
  - Code Quality / security

Require branches to be up to date: true
```

## 📊 Monitoring & Artifacts

### Test Results

- **Location**: GitHub Actions artifacts
- **Retention**: 30 days for test results, 7 days for builds
- **Access**: Click on workflow run → Artifacts section

### Coverage Reports

- **Backend**: Codecov (if token configured)
- **Frontend Unit**: Codecov (if token configured)
- **Frontend E2E**: Playwright HTML reports

### Security Alerts

- **Location**: Security tab → Code scanning alerts
- **Sources**: Trivy, CodeQL, Dependabot

## 🔧 Local Development

### Running CI checks locally

**Root repository:**

```bash
# Validate docker-compose
docker-compose config
docker-compose up -d
```

**Backend submodule:**

```bash
cd swapbuds-backend

# Run all CI checks
yarn lint
yarn test
yarn test:e2e
yarn build
```

**Frontend submodule:**

```bash
cd swapbuds-frontend

# Run all CI checks
yarn lint
yarn test:cov
yarn test:e2e
yarn build
```

### Working with Submodules

**Clone with submodules:**

```bash
git clone --recurse-submodules https://github.com/BereDarius/swapbuds.git
```

**Update submodules:**

```bash
git submodule update --remote --merge
```

**Make changes in submodule:**

```bash
cd swapbuds-backend
# Make changes
git add .
git commit -m "feat: your changes"
git push origin main

# Return to root and update submodule reference
cd ..
git add swapbuds-backend
git commit -m "chore: update backend submodule"
git push origin main
```

## 📝 Workflow Triggers

### Root Repository

| Workflow              | Push (main) | Push (develop) | PR  | Tags | Schedule   | Manual |
| --------------------- | ----------- | -------------- | --- | ---- | ---------- | ------ |
| Docker Compose        | ✅          | ✅             | ✅  | -    | -          | ✅     |
| Submodules Update     | -           | -              | -   | -    | ✅ (daily) | ✅     |
| Code Quality          | ✅          | ✅             | ✅  | -    | -          | -      |
| PR Checks             | -           | -              | ✅  | -    | -          | -      |
| Dependabot Auto-merge | -           | -              | ✅  | -    | -          | -      |
| Release               | -           | -              | -   | ✅   | -          | ✅     |
| Stale                 | -           | -              | -   | -    | ✅ (daily) | ✅     |

### Submodule Repositories

**Backend & Frontend** (run in their respective repos):

| Workflow     | Push (main) | Push (develop) | PR            | Schedule    | Manual |
| ------------ | ----------- | -------------- | ------------- | ----------- | ------ |
| CI           | ✅          | ✅             | ✅            | -           | -      |
| Code Quality | ✅          | ✅             | ✅            | -           | -      |
| Dependabot   | -           | -              | ✅ (auto-PRs) | ✅ (weekly) | -      |

## 🎯 Best Practices

### For Contributors

1. **Working with submodules:**

   - Make changes directly in submodule repositories
   - Each submodule has its own CI/CD pipeline
   - Root repo only needs updating when you want to pin a new submodule version

2. **Before pushing to submodules:**

   - Run linting and tests locally
   - Ensure your branch is up to date with main
   - Write meaningful commit messages (conventional commits)

3. **PR Guidelines:**

   - **Submodule PRs**: Open PR in the specific submodule repo
   - **Root PRs**: Only for infrastructure, scripts, or submodule updates
   - Keep PRs focused and under 1000 lines when possible
   - Fill out the PR template
   - Ensure all CI checks pass

4. **Handling CI Failures:**
   - Identify which repository the failure is in (root vs submodule)
   - Check the workflow logs for error details
   - Fix issues locally and push again

### For Maintainers

1. **Submodule Management:**

   - Review submodule update PRs (automated daily)
   - Ensure submodule CIs pass before updating root
   - Test integration after submodule updates

2. **Monitoring:**

   - Review Dependabot PRs weekly (in all 3 repos)
   - Check security alerts regularly (in all 3 repos)
   - Monitor test coverage trends (backend and frontend)

3. **Releases:**

   - Tag releases in root repo (coordinates submodule versions)
   - Review auto-generated changelogs before publishing
   - Document breaking changes across submodules
   - Test integration before releasing

4. **Workflow Maintenance:**
   - Update GitHub Actions to latest versions monthly
   - Keep workflows synchronized across repositories
   - Document any repo-specific configurations

## 🔐 Security

- All workflows use minimal required permissions
- Secrets are never logged or exposed
- Dependencies are scanned automatically
- Code scanning runs on every PR

## 🆘 Troubleshooting

### Common Issues

**"Workflow failed to load"**

- Check YAML syntax: `yamllint .github/workflows/*.yml`
- Verify workflow is in correct repository (root vs submodule)

**"Tests timeout"**

- Check which repository the test is in
- Increase timeout in that repo's workflow file
- Check for hanging processes in tests

**"Build artifacts not found"**

- Artifacts are stored in the repository where CI ran
- Verify artifact retention hasn't expired (7-30 days)
- Check workflow completed successfully

**"Dependabot PRs failing"**

- Check which repository the PR is in
- May need manual intervention for breaking changes
- Review the PR description for upgrade notes

**"Submodule showing as modified"**

- This is normal after submodule updates
- Commit the submodule pointer update: `git add swapbuds-backend && git commit -m "chore: update backend"`
- Or reset if unwanted: `git submodule update --init`

**"Submodule CI not running"**

- Ensure GitHub Actions enabled in submodule repo
- Check branch protection rules in submodule
- Verify push actually went to submodule (not root)

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Playwright Documentation](https://playwright.dev)
- [Dependabot Documentation](https://docs.github.com/en/code-security/dependabot)
- [CodeQL Documentation](https://codeql.github.com/docs/)

## 📧 Support

For questions or issues with CI/CD:

1. Check workflow logs
2. Review this documentation
3. Create an issue with the `ci` label
