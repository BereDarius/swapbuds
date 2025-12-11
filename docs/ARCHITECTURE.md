# SwapBuds System Architecture

**Last Updated:** November 26, 2025
**Version:** 0.10.0

## 🎯 Overview

SwapBuds is a peer-to-peer item trading platform built with a modern tech stack:

- **Frontend:** Next.js 14 (App Router), React 18, TypeScript, TailwindCSS, shadcn/ui
- **Backend:** NestJS, TypeScript, Prisma ORM, PostgreSQL
- **Real-time:** Socket.IO for WebSocket connections
- **Infrastructure:** Docker, Redis (caching), Cloudinary (images)

---

## 📊 Full System Architecture

```mermaid
graph TB
    subgraph "Client Layer - Next.js Frontend"
        Browser[Web Browser]

        subgraph "Pages (App Router)"
            AuthPages["🔐 Auth Pages<br/>/login, /register"]
            ItemPages["📦 Item Pages<br/>/items, /items/[id]"]
            TradePages["🔄 Trade Pages<br/>/trades, /trades/[id]"]
            MessagePages["💬 Message Pages<br/>/messages"]
            ProfilePages["👤 Profile Pages<br/>/profile/[username]"]
            AdminPages["⚙️ Admin Pages<br/>/admin/*"]
            SupportPages["🎫 Support Pages<br/>/support"]
        end

        subgraph "Components"
            Navbar["Navbar + Badges"]
            ItemCard["ItemCard"]
            TradeCard["TradeCard"]
            ChatBox["ChatBox"]
            FlagDialog["FlagDialog"]
        end

        subgraph "State Management"
            AuthStore["Zustand<br/>Auth Store"]
            ReactQuery["React Query<br/>Cache"]
            SocketHooks["WebSocket<br/>Hooks"]
        end

        subgraph "API Clients"
            AuthAPI["auth.ts"]
            ItemsAPI["items.ts"]
            TradesAPI["trades.ts"]
            MessagesAPI["messages.ts"]
            NotificationsAPI["notifications.ts"]
        end
    end

    subgraph "Server Layer - NestJS Backend"
        subgraph "Controllers"
            AuthCtrl["Auth<br/>Controller"]
            ItemsCtrl["Items<br/>Controller"]
            TradesCtrl["Trades<br/>Controller"]
            MessagesCtrl["Messages<br/>Controller"]
            UsersCtrl["Users<br/>Controller"]
            AdminCtrl["Admin<br/>Controller"]
            SupportCtrl["Support<br/>Controller"]
            NotifCtrl["Notifications<br/>Controller"]
        end

        subgraph "Services"
            AuthSvc["Auth Service"]
            ItemsSvc["Items Service"]
            TradesSvc["Trades Service"]
            MessagesSvc["Messages Service"]
            NotifSvc["Notifications<br/>Service"]
        end

        subgraph "WebSocket Gateways"
            MessagesGW["Messages<br/>Gateway"]
            NotifGW["Notifications<br/>Gateway"]
            SupportGW["Support<br/>Gateway"]
        end

        PrismaClient["Prisma ORM<br/>Client"]
    end

    subgraph "Data Layer"
        PostgreSQL[("🗄️ PostgreSQL<br/>Database")]
        Redis[("⚡ Redis<br/>Cache")]
        Cloudinary[("☁️ Cloudinary<br/>CDN")]
    end

    Browser --> AuthPages
    Browser --> ItemPages
    Browser --> TradePages
    Browser --> MessagePages

    AuthPages --> AuthAPI
    ItemPages --> ItemsAPI
    TradePages --> TradesAPI
    MessagePages --> MessagesAPI

    AuthAPI -->|POST /auth/login| AuthCtrl
    ItemsAPI -->|GET /items| ItemsCtrl
    TradesAPI -->|POST /trades| TradesCtrl
    MessagesAPI -->|GET /messages| MessagesCtrl

    AuthCtrl --> AuthSvc
    ItemsCtrl --> ItemsSvc
    TradesCtrl --> TradesSvc
    MessagesCtrl --> MessagesSvc
    NotifCtrl --> NotifSvc

    AuthSvc --> PrismaClient
    ItemsSvc --> PrismaClient
    TradesSvc --> PrismaClient
    MessagesSvc --> PrismaClient
    NotifSvc --> PrismaClient

    PrismaClient --> PostgreSQL

    SocketHooks -.->|WebSocket| MessagesGW
    SocketHooks -.->|WebSocket| NotifGW
    SocketHooks -.->|WebSocket| SupportGW

    MessagesGW --> MessagesSvc
    NotifGW --> NotifSvc
    SupportGW --> PrismaClient

    ItemsSvc -.->|Cache| Redis
    TradesSvc -.->|Cache| Redis

    ItemsSvc -.->|Upload| Cloudinary

    style PostgreSQL fill:#336791,color:#fff
    style Redis fill:#DC382D,color:#fff
    style Cloudinary fill:#3448C5,color:#fff
```

---

## 🗂️ Database Schema Overview

See [database-erd.md](./database-erd.md) for the complete entity-relationship diagram generated from Prisma schema.

