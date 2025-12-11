# Environment File Auto-Reload

Both the backend and frontend applications are configured to automatically restart when `.env` files are modified during development.

## How It Works

### Backend (NestJS)

- The backend uses NestJS's built-in `--watchAssets` flag to monitor `.env` files
- When any `.env*` file changes, the application automatically restarts
- Configured in `nest-cli.json` with `assets: [".env*"]` and `watchAssets: true`

### Frontend (Next.js)

- The frontend uses `nodemon` to watch for `.env` file changes
- Monitors: `.env`, `.env.local`, `.env.development`, and `.env.development.local`
- Configured in `nodemon.json` with a 1-second delay to prevent multiple restarts
- The development server restarts automatically when any of these files change

## Usage

Simply run the development servers as usual:

```bash
# From the root directory
yarn dev

# Or individually
yarn dev:backend   # Backend with env watching
yarn dev:frontend  # Frontend with env watching
```

## Fallback

If you prefer to run without env file watching (e.g., for debugging):

```bash
# Frontend only - basic mode without env watching
cd swapbuds-frontend && yarn dev:basic
```

## Files Monitored

**Backend:**

- `.env`
- `.env.*` (any env file)

**Frontend:**

- `.env`
- `.env.local`
- `.env.development`
- `.env.development.local`

## Notes

- Changes take effect after a 1-second delay (frontend only) to prevent rapid successive restarts
- Backend restart is nearly instantaneous
- Environment variables are reloaded automatically with each restart
- No need to manually stop and start the development servers when updating configurations
