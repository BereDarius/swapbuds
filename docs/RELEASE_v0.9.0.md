# 📬 SWAPBUDS Backend v0.9.0 - Messaging System

> **Release Date**: November 22, 2025
> **Status**: ✅ Complete

## 🎉 Overview

Version 0.9.0 introduces a comprehensive messaging system that enables direct communication between users on the SWAPBUDS platform. The system features conversation-based messaging, real-time delivery via WebSocket, read receipts, and integration with the notification system from v0.8.0.

## ✨ New Features

### Conversation-Based Messaging

- **Direct Messages**: Users can message any other user directly
- **Trade Context**: Messages can be linked to specific trades for negotiation
- **Conversation Management**: Automatic conversation creation between user pairs
- **User ID Normalization**: Prevents duplicate conversations (smaller user ID always stored as user1)

### Message Operations

- **Send Messages**: Create text messages with optional trade context
- **Get Conversations**: List all conversations with last message preview and unread count
- **Get Messages**: Retrieve paginated message history for a conversation
- **Mark as Read**: Mark individual messages or entire conversations as read
- **Soft Delete**: Delete messages (soft delete preserves message history)
- **Unread Count**: Get total unread messages across all conversations

### Real-Time Features

- **WebSocket Message Delivery**: Instant message delivery to online recipients
- **Read Receipts**: Real-time read status updates to senders
- **Typing Indicators**: Show when users are typing (infrastructure ready)
- **Bulk Read Status**: Notify when multiple messages are marked as read

### Notification Integration

- **NEW_MESSAGE Notifications**: Automatic notification creation when messages arrive
- **Email Support**: Optional email notifications for new messages (respects preferences)
- **User Preferences**: Uses `emailNewMessage` and `pushNewMessage` settings from v0.8.0
- **Metadata**: Includes messageId, conversationId, and sender info for deep linking
- **Preview**: Shows first 100 characters of message in notification

## 🗃️ Database Schema

### Conversation Model

```prisma
model Conversation {
  id                    String    @id @default(cuid())
  user1Id               String
  user2Id               String
  tradeId               String?   @unique
  lastMessageContent    String?
  lastMessageAt         DateTime?
  lastMessageSenderId   String?
  createdAt             DateTime  @default(now())
  updatedAt             DateTime  @updatedAt

  user1     User      @relation("ConversationsAsUser1", fields: [user1Id], references: [id], onDelete: Cascade)
  user2     User      @relation("ConversationsAsUser2", fields: [user2Id], references: [id], onDelete: Cascade)
  trade     Trade?    @relation(fields: [tradeId], references: [id], onDelete: SetNull)
  messages  Message[]

  @@unique([user1Id, user2Id])
  @@index([user1Id])
  @@index([user2Id])
  @@index([tradeId])
  @@map("conversations")
}
```

### Message Model

```prisma
model Message {
  id             String    @id @default(cuid())
  content        String
  type           String    @default("text")
  senderId       String
  conversationId String
  isRead         Boolean   @default(false)
  readAt         DateTime?
  isDeleted      Boolean   @default(false)
  createdAt      DateTime  @default(now())
  updatedAt      DateTime  @updatedAt

  sender       User         @relation(fields: [senderId], references: [id], onDelete: Cascade)
  conversation Conversation @relation(fields: [conversationId], references: [id], onDelete: Cascade)

  @@index([conversationId])
  @@index([senderId])
  @@index([isRead])
  @@map("messages")
}
```

## 🔌 API Endpoints

### Messages Controller

All endpoints require JWT authentication (`@UseGuards(JwtAuthGuard)`).

#### `POST /api/messages`

Send a message to another user.

**Request Body:**

```typescript
{
  content: string;        // Message content (max 5000 chars)
  recipientId: string;    // Recipient user ID
  tradeId?: string;       // Optional trade context
  type?: string;          // Message type (default: "text")
}
```

**Response:**

```typescript
{
  id: string;
  content: string;
  type: string;
  senderId: string;
  conversationId: string;
  isRead: boolean;
  readAt: Date | null;
  createdAt: Date;
  sender: {
    id: string;
    username: string;
    avatarUrl: string | null;
  }
}
```

#### `GET /api/messages/conversations`

Get all conversations for the authenticated user.

**Response:**

```typescript
[
  {
    id: string;
    user1Id: string;
    user2Id: string;
    tradeId: string | null;
    lastMessageContent: string | null;
    lastMessageAt: Date | null;
    lastMessageSenderId: string | null;
    createdAt: Date;
    updatedAt: Date;
    otherUser: {
      id: string;
      username: string;
      avatarUrl: string | null;
    };
    trade?: {
      id: string;
      status: string;
      // ... other trade fields
    };
    unreadCount: number;
  }
]
```