### Core Tables

| Table             | Purpose                       | Key Relationships                           |
| ----------------- | ----------------------------- | ------------------------------------------- |
| **users**         | User accounts, authentication | owns items, proposes trades, sends messages |
| **items**         | Tradeable items               | belongs to user, involved in trades         |
| **trades**        | Trade proposals               | connects two users and their items          |
| **conversations** | Direct message threads        | between two users, optional trade context   |
| **messages**      | Chat messages                 | belongs to conversation, sent by user       |
| **notifications** | User notifications            | belongs to user                             |
| **reviews**       | Trade reviews                 | from user to user about a trade             |
| **likes**         | Item likes                    | user likes item                             |
| **comments**      | Item comments                 | user comments on item                       |

### Supporting Tables

| Table                        | Purpose                        |
| ---------------------------- | ------------------------------ |
| **item_images**              | Multiple images per item       |
| **trade_items**              | Multi-item trades (join table) |
| **counter_offers**           | Alternative trade proposals    |
| **flagged_items**            | Content moderation             |
| **disputes**                 | Trade dispute resolution       |
| **support_chats**            | Customer support tickets       |
| **support_messages**         | Support chat messages          |
| **user_verifications**       | ID verification submissions    |
| **audit_logs**               | Admin action tracking          |
| **legal_documents**          | TOS, Privacy Policy versions   |
| **legal_consents**           | User consent tracking          |
| **user_settings**            | User preferences               |
| **notification_preferences** | Notification settings          |
| **mfa_secrets**              | 2FA secrets                    |
| **oauth_accounts**           | Social login accounts          |
| **waitlist**                 | Pre-launch signups             |

---

## 🔌 API Endpoints Reference

See [API_ENDPOINTS.md](./API_ENDPOINTS.md) for complete API documentation.

### Quick Reference

| Module        | Base Path            | Key Endpoints                         |
| ------------- | -------------------- | ------------------------------------- |
| Auth          | `/api/auth`          | login, register, logout, me           |
| Items         | `/api/items`         | CRUD, search, recommendations         |
| Trades        | `/api/trades`        | create, accept, reject, counter-offer |
| Messages      | `/api/messages`      | conversations, send, read             |
| Users         | `/api/users`         | profile, settings, statistics         |
| Notifications | `/api/notifications` | list, read, preferences               |
| Admin         | `/api/admin`         | user management, stats, audit logs    |
| Moderation    | `/api/moderation`    | flags, review, approve/remove         |
| Support       | `/api/support`       | tickets, chat, resolve                |
| Verification  | `/api/verification`  | submit, review, approve/reject        |

---

## 🎨 Frontend Component Hierarchy

See [FRONTEND_PAGES.md](./FRONTEND_PAGES.md) for complete page and component documentation.

```mermaid
graph TD
    App[App Root Layout]

    App --> MainLayout["Main Layout<br/>(Authenticated)"]
    App --> AuthLayout["Auth Layout<br/>(Guest Only)"]
    App --> LegalLayout["Legal Layout<br/>(Public)"]

    MainLayout --> Navbar
    MainLayout --> Pages["All App Pages"]
    MainLayout --> Footer

    Navbar --> NotificationBadge
    Navbar --> MessageBadge

    Pages --> ItemsPage
    Pages --> TradesPage
    Pages --> MessagesPage
    Pages --> ProfilePage
    Pages --> AdminPage

    ItemsPage --> ItemCard
    ItemsPage --> SearchFilters

    TradesPage --> TradeCard
    TradeCard --> TradeStatusBadge

    MessagesPage --> ConversationList
    MessagesPage --> ChatBox

    ProfilePage --> UserStats
    ProfilePage --> ItemGrid

    style Navbar fill:#4F46E5,color:#fff
    style Footer fill:#6366F1,color:#fff
```

---

## ⚡ Real-time Communication Flow

```mermaid
sequenceDiagram
    participant User1 as User 1 Browser
    participant Frontend1 as Next.js App
    participant SocketClient1 as Socket Client
    participant Backend as NestJS Server
    participant SocketGW as Socket Gateway
    participant DB as PostgreSQL
    participant SocketClient2 as Socket Client
    participant Frontend2 as Next.js App
    participant User2 as User 2 Browser

    User1->>Frontend1: Send Message
    Frontend1->>Backend: POST /api/messages
    Backend->>DB: Save Message
    Backend->>SocketGW: Emit new_message event
    SocketGW-->>SocketClient1: new_message (User 1)
    SocketGW-->>SocketClient2: new_message (User 2)
    SocketClient1->>Frontend1: Update UI
    SocketClient2->>Frontend2: Update UI
    Frontend2->>User2: Show New Message
    Frontend1->>Frontend1: Invalidate Query Cache
    Frontend2->>Frontend2: Invalidate Query Cache
```

---

## 🔒 Authentication & Authorization Flow

