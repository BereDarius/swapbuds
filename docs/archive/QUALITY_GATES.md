# Quality Gates Configuration

This directory enforces multiple quality gates to ensure repository consistency:

## 🔍 Commit Validation (`commit-validation.yml`)

- **Commit Messages**: Enforces conventional commits format
- **File Sizes**: Prevents files >5MB from being committed
- **Dependencies**: Validates package-lock.json consistency

## 🏷️ Release Validation (`release-validation.yml`)

- **Semver Compliance**: Validates tag format (v1.2.3)
- **Version Matching**: Ensures tag matches package.json version
- **Changelog**: Checks for changelog entries
- **Critical Issues**: Blocks releases with open critical issues

## 📐 Code Consistency (`code-consistency.yml`)

- **Formatting**: Checks Prettier formatting
- **TODO Comments**: Warns about excessive TODOs/FIXMEs
- **Console Logs**: Detects debug console.log statements
- **Branch Naming**: Enforces branch naming conventions

## 🎯 Branch Naming Convention

Required format: `<type>/<description>`

Valid types:

- `feat/` or `feature/` - New features
- `fix/` or `bugfix/` - Bug fixes
- `hotfix/` - Urgent production fixes
- `chore/` - Maintenance tasks
- `docs/` - Documentation changes
- `style/` - Code style changes
- `refactor/` - Code refactoring
- `perf/` - Performance improvements
- `test/` - Test additions/changes
- `build/` - Build system changes
- `ci/` - CI/CD changes
- `revert/` - Revert previous commits

Examples:

- ✅ `feat/user-authentication`
- ✅ `fix/login-validation`
- ✅ `chore/update-dependencies`
- ❌ `my-feature`
- ❌ `Feature/UserAuth`

## 📝 Commit Message Format

Required format: `<type>(<scope>): <subject>`

Example:

```
feat(auth): add JWT token refresh mechanism
fix(api): handle null values in user profile
docs(readme): update installation instructions
```

## 🚀 Release Process

1. Update version in `package.json`
2. Add changelog entry
3. Ensure all CI checks pass
4. Create tag: `git tag v1.2.3`
5. Push tag: `git push origin v1.2.3`
6. Release workflow validates and creates GitHub release

## 🛡️ Quality Checklist

Before merging any PR, ensure:

- [ ] All CI checks pass
- [ ] Code is properly formatted (Prettier)
- [ ] No console.log statements in production code
- [ ] Branch name follows convention
- [ ] Commit messages follow conventional format
- [ ] No files >5MB
- [ ] No secrets committed (GitGuardian scans automatically)
- [ ] Tests added/updated
- [ ] Documentation updated