#### `GET /api/messages/conversations/:conversationId`

Get paginated messages in a conversation.

**Query Parameters:**

- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 50, max: 100)

**Response:**

```typescript
{
  messages: MessageResponseDto[];
  total: number;
}
```

#### `PATCH /api/messages/:id/read`

Mark a specific message as read.

**Response:** MessageResponseDto with `isRead: true` and `readAt` timestamp.

#### `PATCH /api/messages/conversations/:conversationId/read`

Mark all unread messages in a conversation as read.

**Response:**

```typescript
{
  count: number; // Number of messages marked as read
}
```

#### `DELETE /api/messages/:id`

Soft delete a message (sender only).

**Response:**

```typescript
{
  message: "Message deleted successfully";
}
```

#### `GET /api/messages/unread/count`

Get total unread message count across all conversations.

**Response:**

```typescript
{
  count: number;
}
```

## 🔌 WebSocket Events

Connect to the NotificationsGateway (`/notifications` namespace) to receive real-time message events.

### Events Emitted to Clients

#### `message`

New message received in a conversation.

**Payload:**

```typescript
{
  id: string;
  content: string;
  type: string;
  senderId: string;
  conversationId: string;
  isRead: boolean;
  readAt: Date | null;
  createdAt: Date;
  sender: {
    id: string;
    username: string;
    avatarUrl: string | null;
  }
}
```

#### `messageRead`

A message has been marked as read.

**Payload:**

```typescript
{
  messageId: string;
  conversationId: string;
}
```

#### `conversationRead`

Multiple messages in a conversation have been marked as read.

**Payload:**

```typescript
{
  conversationId: string;
  count: number;
}
```

#### `messageDeleted`

A message has been deleted.

**Payload:**

```typescript
{
  messageId: string;
  conversationId: string;
}
```

#### `typing`

Typing indicator (infrastructure ready, not yet used).

**Payload:**

```typescript
{
  conversationId: string;
  isTyping: boolean;
  username: string;
}
```

## 🧪 Testing

### Test Coverage

- **MessagesService**: 24 tests covering all business logic
- **MessagesController**: 11 tests covering all REST endpoints
- **Total**: 35 tests, all passing ✅

### Test Categories

1. **Message Sending**: Validation, error handling, conversation creation
2. **Conversations**: Listing, unread counts, authorization
3. **Message Retrieval**: Pagination, authorization, filtering
4. **Read Receipts**: Single and bulk marking, real-time updates
5. **Message Deletion**: Soft delete, ownership validation
6. **Unread Counts**: Aggregation across conversations

### Running Tests

```bash
# Run all messaging tests
yarn test messages

# Run with coverage
yarn test:cov messages
```

## 🔧 Implementation Details

### Service Layer (`MessagesService`)

- **Dependencies**: PrismaService, NotificationsGateway, NotificationsService
- **Methods**:
  - `sendMessage()`: Creates message, updates conversation, emits WebSocket, creates notification
  - `getConversations()`: Lists conversations with unread counts
  - `getMessages()`: Paginated messages with authorization
  - `markAsRead()`: Single message read status
  - `markConversationAsRead()`: Bulk read operation
  - `deleteMessage()`: Soft delete with authorization
  - `getUnreadCount()`: Total unread messages
  - `getOrCreateConversation()`: Helper for conversation management
  - `formatMessageResponse()`: Response formatting

### Controller Layer (`MessagesController`)

- **Guards**: JwtAuthGuard on all endpoints
- **Validation**: Class-validator DTOs
- **Authorization**: Ownership checks in service layer
- **Responses**: Standardized DTOs for consistency

### WebSocket Integration

- **Gateway**: Extended NotificationsGateway (v0.8.0)
- **Authentication**: JWT token in connection handshake
- **Room Management**: User-specific rooms for targeted events
- **Events**: 5 message-related events

### Notification Integration

- **Type**: NEW_MESSAGE notification type
- **Trigger**: Automatic when message is sent
- **Content**: Title with sender username, preview of message content
- **Metadata**: messageId, conversationId, senderId, senderUsername
- **Preferences**: Respects `emailNewMessage` and `pushNewMessage` settings
- **Email**: Optional HTML email via MailService (if enabled)

## 🚀 Migration Guide

### Database Migration

```bash
# Apply the migration
yarn prisma migrate deploy

# Or in development
yarn prisma migrate dev
```

**Migration Name**: `20251122075752_add_messaging_system`

### Breaking Changes

None. This is a new feature with no changes to existing APIs.

### New Dependencies

No new external dependencies. Uses existing infrastructure:

