# SwapBuds API Endpoints

**Base URL:** `http://localhost:3001/api` (development)
**Last Updated:** November 26, 2025

---

## 🔐 Authentication Endpoints

**Base Path:** `/api/auth`

| Method | Endpoint           | Description               | Auth | Body                                                                                                        |
| ------ | ------------------ | ------------------------- | ---- | ----------------------------------------------------------------------------------------------------------- |
| POST   | `/register`        | Create new user account   | ❌   | `{ email, username, password, dateOfBirth, selfDeclaredAge18, tosVersion, privacyVersion, recaptchaToken }` |
| POST   | `/login`           | Login existing user       | ❌   | `{ email, password, recaptchaToken }`                                                                       |
| POST   | `/logout`          | Logout current user       | ✅   | -                                                                                                           |
| GET    | `/me`              | Get current user info     | ✅   | -                                                                                                           |
| POST   | `/refresh`         | Refresh JWT token         | ✅   | -                                                                                                           |
| POST   | `/forgot-password` | Request password reset    | ❌   | `{ email }`                                                                                                 |
| POST   | `/reset-password`  | Reset password with token | ❌   | `{ token, newPassword }`                                                                                    |

---

## 📦 Items Endpoints

**Base Path:** `/api/items`

| Method | Endpoint           | Description              | Auth       | Query/Body                                                                             |
| ------ | ------------------ | ------------------------ | ---------- | -------------------------------------------------------------------------------------- |
| GET    | `/`                | List all available items | ✅         | `?page=1&limit=12&category=ELECTRONICS&condition=NEW&search=keyword`                   |
| GET    | `/:id`             | Get single item details  | ✅         | -                                                                                      |
| GET    | `/user/:userId`    | Get user's items         | ✅         | `?page=1&limit=12`                                                                     |
| GET    | `/recommendations` | Get recommended items    | ✅         | `?limit=10`                                                                            |
| GET    | `/:id/similar`     | Get similar items        | ✅         | `?limit=10`                                                                            |
| POST   | `/`                | Create new item          | ✅         | `{ title, description, condition, category, deliveryMethods, estimatedValue, images }` |
| PATCH  | `/:id`             | Update item              | ✅ (Owner) | `{ title?, description?, condition?, status? }`                                        |
| DELETE | `/:id`             | Delete item              | ✅ (Owner) | -                                                                                      |

---

## 🔄 Trades Endpoints

**Base Path:** `/api/trades`

| Method | Endpoint                     | Description                  | Auth           | Body                                                                       |
| ------ | ---------------------------- | ---------------------------- | -------------- | -------------------------------------------------------------------------- |
| GET    | `/my-trades`                 | Get user's trades            | ✅             | `?status=PENDING&role=proposer`                                            |
| GET    | `/:id`                       | Get trade details            | ✅             | -                                                                          |
| GET    | `/:id/counter-offers`        | Get counter offers for trade | ✅             | -                                                                          |
| POST   | `/`                          | Create new trade             | ✅             | `{ responderId, itemOfferedId, itemRequestedId, deliveryMethod, message }` |
| POST   | `/:id/counter-offers`        | Create counter offer         | ✅             | `{ alternativeItemId, message }`                                           |
| PATCH  | `/:id/accept`                | Accept trade                 | ✅ (Responder) | -                                                                          |
| PATCH  | `/:id/reject`                | Reject trade                 | ✅ (Responder) | `{ reason }`                                                               |
| PATCH  | `/:id/cancel`                | Cancel trade                 | ✅ (Proposer)  | `{ reason }`                                                               |
| PATCH  | `/counter-offers/:id/accept` | Accept counter offer         | ✅             | -                                                                          |
| PATCH  | `/counter-offers/:id/reject` | Reject counter offer         | ✅             | -                                                                          |

---

## 💬 Messages Endpoints

**Base Path:** `/api/messages`

| Method | Endpoint                  | Description                         | Auth        | Body                             |
| ------ | ------------------------- | ----------------------------------- | ----------- | -------------------------------- |
| GET    | `/conversations`          | List user's conversations           | ✅          | -                                |
| GET    | `/conversations/:id`      | Get conversation messages           | ✅          | `?page=1&limit=50`               |
| GET    | `/unread/count`           | Get unread message count            | ✅          | -                                |
| POST   | `/`                       | Send new message                    | ✅          | `{ recipientId, content, type }` |
| PATCH  | `/:id/read`               | Mark message as read                | ✅          | -                                |
| PATCH  | `/conversations/:id/read` | Mark all conversation messages read | ✅          | -                                |
| DELETE | `/:id`                    | Delete message                      | ✅ (Sender) | -                                |

