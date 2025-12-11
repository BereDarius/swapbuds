# 🧩 UI Components Guide

> **Component Library and Usage Guidelines**

SWAPBUDS uses [shadcn/ui](https://ui.shadcn.com/) as its component foundation, built on top of Radix UI primitives.

---

## Component Library

### Available Components

All components are located in `src/components/ui/`:

**Forms & Inputs**

- `button` - Button component with variants
- `input` - Text input field
- `textarea` - Multi-line text input
- `select` - Dropdown select
- `checkbox` - Checkbox input
- `radio-group` - Radio button group
- `switch` - Toggle switch
- `label` - Form label
- `form` - Form wrapper with validation

**Layout**

- `card` - Content container
- `separator` - Visual divider
- `sheet` - Sliding panel
- `dialog` - Modal dialog
- `popover` - Popup content
- `dropdown-menu` - Contextual menu
- `tabs` - Tab navigation
- `accordion` - Collapsible content

**Feedback**

- `toast` - Notification toast
- `alert` - Alert message
- `badge` - Status badge
- `skeleton` - Loading placeholder
- `progress` - Progress bar
- `spinner` - Loading spinner

**Navigation**

- `navigation-menu` - Main navigation
- `breadcrumb` - Page hierarchy
- `pagination` - Page navigation
- `command` - Command palette

**Data Display**

- `table` - Data table
- `avatar` - User avatar
- `tooltip` - Hover tooltip

---

## Usage Examples

### Button

```tsx
import { Button } from '@/components/ui/button'

// Primary button
<Button>Click me</Button>

// Variants
<Button variant="secondary">Secondary</Button>
<Button variant="destructive">Delete</Button>
<Button variant="outline">Outline</Button>
<Button variant="ghost">Ghost</Button>
<Button variant="link">Link</Button>

// Sizes
<Button size="sm">Small</Button>
<Button size="default">Default</Button>
<Button size="lg">Large</Button>

// With icon
<Button>
  <PlusIcon className="mr-2 h-4 w-4" />
  Add Item
</Button>
```

### Form with Validation

```tsx
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import {
  Form,
  FormField,
  FormItem,
  FormLabel,
  FormControl,
  FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
});

function LoginForm() {
  const form = useForm({
    resolver: zodResolver(schema),
  });

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)}>
        <FormField
          control={form.control}
          name="email"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Email</FormLabel>
              <FormControl>
                <Input type="email" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <Button type="submit">Login</Button>
      </form>
    </Form>
  );
}
```

### Dialog

```tsx
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";

function DeleteDialog() {
  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button variant="destructive">Delete Item</Button>
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Are you sure?</DialogTitle>
        </DialogHeader>
        <p>This action cannot be undone.</p>
        <div className="flex gap-2">
          <Button variant="outline">Cancel</Button>
          <Button variant="destructive">Delete</Button>
        </div>
      </DialogContent>
    </Dialog>
  );
}
```

### Toast Notifications

```tsx
import { toast } from "sonner";

// Success
toast.success("Item created successfully");

// Error
toast.error("Failed to create item");

// Loading
const loadingToast = toast.loading("Creating item...");
// Later:
toast.success("Item created", { id: loadingToast });

// With action
toast("Item saved", {
  action: {
    label: "View",
    onClick: () => router.push("/items/123"),
  },
});
```

### Card Layout

```tsx
import {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
  CardFooter,
} from "@/components/ui/card";

function ItemCard({ item }) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>{item.title}</CardTitle>
        <CardDescription>{item.category}</CardDescription>
      </CardHeader>
      <CardContent>
        <img src={item.image} alt={item.title} />
        <p>{item.description}</p>
      </CardContent>
      <CardFooter>
        <Button>View Details</Button>
      </CardFooter>
    </Card>
  );
}
```

---

## Custom Components

### Layout Components

**Navbar** (`components/layout/navbar.tsx`)

```tsx
import { Navbar } from "@/components/layout/navbar";

// In layout
<Navbar />;
```

**Footer** (`components/layout/footer.tsx`)

```tsx
import { Footer } from "@/components/layout/footer";

// In layout
<Footer />;
```

### Feature Components

**OptimizedImage** (`components/optimized-image.tsx`)

```tsx
import { OptimizedImage } from "@/components/optimized-image";

<OptimizedImage
  src="/images/item.jpg"
  alt="Item"
  width={400}
  height={300}
  priority={false}
/>;
```

---

## Styling Guidelines

### Tailwind Classes

Use Tailwind utility classes for styling:

```tsx
// Good
<div className="flex items-center gap-4 p-4 rounded-lg bg-background">

// Avoid inline styles
<div style={{ display: 'flex', padding: '16px' }}>
```

### Component Variants

Use `class-variance-authority` (CVA) for variants:

```tsx
import { cva } from "class-variance-authority";

const buttonVariants = cva(
  "inline-flex items-center justify-center rounded-md",
  {
    variants: {
      variant: {
        primary: "bg-primary text-white",
        secondary: "bg-secondary text-black",
      },
      size: {
        sm: "px-2 py-1 text-sm",
        lg: "px-4 py-2 text-lg",
      },
    },
  },
);
```

### Responsive Design

```tsx
// Mobile-first approach
<div className="flex flex-col md:flex-row lg:gap-8">
  {/* Stacks on mobile, rows on desktop */}
</div>
```

---

## Accessibility

All components follow WCAG 2.1 AA standards:

✅ Keyboard navigation
✅ Screen reader support
✅ Focus indicators
✅ ARIA labels
✅ Color contrast

### Best Practices

```tsx
// Always provide labels
<Label htmlFor="email">Email</Label>
<Input id="email" type="email" />

// Use semantic HTML
<button> instead of <div onClick>

// Provide alt text
<img src="..." alt="Descriptive text" />

// Use ARIA when needed
<button aria-label="Close modal">
  <XIcon />
</button>
```

---

## Theme Customization

### CSS Variables

Customize theme in `src/app/globals.css`:

```css
:root {
  --background: 0 0% 100%;
  --foreground: 222.2 84% 4.9%;
  --primary: 221.2 83.2% 53.3%;
  --primary-foreground: 210 40% 98%;
  /* ... */
}
```

### Dark Mode

Toggle dark mode:

```tsx
import { useTheme } from "next-themes";

function ThemeToggle() {
  const { theme, setTheme } = useTheme();

  return (
    <Button onClick={() => setTheme(theme === "dark" ? "light" : "dark")}>
      Toggle Theme
    </Button>
  );
}
```

---

## Adding New Components

### From shadcn/ui

```bash
# Add a new component
npx shadcn-ui@latest add [component-name]

# Example
npx shadcn-ui@latest add calendar
```

### Custom Components

1. Create in appropriate directory
2. Export from index file
3. Document usage
4. Add TypeScript types
5. Write tests

---

## Testing Components

```tsx
import { render, screen } from "@testing-library/react";
import { Button } from "@/components/ui/button";

describe("Button", () => {
  it("renders with text", () => {
    render(<Button>Click me</Button>);
    expect(screen.getByText("Click me")).toBeInTheDocument();
  });

  it("handles click", () => {
    const onClick = vi.fn();
    render(<Button onClick={onClick}>Click me</Button>);
    screen.getByText("Click me").click();
    expect(onClick).toHaveBeenCalled();
  });
});
```

---

## Resources

- [shadcn/ui Documentation](https://ui.shadcn.com/)
- [Radix UI Primitives](https://www.radix-ui.com/)
- [TailwindCSS](https://tailwindcss.com/)
- [Frontend Architecture](./ARCHITECTURE.md)

---

_For more examples, see component files in `src/components/`_
