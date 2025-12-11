# SWAPBUDS API Documentation

> **Note:** This document will be populated as the API is implemented.
> For now, it serves as a template for the planned endpoints.

## Base URL

- **Development:** `http://localhost:3001/api`
- **Production:** `https://api.swapbuds.com/api` (TBD)

## Authentication

All authenticated endpoints require a JWT token in the Authorization header or httpOnly cookie.

```http
Authorization: Bearer <token>
```

## Endpoints

### Authentication

#### Register

```http
POST /api/auth/register
Content-Type: application/json

{
  "username": "string",
  "email": "string",
  "password": "string"
}

Response: 201 Created
{
  "user": { ... },
  "token": "string"
}
```

#### Login

```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "string",
  "password": "string"
}

Response: 200 OK
{
  "user": { ... },
  "token": "string"
}
```

#### Logout

```http
POST /api/auth/logout
Authorization: Bearer <token>

Response: 200 OK
{
  "message": "Logged out successfully"
}
```

#### Get Current User

```http
GET /api/auth/me
Authorization: Bearer <token>

Response: 200 OK
{
  "user": { ... }
}
```

---

### Users

#### Get User Profile

```http
GET /api/users/:id

Response: 200 OK
{
  "id": "string",
  "username": "string",
  "avatarUrl": "string",
  "bio": "string",
  "reputationScore": 0,
  "itemCount": 0,
  "tradeCount": 0
}
```

#### Update Profile

```http
PATCH /api/users/me
Authorization: Bearer <token>
Content-Type: application/json

{
  "bio": "string",
  "location": "string",
  "avatarUrl": "string"
}

Response: 200 OK
{
  "user": { ... }
}
```

---

### Items

#### Get All Items (Feed)

```http
GET /api/items?page=1&limit=20&category=Games&sort=newest

Response: 200 OK
{
  "items": [ ... ],
  "total": 100,
  "page": 1,
  "totalPages": 5
}
```

#### Get Item by ID

```http
GET /api/items/:id

Response: 200 OK
{
  "id": "string",
  "title": "string",
  "description": "string",
  "condition": "new|like-new|good|fair",
  "category": "string",
  "images": [ ... ],
  "user": { ... },
  "createdAt": "ISO8601"
}
```

#### Create Item

```http
POST /api/items
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "string",
  "description": "string",
  "condition": "new|like-new|good|fair",
  "category": "string",
  "tradingFor": "string",
  "isGift": false,
  "images": ["url1", "url2"]
}

Response: 201 Created
{
  "item": { ... }
}
```

#### Update Item

```http
PATCH /api/items/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "string",
  "description": "string"
}

Response: 200 OK
{
  "item": { ... }
}
```

#### Delete Item

```http
DELETE /api/items/:id
Authorization: Bearer <token>

Response: 204 No Content
```

#### Like Item

```http
POST /api/items/:id/like
Authorization: Bearer <token>

Response: 200 OK
{
  "liked": true,
  "likesCount": 10
}
```

#### Comment on Item

```http
POST /api/items/:id/comments
Authorization: Bearer <token>
Content-Type: application/json

{
  "text": "string"
}

Response: 201 Created
{
  "comment": { ... }
}
```

---

### Trades

#### Get My Trades

```http
GET /api/trades?status=proposed&type=sent

Response: 200 OK
{
  "trades": [ ... ]
}
```

#### Create Trade Proposal

```http
POST /api/trades
Authorization: Bearer <token>
Content-Type: application/json

{
  "itemOfferedId": "string",
  "itemRequestedId": "string",
  "message": "string"
}

Response: 201 Created
{
  "trade": { ... }
}
```

#### Accept Trade

```http
PATCH /api/trades/:id/accept
Authorization: Bearer <token>

Response: 200 OK
{
  "trade": { ... }
}
```

#### Reject Trade

```http
PATCH /api/trades/:id/reject
Authorization: Bearer <token>

Response: 200 OK
{
  "trade": { ... }
}
```

#### Complete Trade

```http
PATCH /api/trades/:id/complete
Authorization: Bearer <token>

Response: 200 OK
{
  "trade": { ... }
}
```

---

### Messages

#### Get Trade Messages

```http
GET /api/messages/trade/:tradeId
Authorization: Bearer <token>

Response: 200 OK
{
  "messages": [ ... ]
}
```

#### Send Message

```http
POST /api/messages
Authorization: Bearer <token>
Content-Type: application/json

{
  "tradeId": "string",
  "text": "string"
}

Response: 201 Created
{
  "message": { ... }
}
```

---

### Notifications

#### Get My Notifications

```http
GET /api/notifications?unread=true
Authorization: Bearer <token>

Response: 200 OK
{
  "notifications": [ ... ]
}
```

#### Mark as Read

```http
PATCH /api/notifications/:id/read
Authorization: Bearer <token>

Response: 200 OK
```

---

## WebSocket Events

### Client → Server

```javascript
// Connect
socket.connect();

// Send message
socket.emit("message:send", {
  tradeId: "string",
  text: "string",
});

// Join trade room
socket.emit("trade:join", { tradeId: "string" });

// Leave trade room
socket.emit("trade:leave", { tradeId: "string" });
```

### Server → Client

```javascript
// Receive message
socket.on("message:receive", (data) => {
  // { message: { ... } }
});

// Trade updated
socket.on("trade:update", (data) => {
  // { trade: { ... } }
});

// New notification
socket.on("notification:new", (data) => {
  // { notification: { ... } }
});
```

---

## Error Responses

All errors follow this format:

```json
{
  "statusCode": 400,
  "message": "Error description",
  "error": "Bad Request"
}
```

### Common Status Codes

- `200` - OK
- `201` - Created
- `204` - No Content
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `409` - Conflict
- `422` - Unprocessable Entity
- `500` - Internal Server Error

---

## Rate Limiting

- **Authenticated:** 100 requests/minute
- **Unauthenticated:** 20 requests/minute

---

## Pagination

List endpoints support pagination:

```
?page=1&limit=20
```

Response includes:

```json
{
  "data": [ ... ],
  "total": 100,
  "page": 1,
  "totalPages": 5
}
```

---

## Coming Soon

- [ ] Search API
- [ ] User following/followers
- [ ] Reviews API
- [ ] Admin endpoints
- [ ] Export data endpoint