---

## 👤 Users Endpoints

**Base Path:** `/api/users`

| Method | Endpoint             | Description               | Auth       | Body                                    |
| ------ | -------------------- | ------------------------- | ---------- | --------------------------------------- |
| GET    | `/`                  | Search users              | ✅ (Admin) | `?search=username&page=1&limit=20`      |
| GET    | `/:id`               | Get user profile          | ✅         | -                                       |
| GET    | `/:id/statistics`    | Get user stats            | ✅         | -                                       |
| GET    | `/me/settings`       | Get current user settings | ✅         | -                                       |
| PATCH  | `/profile`           | Update user profile       | ✅         | `{ bio?, location?, avatarUrl? }`       |
| PATCH  | `/me/settings`       | Update user settings      | ✅         | `{ theme?, language?, notifications? }` |
| POST   | `/avatar`            | Upload avatar image       | ✅         | `FormData: { file }`                    |
| POST   | `/me/settings/reset` | Reset settings to default | ✅         | -                                       |

---

## 🔔 Notifications Endpoints

**Base Path:** `/api/notifications`

| Method | Endpoint        | Description                  | Auth | Body                                          |
| ------ | --------------- | ---------------------------- | ---- | --------------------------------------------- |
| GET    | `/`             | List user notifications      | ✅   | `?page=1&limit=20&unread=true`                |
| GET    | `/unread-count` | Get unread count             | ✅   | -                                             |
| GET    | `/preferences`  | Get notification preferences | ✅   | -                                             |
| PATCH  | `/:id/read`     | Mark notification as read    | ✅   | -                                             |
| PATCH  | `/read-all`     | Mark all as read             | ✅   | -                                             |
| PUT    | `/preferences`  | Update preferences           | ✅   | `{ emailTradeProposal, pushNewMessage, ... }` |
| DELETE | `/:id`          | Delete notification          | ✅   | -                                             |

---

## ⭐ Reviews Endpoints

**Base Path:** `/api/reviews`

| Method | Endpoint               | Description                 | Auth        | Body                            |
| ------ | ---------------------- | --------------------------- | ----------- | ------------------------------- |
| GET    | `/users/:userId`       | Get user's received reviews | ✅          | -                               |
| GET    | `/me/given`            | Get reviews I gave          | ✅          | -                               |
| GET    | `/me`                  | Get reviews I received      | ✅          | -                               |
| GET    | `/:id`                 | Get single review           | ✅          | -                               |
| GET    | `/trades/:tradeId/all` | Get all reviews for trade   | ✅          | -                               |
| POST   | `/trades/:tradeId`     | Create review for trade     | ✅          | `{ rating, comment, targetId }` |
| PUT    | `/:id`                 | Update review               | ✅ (Author) | `{ rating?, comment? }`         |
| DELETE | `/:id`                 | Delete review               | ✅ (Author) | -                               |

---

## ❤️ Likes Endpoints

**Base Path:** `/api/likes`

| Method | Endpoint               | Description              | Auth | Body |
| ------ | ---------------------- | ------------------------ | ---- | ---- |
| GET    | `/items/:itemId/check` | Check if user liked item | ✅   | -    |
| GET    | `/items/:itemId`       | Get item likes count     | ✅   | -    |
| POST   | `/items/:itemId`       | Like item                | ✅   | -    |
| DELETE | `/items/:itemId`       | Unlike item              | ✅   | -    |

---

## 💬 Comments Endpoints

**Base Path:** `/api/comments`

| Method | Endpoint         | Description       | Auth              | Body               |
| ------ | ---------------- | ----------------- | ----------------- | ------------------ |
| GET    | `/items/:itemId` | Get item comments | ✅                | `?page=1&limit=20` |
| POST   | `/items/:itemId` | Create comment    | ✅                | `{ content }`      |
| PATCH  | `/:id`           | Update comment    | ✅ (Author)       | `{ content }`      |
| DELETE | `/:id`           | Delete comment    | ✅ (Author/Admin) | -                  |