```mermaid
sequenceDiagram
    participant Browser
    participant LoginPage
    participant API
    participant AuthService
    participant DB
    participant Store

    Browser->>LoginPage: Enter Credentials
    LoginPage->>API: POST /auth/login
    API->>AuthService: Validate Credentials
    AuthService->>DB: Query User
    DB-->>AuthService: User Data
    AuthService-->>API: JWT Token + User
    API-->>LoginPage: Response
    LoginPage->>Store: setAuth(user, token)
    Store->>Store: Save to localStorage
    LoginPage->>Browser: Redirect to /items

    Note over Browser,DB: Subsequent Requests

    Browser->>API: GET /items (with token)
    API->>API: JWT Guard
    API->>API: Extract user from token
    API->>DB: Fetch Items
    DB-->>API: Items Data
    API-->>Browser: Response
```

---

## 📡 WebSocket Event System

### Events Emitted by Server

| Event               | Gateway       | Trigger              | Payload                       |
| ------------------- | ------------- | -------------------- | ----------------------------- |
| `new_message`       | Messages      | New message sent     | `{ message, conversationId }` |
| `message_read`      | Messages      | Message marked read  | `{ messageId, readAt }`       |
| `new_notification`  | Notifications | Notification created | `{ notification }`            |
| `notification_read` | Notifications | Notification read    | `{ notificationId }`          |
| `support_message`   | Support       | Support message sent | `{ message, chatId }`         |
| `agent_joined`      | Support       | Agent joins chat     | `{ agentId, chatId }`         |
| `typing`            | Messages      | User typing          | `{ userId, conversationId }`  |

### Events Listened by Server

| Event                | Gateway  | Action                             |
| -------------------- | -------- | ---------------------------------- |
| `join_conversation`  | Messages | Join room for conversation updates |
| `leave_conversation` | Messages | Leave conversation room            |
| `start_typing`       | Messages | Broadcast typing indicator         |
| `stop_typing`        | Messages | Stop typing indicator              |
| `join_support_chat`  | Support  | Join support chat room             |

---

## 🚀 Deployment Architecture

```mermaid
graph LR
    subgraph "Vercel - Frontend"
        NextJS["Next.js App<br/>Serverless Functions"]
    end

    subgraph "Production Server - Backend"
        NestApp["NestJS API<br/>:3001"]
        RedisCache["Redis<br/>:6379"]
    end

    subgraph "External Services"
        PostgresDB["PostgreSQL<br/>Database"]
        CloudinaryCDN["Cloudinary<br/>Image CDN"]
    end

    Users["👥 Users"] --> NextJS
    NextJS -->|API Calls| NestApp
    NextJS -->|Images| CloudinaryCDN
    NestApp --> PostgresDB
    NestApp --> RedisCache
    NestApp -->|Upload| CloudinaryCDN

    style NextJS fill:#000,color:#fff
    style NestApp fill:#E0234E,color:#fff
```

---

## 🔐 Security Measures

### Authentication

- JWT tokens (httpOnly cookies)
- Bcrypt password hashing
- Session management (localStorage/sessionStorage based on "Remember Me")
- Token expiry and refresh

### Authorization

- Role-based access control (USER, MODERATOR, SUPPORT, ADMIN)
- Route guards (frontend and backend)
- Resource ownership validation

### Data Protection

- Input validation (Zod schemas)
- SQL injection prevention (Prisma ORM)
- XSS protection (React auto-escaping)
- CORS configuration
- Rate limiting (throttler)
- reCAPTCHA v3 on auth endpoints

### Content Security

- Content moderation system
- User-reported flags
- ID verification system
- Audit logging for admin actions

---

## 📈 Performance Optimizations

### Frontend

- React Query caching (30-minute stale time)
- WebSocket fallback polling (30s interval)
- Image optimization (next/image)
- Code splitting (React.lazy)
- Memoization (useMemo, useCallback)

### Backend

- Redis caching (frequently accessed data)
- Database indexing (all foreign keys, search fields)
- Pagination (limit/offset)
- Lazy loading (Prisma relations)
- Connection pooling

### Real-time

- Room-based WebSocket channels
- Event debouncing (typing indicators)
- Selective query invalidation

---

## 🔄 State Management Strategy

### Global State (Zustand)

- User authentication
- WebSocket connection status
- Notification counts
- UI preferences

### Server State (React Query)

- Items, trades, messages (cached)
- User profiles (cached)
- Notifications (cached)
- Admin data (no caching)

### Local State (React useState)

- Form inputs
- UI toggles (modals, dropdowns)
- Temporary data (search filters)

---

## 📚 Related Documentation

- [Database ERD](./database-erd.md) - Complete entity-relationship diagram
- [API Endpoints](./API_ENDPOINTS.md) - Full API reference
- [Frontend Pages](./FRONTEND_PAGES.md) - Page and component documentation
- [Backend Architecture](../swapbuds-backend/docs/ARCHITECTURE.md) - Detailed backend docs
- [Frontend Testing](../swapbuds-frontend/TESTING.md) - Testing strategy

---

**For detailed implementation guides, see module-specific documentation in:**

- `swapbuds-backend/docs/` - Backend module docs
- `swapbuds-frontend/docs/` - Frontend feature docs
