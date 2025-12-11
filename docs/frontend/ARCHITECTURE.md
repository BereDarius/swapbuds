# 🎨 Frontend Architecture

> **Next.js 14 Application Structure and Patterns**

This document describes the frontend architecture, patterns, and best practices for the SWAPBUDS platform.

---

## Tech Stack

### Core

- **Next.js 14** - React framework with App Router
- **TypeScript 5** - Type safety
- **React 18** - UI library

### UI & Styling

- **shadcn/ui** - Component library
- **TailwindCSS 3.4** - Utility-first CSS
- **Radix UI** - Accessible primitives
- **Lucide React** - Icon library

### State Management

- **Zustand** - Lightweight state management
- **TanStack Query** - Server state management
- **React Hook Form** - Form state

### Data & API

- **Axios** - HTTP client with interceptors
- **Zod** - Schema validation
- **TanStack Query** - Data fetching and caching

### Monitoring & Errors

- **Sentry** - Error tracking (production)
- **Custom Logger** - Development logging

---

## Project Structure

```
swapbuds-frontend/
├── src/
│   ├── app/                    # Next.js App Router
│   │   ├── (auth)/            # Auth layout group
│   │   ├── (main)/            # Main app layout group
│   │   ├── (legal)/           # Legal pages layout
│   │   ├── layout.tsx         # Root layout
│   │   └── page.tsx           # Homepage
│   │
│   ├── components/            # React components
│   │   ├── ui/               # shadcn/ui components
│   │   ├── layout/           # Layout components
│   │   ├── forms/            # Form components
│   │   └── ...
│   │
│   ├── lib/                   # Libraries and utilities
│   │   ├── api/              # API client functions
│   │   ├── hooks/            # Custom React hooks
│   │   ├── utils/            # Utility functions
│   │   └── validations/      # Zod schemas
│   │
│   ├── stores/               # Zustand stores
│   │   ├── auth-store.ts    # Authentication state
│   │   └── ...
│   │
│   └── types/                # TypeScript definitions
│
├── public/                    # Static assets
├── docs/                     # Frontend-specific docs
└── scripts/                  # Build/test scripts
```

---

## Routing Architecture

### App Router (Next.js 14)

We use Next.js 14 App Router with route groups for layout organization:

```
app/
├── (auth)/                   # Authentication pages
│   ├── layout.tsx           # Auth-specific layout
│   ├── login/page.tsx
│   ├── register/page.tsx
│   └── forgot-password/page.tsx
│
├── (main)/                   # Main application
│   ├── layout.tsx           # Main layout with navbar
│   ├── items/
│   │   ├── page.tsx         # Items list
│   │   ├── [id]/page.tsx    # Item detail
│   │   └── new/page.tsx     # Create item
│   ├── trades/
│   ├── profile/
│   └── messages/
│
└── (legal)/                  # Legal pages
    ├── layout.tsx           # Simple legal layout
    ├── privacy/page.tsx
    ├── terms/page.tsx
    └── cookies/page.tsx
```

### Route Groups Benefits

- **Shared Layouts**: Each group has its own layout
- **Clean URLs**: Parentheses don't appear in URLs
- **Code Organization**: Related pages grouped together

---

## Component Architecture

### Component Hierarchy

```
App Layout (Root)
├── Providers (Auth, Query, Theme)
├── Navbar
├── Page Content
│   ├── Feature Components
│   │   ├── UI Components (shadcn/ui)
│   │   └── Custom Components
│   └── Forms
└── Footer
```

### Component Categories

**1. UI Components** (`components/ui/`)

- shadcn/ui components
- Fully accessible (Radix UI)
- Themeable with CSS variables

**2. Layout Components** (`components/layout/`)

- `Navbar` - Main navigation
- `Footer` - Site footer
- `Sidebar` - Optional sidebar

**3. Feature Components** (`components/`)

- Domain-specific components
- Combine UI components
- Business logic integration

**4. Form Components** (`components/forms/`)

- React Hook Form integration
- Zod validation
- Reusable form fields

---

## State Management

### Zustand Stores

**Auth Store** (`stores/auth-store.ts`):

```typescript
interface AuthStore {
  user: User | null;
  token: string | null;
  login: (credentials) => Promise<void>;
  logout: () => void;
  isAuthenticated: boolean;
}
```

Features:

- Persisted to localStorage
- Automatic token refresh
- Hydration handling

### TanStack Query

Used for server state:

- API data fetching
- Caching and synchronization
- Background refetching
- Optimistic updates

Example:

```typescript
const { data, isLoading } = useQuery({
  queryKey: ["items", filters],
  queryFn: () => fetchItems(filters),
  staleTime: 5 * 60 * 1000, // 5 minutes
});
```