---

## 🛡️ Moderation Endpoints

**Base Path:** `/api/moderation`

| Method | Endpoint                      | Description              | Auth     | Body                          |
| ------ | ----------------------------- | ------------------------ | -------- | ----------------------------- |
| GET    | `/items/flagged`              | List flagged items       | ✅ (Mod) | `?status=PENDING&reason=SPAM` |
| GET    | `/items/flagged/:id`          | Get flagged item details | ✅ (Mod) | -                             |
| GET    | `/stats`                      | Get moderation stats     | ✅ (Mod) | -                             |
| POST   | `/items/:id/flag`             | Flag item                | ✅       | `{ reason, description }`     |
| PATCH  | `/items/flagged/:id/approve`  | Approve flagged item     | ✅ (Mod) | `{ reviewNotes }`             |
| PATCH  | `/items/flagged/bulk-approve` | Bulk approve flags       | ✅ (Mod) | `{ flagIds[] }`               |
| PATCH  | `/items/flagged/bulk-reject`  | Bulk reject flags        | ✅ (Mod) | `{ flagIds[] }`               |
| DELETE | `/items/flagged/:id`          | Remove flagged item      | ✅ (Mod) | `{ reviewNotes }`             |
| DELETE | `/items/flagged/bulk-remove`  | Bulk remove items        | ✅ (Mod) | `{ flagIds[] }`               |

---

## ⚙️ Admin Endpoints

**Base Path:** `/api/admin`

| Method | Endpoint            | Description             | Auth       | Body                             |
| ------ | ------------------- | ----------------------- | ---------- | -------------------------------- |
| GET    | `/stats`            | Get platform statistics | ✅ (Admin) | -                                |
| GET    | `/users`            | List all users          | ✅ (Admin) | `?search=email&role=USER&page=1` |
| GET    | `/users/:id`        | Get user details        | ✅ (Admin) | -                                |
| GET    | `/audit-logs`       | List audit logs         | ✅ (Admin) | `?action=USER_BAN&page=1`        |
| GET    | `/audit-logs/stats` | Get audit log stats     | ✅ (Admin) | -                                |
| PATCH  | `/users/:id/ban`    | Ban user                | ✅ (Admin) | `{ reason }`                     |
| PATCH  | `/users/:id/unban`  | Unban user              | ✅ (Admin) | -                                |
| PATCH  | `/users/:id/role`   | Change user role        | ✅ (Admin) | `{ role }`                       |
| PATCH  | `/users/bulk-ban`   | Bulk ban users          | ✅ (Admin) | `{ userIds[], reason }`          |
| PATCH  | `/users/bulk-unban` | Bulk unban users        | ✅ (Admin) | `{ userIds[] }`                  |
| PATCH  | `/users/bulk-role`  | Bulk change roles       | ✅ (Admin) | `{ userIds[], role }`            |

---

## ✅ Verification Endpoints

**Base Path:** `/api/verification`

| Method | Endpoint                  | Description                | Auth       | Body                                         |
| ------ | ------------------------- | -------------------------- | ---------- | -------------------------------------------- |
| GET    | `/me`                     | Get my verification status | ✅         | -                                            |
| GET    | `/admin/pending`          | List pending verifications | ✅ (Admin) | `?page=1&limit=20`                           |
| GET    | `/admin/stats`            | Get verification stats     | ✅ (Admin) | -                                            |
| GET    | `/admin/:id`              | Get verification details   | ✅ (Admin) | -                                            |
| GET    | `/admin/:id/document-url` | Get signed document URL    | ✅ (Admin) | -                                            |
| POST   | `/`                       | Submit verification        | ✅         | `{ documentType, documentUrl, dateOfBirth }` |
| PATCH  | `/admin/:id/approve`      | Approve verification       | ✅ (Admin) | -                                            |
| PATCH  | `/admin/:id/reject`       | Reject verification        | ✅ (Admin) | `{ rejectionReason }`                        |
| DELETE | `/me`                     | Cancel my verification     | ✅         | -                                            |

---

## 🎫 Support Endpoints

**Base Path:** `/api/support`

