# SWAPBUDS Architecture

## System Overview

SWAPBUDS is a peer-to-peer trading platform built with a modern, scalable architecture that separates concerns between frontend and backend while maintaining flexibility for growth.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                         USERS                               │
│                   (Web Browsers)                            │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ HTTPS
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│   Vercel     │  │  Cloudinary  │  │   Vercel     │
│  (Frontend)  │  │     CDN      │  │  (Backend)   │
│   Next.js    │  │   (Images)   │  │   NestJS     │
└──────┬───────┘  └──────────────┘  └──────┬───────┘
       │                                    │
       │ REST API + WebSocket               │
       └────────────────┬───────────────────┘
                        │
                        ▼
               ┌────────────────┐
               │ Vercel Postgres│
               │   (Database)   │
               └────────────────┘
```

## Technology Stack

### Frontend

- **Framework:** Next.js 14+ (App Router)
- **Language:** TypeScript
- **State Management:** Zustand
- **Data Fetching:** TanStack Query
- **Real-time:** Socket.IO Client
- **Styling:** TailwindCSS
- **Hosting:** Vercel

### Backend

- **Framework:** NestJS
- **Language:** TypeScript
- **ORM:** Prisma
- **Database:** PostgreSQL (Vercel Postgres)
- **Real-time:** Socket.IO
- **Authentication:** JWT
- **Validation:** class-validator
- **Hosting:** Vercel Functions

### Infrastructure

- **Database:** Vercel Postgres (Production) / Docker PostgreSQL (Local)
- **File Storage:** Cloudinary
- **CI/CD:** GitHub Actions + Vercel
- **Monitoring:** Vercel Analytics

## Data Model

### Core Entities

```
User
├─ Items (1:many)
├─ Trades Proposed (1:many)
├─ Trades Received (1:many)
├─ Reviews (1:many)
├─ Messages (1:many)
└─ Notifications (1:many)

Item
├─ Images (1:many)
├─ Likes (1:many)
├─ Comments (1:many)
└─ Trades (1:many)

Trade
├─ Item Offered (1:1)
├─ Item Requested (1:1)
├─ Proposer (User)
├─ Responder (User)
├─ Messages (1:many)
└─ Reviews (1:many)
```

See `swapbuds-backend/prisma/schema.prisma` for complete schema.

## Authentication Flow

```
1. User registers/logs in
   ↓
2. Backend validates credentials
   ↓
3. JWT token issued (httpOnly cookie)
   ↓
4. Frontend stores auth state (Zustand)
   ↓
5. Subsequent requests include JWT
   ↓
6. Backend validates JWT on each request
```

## Real-time Communication

- **Technology:** Socket.IO
- **Use Cases:**
  - Live chat messages
  - Trade status updates
  - Notifications
  - Presence indicators

## File Upload Flow

```
Frontend
   ↓
   ├─> Direct Upload to Cloudinary
   │   (using upload widget/SDK)
   ↓
Cloudinary processes image
   ↓
Frontend receives URL
   ↓
Backend stores URL in database
```

## Deployment Architecture

### Development

```
Local Machine
├─ Docker (PostgreSQL + Redis)
├─ Backend (localhost:3001)
└─ Frontend (localhost:3000)
```

### Production

```
Vercel
├─ Frontend (Static + SSR)
├─ Backend (Serverless Functions)
└─ Postgres (Managed Database)

Cloudinary
└─ Static Assets (Images)
```

## Security Considerations

1. **Authentication:** JWT with httpOnly cookies
2. **Authorization:** Role-based access control
3. **Data Validation:** class-validator on all inputs
4. **SQL Injection:** Prevented by Prisma ORM
5. **XSS:** React's built-in protection + CSP headers
6. **CORS:** Configured for specific origins
7. **Rate Limiting:** Implemented on API routes
8. **File Uploads:** Validated types and sizes

## Scalability

### Current Architecture Supports:

- ~1000 concurrent users
- ~100 requests/second
- Horizontal scaling via Vercel Functions

### Future Improvements:

- Add Redis for session management
- Implement CDN caching
- Add queue system (Bull/BullMQ)
- Separate read/write databases
- Microservices for heavy operations

## Development Workflow

```
1. Feature branch from main
   ↓
2. Local development with hot reload
   ↓
3. Lint + Format (automated)
   ↓
4. Commit changes
   ↓
5. Push to GitHub
   ↓
6. CI/CD runs tests
   ↓
7. Preview deployment on Vercel
   ↓
8. Code review + merge
   ↓
9. Auto-deploy to production
```

## Monitoring & Observability

- **Logs:** Vercel Function Logs
- **Errors:** Error boundaries + logging
- **Analytics:** Vercel Analytics
- **Database:** Prisma query logging
- **Performance:** Web Vitals tracking

## API Design

### RESTful Endpoints

```
/api/auth/*          - Authentication
/api/users/*         - User management
/api/items/*         - Item CRUD
/api/trades/*        - Trade proposals
/api/messages/*      - Chat messages
/api/notifications/* - User notifications
```

### WebSocket Events

```
connect              - User connects
disconnect           - User disconnects
message:send         - Send message
message:receive      - Receive message
trade:update         - Trade status change
notification:new     - New notification
```

## Performance Targets

- **Page Load:** < 2s (First Contentful Paint)
- **API Response:** < 200ms (p95)
- **Database Query:** < 50ms (p95)
- **WebSocket Latency:** < 100ms
- **Image Load:** < 1s (via Cloudinary CDN)

## Folder Structure

See individual repositories for detailed structure:

- Backend: `swapbuds-backend/README.md`
- Frontend: `swapbuds-frontend/README.md`