---

## Data Fetching

### API Client (`lib/api/`)

Axios instance with:

- Base URL configuration
- JWT token injection
- Error handling
- Request/response interceptors

```typescript
// lib/api/client.ts
const apiClient = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,
});

// Auto-inject auth token
apiClient.interceptors.request.use((config) => {
  const token = useAuthStore.getState().token;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});
```

### Query Hooks Pattern

Each API module exports custom hooks:

```typescript
// lib/api/items.ts
export function useItems(filters: ItemFilters) {
  return useQuery({
    queryKey: ["items", filters],
    queryFn: () => itemsApi.getAll(filters),
  });
}

export function useCreateItem() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: itemsApi.create,
    onSuccess: () => {
      queryClient.invalidateQueries(["items"]);
    },
  });
}
```

---

## Form Handling

### React Hook Form + Zod

```typescript
// 1. Define Zod schema
const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
});

type LoginForm = z.infer<typeof loginSchema>;

// 2. Create form
const form = useForm<LoginForm>({
  resolver: zodResolver(loginSchema),
});

// 3. Handle submission
const onSubmit = async (data: LoginForm) => {
  await login(data);
};
```

Benefits:

- Type-safe forms
- Client-side validation
- Server error handling
- Accessible error messages

---

## Styling Approach

### TailwindCSS Utilities

We use Tailwind for:

- Responsive design
- Consistent spacing
- Theme colors
- Component variants

### CSS Variables

Theme customization via CSS variables:

```css
:root {
  --background: 0 0% 100%;
  --foreground: 222.2 84% 4.9%;
  --primary: 221.2 83.2% 53.3%;
  /* ... */
}

.dark {
  --background: 222.2 84% 4.9%;
  --foreground: 210 40% 98%;
  /* ... */
}
```

---

## Performance Optimizations

### Code Splitting

- Route-based splitting (automatic)
- Dynamic imports for heavy components
- Lazy loading below-the-fold content

### Image Optimization

- Next.js `<Image>` component
- Automatic format optimization (WebP)
- Responsive images
- Lazy loading

### Caching Strategy

- Static pages: ISR (Incremental Static Regeneration)
- Dynamic pages: Client-side caching with React Query
- API responses: 5-minute stale time

### Bundle Optimization

- Tree shaking
- Minification
- Module concatenation
- Source map optimization (production)

See [Performance Documentation](./PERFORMANCE.md) for details.

---

## Error Handling

### Development

- Custom logger with timestamps
- Console error boundaries
- Detailed error messages

### Production

- Sentry error tracking
- Error boundaries
- User-friendly messages
- Automatic retries (React Query)

```typescript
// Error boundary
<ErrorBoundary fallback={<ErrorPage />}>
  <App />
</ErrorBoundary>
```

---

## Testing Strategy

See [Frontend Testing Guide](./TESTING.md) for comprehensive testing documentation.

### Test Types

- **Unit Tests**: Component logic
- **Integration Tests**: Component interactions
- **E2E Tests**: User flows (Playwright)
- **Visual Tests**: Component rendering

### Testing Tools

- **Vitest**: Unit/integration tests
- **Testing Library**: Component testing
- **Playwright**: E2E testing
- **MSW**: API mocking

---

## Security Measures

### XSS Prevention

- React's automatic escaping
- DOMPurify for user HTML
- Content Security Policy

### Authentication

- JWT tokens in memory
- Refresh token rotation
- Automatic logout on expiry

### CSRF Protection

- SameSite cookies
- Double submit cookies pattern

---

## Best Practices

### Component Design

✅ Single responsibility
✅ Composition over inheritance
✅ Props validation with TypeScript
✅ Accessible by default

### State Management

✅ Server state in React Query
✅ Client state in Zustand
✅ Local state in component
✅ Avoid prop drilling

### Performance

✅ Lazy load routes
✅ Optimize images
✅ Minimize bundle size
✅ Use React.memo strategically

### Code Quality

✅ TypeScript strict mode
✅ ESLint + Prettier
✅ Consistent naming conventions
✅ Comprehensive documentation

---

## Development Workflow

### Local Development

```bash
yarn dev              # Start dev server
yarn test            # Run tests
yarn lint            # Check code quality
yarn format          # Format code
```

### Building

```bash
yarn build           # Production build
yarn start           # Start production server
```

---

## Related Documentation

- [Performance Guide](./PERFORMANCE.md)
- [Testing Guide](./TESTING.md)
- [Component Library](./COMPONENTS.md)
- [API Integration](../api/API_REFERENCE.md)

---

_For questions or suggestions, please open an issue on GitHub_