| Method | Endpoint              | Description                | Auth         | Body                                    |
| ------ | --------------------- | -------------------------- | ------------ | --------------------------------------- |
| GET    | `/chats`              | Get my support chats       | ✅           | -                                       |
| GET    | `/chats/:id`          | Get chat details           | ✅           | -                                       |
| GET    | `/agent/chats`        | Get agent's assigned chats | ✅ (Support) | `?status=ACTIVE`                        |
| GET    | `/stats`              | Get support statistics     | ✅ (Support) | -                                       |
| POST   | `/chat`               | Create support ticket      | ✅           | `{ subject, priority, initialMessage }` |
| POST   | `/chats/:id/messages` | Send message in chat       | ✅           | `{ message }`                           |
| PATCH  | `/chats/:id/close`    | Close support chat         | ✅           | -                                       |
| PATCH  | `/chats/:id/resolve`  | Resolve chat               | ✅ (Support) | `{ resolution }`                        |

---

## ⚖️ Disputes Endpoints

**Base Path:** `/api/disputes`

| Method | Endpoint       | Description         | Auth       | Body                                               |
| ------ | -------------- | ------------------- | ---------- | -------------------------------------------------- |
| GET    | `/`            | List all disputes   | ✅ (Admin) | `?status=OPEN&page=1`                              |
| GET    | `/my`          | Get my disputes     | ✅         | -                                                  |
| GET    | `/:id`         | Get dispute details | ✅         | -                                                  |
| POST   | `/`            | Create dispute      | ✅         | `{ tradeId, reason, description, reportedUserId }` |
| PATCH  | `/:id/assign`  | Assign to admin     | ✅ (Admin) | `{ adminId }`                                      |
| PATCH  | `/:id/resolve` | Resolve dispute     | ✅ (Admin) | `{ resolution }`                                   |
| PATCH  | `/:id/close`   | Close dispute       | ✅ (Admin) | -                                                  |

---

## 📤 Upload Endpoints

**Base Path:** `/api/upload`

| Method | Endpoint  | Description                 | Auth | Body                    |
| ------ | --------- | --------------------------- | ---- | ----------------------- |
| POST   | `/images` | Upload images to Cloudinary | ✅   | `FormData: { files[] }` |

---

## 📜 Legal Endpoints

**Base Path:** `/api/legal`

| Method | Endpoint                                     | Description                      | Auth       | Body                                              |
| ------ | -------------------------------------------- | -------------------------------- | ---------- | ------------------------------------------------- |
| GET    | `/documents/:type`                           | Get active legal document        | ❌         | `?language=EN`                                    |
| GET    | `/documents/:type/version/:version`          | Get specific version             | ❌         | `?language=EN`                                    |
| GET    | `/documents/:type/versions`                  | List all versions                | ✅ (Admin) | -                                                 |
| GET    | `/consents`                                  | Get user's consents              | ✅         | -                                                 |
| GET    | `/acceptance-required`                       | Check if new acceptance required | ✅         | -                                                 |
| GET    | `/cookie-consent`                            | Get cookie consent               | ✅         | -                                                 |
| POST   | `/documents`                                 | Create new legal document        | ✅ (Admin) | `{ type, version, contentEn, contentRo, title }`  |
| POST   | `/accept`                                    | Accept legal document            | ✅         | `{ documentType, documentVersion }`               |
| POST   | `/cookie-consent`                            | Save cookie consent              | ✅         | `{ essential, functional, analytics, marketing }` |
| PUT    | `/documents/:type/version/:version/activate` | Activate document version        | ✅ (Admin) | -                                                 |

---

## 🏥 Health & Monitoring Endpoints

**Base Path:** `/api/health`

| Method | Endpoint    | Description          | Auth       | Body |
| ------ | ----------- | -------------------- | ---------- | ---- |
| GET    | `/`         | Overall health check | ❌         | -    |
| GET    | `/database` | Database health      | ✅ (Admin) | -    |
| GET    | `/redis`    | Redis health         | ✅ (Admin) | -    |
| GET    | `/memory`   | Memory usage         | ✅ (Admin) | -    |
| GET    | `/disk`     | Disk usage           | ✅ (Admin) | -    |

**Base Path:** `/api/monitoring`

| Method | Endpoint       | Description          | Auth       |
| ------ | -------------- | -------------------- | ---------- |
| GET    | `/metrics`     | Get metrics          | ✅ (Admin) |
| GET    | `/errors`      | Get error logs       | ✅ (Admin) |
| GET    | `/performance` | Get performance data | ✅ (Admin) |

