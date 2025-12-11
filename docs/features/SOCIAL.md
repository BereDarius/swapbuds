# 💬 Social Features

> **Likes, Comments, and Social Interactions**

This document covers the social features that allow users to engage with items in the marketplace.

---

## Features Overview

### Implemented

- ✅ **Item Likes** - Save favorite items
- ✅ **Comments** - Discuss items with other users
- ✅ **User Profiles** - View trader profiles and reputation

### In Progress

- 🚧 Item sharing on social media
- 🚧 Follow other users
- 🚧 Activity feed

---

## Item Likes

### Purpose

Users can "like" or "favorite" items they're interested in for easy reference later.

### How It Works

**Like an Item**:

```
POST /api/likes
{
  "itemId": "123"
}
```

**Unlike an Item**:

```
DELETE /api/likes/:itemId
```

**Get User's Liked Items**:

```
GET /api/likes/me
```

**Get Item Like Count**:

```
GET /api/items/:id
Response includes: { ..., likeCount: 42 }
```

### Use Cases

- Save items for later consideration
- Build a wishlist
- Track popular items
- Quick access to interesting items

### Frontend Implementation

```tsx
import { useLikeItem } from "@/lib/api/likes";

function LikeButton({ itemId, isLiked }) {
  const { mutate: toggleLike } = useLikeItem();

  return (
    <Button variant="ghost" onClick={() => toggleLike(itemId)}>
      {isLiked ? <HeartFilledIcon /> : <HeartIcon />}
    </Button>
  );
}
```

---

## Comments

### Purpose

Enable discussions about items between users, ask questions, and provide feedback.

### How It Works

**Add Comment**:

```
POST /api/comments
{
  "itemId": "123",
  "content": "Is this still available?"
}
```

**Get Item Comments**:

```
GET /api/comments?itemId=123&page=1&limit=20
```

**Update Comment** (own comments only):

```
PATCH /api/comments/:id
{
  "content": "Updated comment text"
}
```

**Delete Comment** (own comments or admin):

```
DELETE /api/comments/:id
```

### Features

- **Pagination**: Comments loaded in pages
- **Author Info**: Each comment shows user details
- **Timestamps**: Creation and edit times
- **Edit/Delete**: Users can manage their comments
- **Moderation**: Admins can remove inappropriate comments

### Comment Structure

```typescript
interface Comment {
  id: string;
  content: string;
  itemId: string;
  userId: string;
  author: {
    id: string;
    username: string;
    avatarUrl?: string;
  };
  createdAt: string;
  updatedAt: string;
  isEdited: boolean;
}
```

### Frontend Implementation

```tsx
import { useComments, useAddComment } from "@/lib/api/comments";

function CommentSection({ itemId }) {
  const { data: comments, isLoading } = useComments(itemId);
  const { mutate: addComment } = useAddComment();

  const handleSubmit = (content: string) => {
    addComment({ itemId, content });
  };

  return (
    <div>
      <CommentForm onSubmit={handleSubmit} />
      {comments?.map((comment) => (
        <CommentCard key={comment.id} comment={comment} />
      ))}
    </div>
  );
}
```

---

## User Profiles

### Profile Information

- Username and display name
- Avatar image
- Member since date
- Trade statistics
- Reputation score
- Recent activity

### Viewing Profiles

```
GET /api/users/:id/profile
```

Response:

```json
{
  "id": "user-123",
  "username": "trader_joe",
  "displayName": "Joe Trading",
  "avatarUrl": "https://...",
  "bio": "Avid collector...",
  "stats": {
    "itemsListed": 15,
    "tradesCompleted": 8,
    "reputation": 4.8,
    "memberSince": "2024-01-15"
  }
}
```

---

## Reputation System

### How Reputation Works

Users build reputation through:

- **Completed Trades** - Successfully trading items
- **Reviews** - Receiving positive reviews
- **Activity** - Active participation
- **Verification** - Account verification

### Reputation Score

Score range: 1.0 to 5.0

Calculated from:

- Average review rating (70% weight)
- Trade completion rate (20% weight)
- Account age bonus (10% weight)

### Display Badges

```tsx
function ReputationBadge({ score }) {
  if (score >= 4.5) return <Badge variant="gold">Trusted Trader</Badge>;
  if (score >= 4.0) return <Badge variant="silver">Good Trader</Badge>;
  if (score >= 3.0) return <Badge variant="bronze">Active Trader</Badge>;
  return <Badge variant="default">New Trader</Badge>;
}
```

---

## Notifications

Social actions trigger notifications:

- ✅ Someone likes your item
- ✅ Someone comments on your item
- ✅ Someone replies to your comment
- ✅ Mentioned in a comment

See [Notifications Documentation](./NOTIFICATIONS.md) for details.

---

## Moderation

### Content Moderation

All user-generated content can be moderated:

**Flag Content**:

```
POST /api/moderation/flag
{
  "contentType": "comment",
  "contentId": "comment-123",
  "reason": "spam"
}
```

**Admin Actions**:

- Remove comments
- Ban users from commenting
- Review flagged content

See [Moderation Documentation](./MODERATION.md) for full details.

---

## Privacy & Safety

### Privacy Controls

- Users can hide their liked items
- Comments can be disabled per item
- Profile information visibility settings

### Safety Features

- Report inappropriate content
- Block users
- Comment filtering
- Automatic spam detection

---

## Best Practices

### For Users

✅ Be respectful in comments
✅ Ask relevant questions
✅ Provide constructive feedback
✅ Report spam or inappropriate content

### For Developers

✅ Validate all user input
✅ Sanitize comment content
✅ Implement rate limiting
✅ Cache like counts
✅ Paginate comments

---

## API Rate Limits

Social actions are rate-limited:

- **Like/Unlike**: 60 per hour
- **Add Comment**: 30 per hour
- **Edit Comment**: 20 per hour

---

## Database Schema

### Likes Table

```prisma
model Like {
  id        String   @id @default(cuid())
  userId    String
  itemId    String
  createdAt DateTime @default(now())

  user User @relation(fields: [userId], references: [id])
  item Item @relation(fields: [itemId], references: [id])

  @@unique([userId, itemId])
}
```

### Comments Table

```prisma
model Comment {
  id        String   @id @default(cuid())
  content   String
  itemId    String
  userId    String
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  user User @relation(fields: [userId], references: [id])
  item Item @relation(fields: [itemId], references: [id])
}
```

---

## Testing

### Unit Tests

- Like/unlike functionality
- Comment CRUD operations
- Validation logic
- Rate limiting

### Integration Tests

- Like count updates
- Comment threading
- Notification triggers

### E2E Tests

- User likes item flow
- Comment submission flow
- Profile viewing

---

## Related Documentation

- [Reviews & Ratings](./REVIEWS.md)
- [Notifications](./NOTIFICATIONS.md)
- [Moderation](./MODERATION.md)
- [Users](./USERS.md)

---

_For detailed API documentation, see [API Reference](../api/API_REFERENCE.md)_