- Prisma (database ORM)
- Socket.IO (WebSocket, from v0.8.0)
- Email system (from v0.8.0)
- Notification preferences (from v0.8.0)

## 📝 Usage Examples

### Sending a Message

```typescript
// Send a direct message
const response = await fetch("http://localhost:3001/api/messages", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    Authorization: `Bearer ${token}`,
  },
  body: JSON.stringify({
    content: "Hey, is your skateboard still available?",
    recipientId: "user-123",
  }),
});

const message = await response.json();
console.log("Message sent:", message);
```

### Sending a Trade-Related Message

```typescript
// Send message with trade context
const response = await fetch("http://localhost:3001/api/messages", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    Authorization: `Bearer ${token}`,
  },
  body: JSON.stringify({
    content: "I accept your trade proposal!",
    recipientId: "user-123",
    tradeId: "trade-456",
  }),
});
```

### Getting Conversations

```typescript
// Get all conversations
const response = await fetch(
  "http://localhost:3001/api/messages/conversations",
  {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  },
);

const conversations = await response.json();
conversations.forEach((conv) => {
  console.log(`Chat with ${conv.otherUser.username}`);
  console.log(`Last message: ${conv.lastMessageContent}`);
  console.log(`Unread: ${conv.unreadCount}`);
});
```

### Getting Messages in a Conversation

```typescript
// Get paginated messages
const response = await fetch(
  "http://localhost:3001/api/messages/conversations/conv-123?page=1&limit=50",
  {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  },
);

const data = await response.json();
console.log(`${data.total} total messages`);
data.messages.forEach((msg) => {
  console.log(`${msg.sender.username}: ${msg.content}`);
});
```

### Real-Time Message Listening

```typescript
import { io } from "socket.io-client";

const socket = io("ws://localhost:3001/notifications", {
  auth: {
    token: yourJwtToken,
  },
});

// Subscribe to receive events
socket.emit("subscribe", userId);

// Listen for new messages
socket.on("message", (message) => {
  console.log("New message from:", message.sender.username);
  console.log("Content:", message.content);

  // Update UI
  addMessageToUI(message);

  // Mark as read
  await fetch(`http://localhost:3001/api/messages/${message.id}/read`, {
    method: "PATCH",
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });
});

// Listen for read receipts
socket.on("messageRead", ({ messageId, conversationId }) => {
  updateMessageReadStatus(messageId, true);
});

// Listen for typing indicators
socket.on("typing", ({ conversationId, isTyping, username }) => {
  showTypingIndicator(conversationId, isTyping, username);
});
```

## 🔒 Security Considerations

### Authorization

- All endpoints require JWT authentication
- Users can only:
  - Read messages in their own conversations
  - Delete their own messages
  - Mark messages sent to them as read

### Validation

- Message content limited to 5000 characters
- Recipient must exist
- Cannot message yourself
- Pagination limits enforced (max 100 per page)

### Data Protection

- Soft delete preserves message history
- Conversations linked to user relationships
- Trade context is optional and can be null if trade is deleted

## 🐛 Known Limitations

- **Message Types**: Currently only supports text messages (image support planned)
- **Typing Indicators**: Infrastructure ready but not actively tracked
- **Message Search**: No full-text search yet
- **Message Editing**: Not supported (delete and resend)
- **Bulk Operations**: Can't delete entire conversations

## 🔮 Future Enhancements

- Image and file attachments
- Message reactions (emoji)
- Message search and filtering
- Conversation archiving
- Group conversations
- Message forwarding
- Voice messages
- Link previews

## 📊 Performance Considerations

- **Pagination**: Default 50 messages per page prevents large payloads
- **Indexing**: Database indexes on conversationId, senderId, isRead
- **Soft Delete**: Messages flagged as deleted, not removed (preserves history)
- **Unread Count**: Efficient query across all conversations
- **WebSocket**: Targeted event emission to specific users only

## 🎯 Version History

- **v0.9.0** (Nov 22, 2025) - Initial messaging system release
  - Conversation-based messaging
  - REST API with 7 endpoints
  - WebSocket integration with 5 events
  - Notification integration
  - 35 comprehensive tests

## 📚 Related Documentation

- [v0.8.0 Release Notes](./RELEASE_v0.8.0.md) - Real-time notifications and email
- [v0.7.0 Release Notes](./RELEASE_v0.7.0.md) - Notification system foundation
- [API Documentation](./API.md) - Complete API reference
- [Architecture](./ARCHITECTURE.md) - System architecture overview

---

**Questions or Issues?**
Open an issue on GitHub or contact the development team.

**Contributors:**

- BereDarius - Complete messaging system implementation

---

🎉 **Thank you for using SWAPBUDS!**