**Base Path:** `/api/cache`

| Method | Endpoint       | Description          | Auth       |
| ------ | -------------- | -------------------- | ---------- |
| GET    | `/stats`       | Get cache statistics | ✅ (Admin) |
| GET    | `/health`      | Check cache health   | ✅ (Admin) |
| POST   | `/reset-stats` | Reset cache stats    | ✅ (Admin) |

---

## 🌐 Waitlist Endpoints

**Base Path:** `/api/waitlist`

| Method | Endpoint      | Description           | Auth       | Body                                |
| ------ | ------------- | --------------------- | ---------- | ----------------------------------- |
| POST   | `/join`       | Join waitlist         | ❌         | `{ email, source?, referralCode? }` |
| GET    | `/`           | List waitlist entries | ✅ (Admin) | `?notified=false&page=1`            |
| POST   | `/:id/notify` | Mark as notified      | ✅ (Admin) | -                                   |

---

## 🔄 GDPR Endpoints

**Base Path:** `/api/gdpr`

| Method | Endpoint                 | Description              | Auth | Body               |
| ------ | ------------------------ | ------------------------ | ---- | ------------------ |
| POST   | `/export`                | Request data export      | ✅   | -                  |
| GET    | `/export/:exportId`      | Download exported data   | ✅   | -                  |
| POST   | `/delete-account`        | Request account deletion | ✅   | `{ confirmation }` |
| DELETE | `/delete-account`        | Cancel deletion request  | ✅   | -                  |
| GET    | `/delete-account/status` | Check deletion status    | ✅   | -                  |

---

## 📡 WebSocket Events

### Connection

- **Endpoint:** `ws://localhost:3001`
- **Namespaces:** `/messages`, `/notifications`, `/support`

### Authentication

```javascript
io.connect(url, {
  auth: { token: "JWT_TOKEN" },
});
```

### Message Events

| Event                | Direction       | Payload                       |
| -------------------- | --------------- | ----------------------------- |
| `join_conversation`  | Client → Server | `{ conversationId }`          |
| `leave_conversation` | Client → Server | `{ conversationId }`          |
| `start_typing`       | Client → Server | `{ conversationId }`          |
| `stop_typing`        | Client → Server | `{ conversationId }`          |
| `new_message`        | Server → Client | `{ message, conversationId }` |
| `message_read`       | Server → Client | `{ messageId, readAt }`       |
| `typing`             | Server → Client | `{ userId, conversationId }`  |

### Notification Events

| Event                  | Direction       | Payload              |
| ---------------------- | --------------- | -------------------- |
| `new_notification`     | Server → Client | `{ notification }`   |
| `notification_read`    | Server → Client | `{ notificationId }` |
| `notification_deleted` | Server → Client | `{ notificationId }` |

### Support Events

| Event                | Direction       | Payload                  |
| -------------------- | --------------- | ------------------------ |
| `join_support_chat`  | Client → Server | `{ chatId }`             |
| `leave_support_chat` | Client → Server | `{ chatId }`             |
| `support_message`    | Server → Client | `{ message, chatId }`    |
| `agent_joined`       | Server → Client | `{ agentId, chatId }`    |
| `chat_resolved`      | Server → Client | `{ chatId, resolution }` |

---

## 🔒 Authorization Levels

| Symbol       | Meaning                            |
| ------------ | ---------------------------------- |
| ❌           | No authentication required         |
| ✅           | Authentication required (any user) |
| ✅ (Owner)   | Must be resource owner             |
| ✅ (Mod)     | Requires MODERATOR role or higher  |
| ✅ (Support) | Requires SUPPORT role or higher    |
| ✅ (Admin)   | Requires ADMIN role                |

---

## 📝 Common Response Formats

### Success Response

```json
{
  "data": {
    /* response data */
  },
  "message": "Success message"
}
```

### Error Response

```json
{
  "statusCode": 400,
  "message": "Error message",
  "error": "Bad Request"
}
```

### Paginated Response

```json
{
  "data": [
    /* items */
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "pages": 5
  }
}
```

---

**For implementation details and DTOs, see module-specific documentation in `swapbuds-backend/docs/`**
