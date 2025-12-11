# Google reCAPTCHA v3 (Invisible) - Implementation Guide

**SwapBuds Bot Protection Strategy**

---

## Overview

Google reCAPTCHA v3 provides invisible bot protection by analyzing user behavior without requiring any user interaction (no checkboxes or challenges). It returns a score (0.0-1.0) indicating the likelihood that the user is human.

**Benefits:**

- ✅ No user interaction required (completely invisible)
- ✅ Protects against automated bot registration/spam
- ✅ Analyzes user behavior patterns
- ✅ Works seamlessly on mobile
- ✅ Free tier: 1 million assessments/month
- ✅ GDPR compliant with proper disclosure

**Use Cases for SwapBuds:**

- Registration form (prevent fake accounts)
- Login form (prevent credential stuffing)
- Contact form (prevent spam)
- Trade proposals (prevent automated spam trades)
- Reviews/comments (prevent spam reviews)

---

## How It Works

### Score-Based System

reCAPTCHA v3 returns a score for each request:

| Score Range | Interpretation    | Recommended Action                       |
| ----------- | ----------------- | ---------------------------------------- |
| 1.0 - 0.9   | Very likely human | Allow immediately                        |
| 0.8 - 0.7   | Likely human      | Allow (monitor)                          |
| 0.6 - 0.5   | Neutral           | Allow with caution                       |
| 0.4 - 0.3   | Suspicious        | Review/challenge                         |
| 0.2 - 0.0   | Very likely bot   | Block or require additional verification |

### Workflow

```
1. User visits page → reCAPTCHA script loads
2. User interacts with page → reCAPTCHA analyzes behavior
3. User submits form → Frontend requests token from reCAPTCHA
4. Token sent to backend → Backend verifies token with Google
5. Google returns score → Backend decides to allow/block
```

---

## Setup & Configuration

### Step 1: Register Site with Google

1. Go to [Google reCAPTCHA Admin](https://www.google.com/recaptcha/admin)
2. Click "+" to create new site
3. Fill in details:

   - **Label**: SwapBuds Production (or SwapBuds Dev)
   - **reCAPTCHA type**: Score based (v3)
   - **Domains**: Add your domains
     - For development: `localhost`
     - For production: `swapbuds.com`, `www.swapbuds.com`
   - **Accept Terms**: ✓

4. Get your keys:
   - **Site Key** (public): Used in frontend
   - **Secret Key**: Used in backend verification

### Step 2: Environment Variables

**Frontend (.env.local):**

```bash
NEXT_PUBLIC_RECAPTCHA_SITE_KEY=6Lc...your-site-key...
```

**Backend (.env):**

```bash
RECAPTCHA_SECRET_KEY=6Lc...your-secret-key...
RECAPTCHA_VERIFY_URL=https://www.google.com/recaptcha/api/siteverify
RECAPTCHA_MIN_SCORE=0.5  # Threshold for accepting requests
```

---

## Frontend Implementation (Next.js)

### Install Package

```bash
yarn add react-google-recaptcha-v3
# or
npm install react-google-recaptcha-v3
```

### Setup reCAPTCHA Provider

**File: `src/app/providers.tsx`**

```tsx
"use client";

import { GoogleReCaptchaProvider } from "react-google-recaptcha-v3";

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <GoogleReCaptchaProvider
      reCaptchaKey={process.env.NEXT_PUBLIC_RECAPTCHA_SITE_KEY!}
      scriptProps={{
        async: true,
        defer: true,
        appendTo: "head",
      }}
    >
      {children}
    </GoogleReCaptchaProvider>
  );
}
```

**File: `src/app/layout.tsx`**

```tsx
import { Providers } from "./providers";

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
```

### Custom Hook for reCAPTCHA

**File: `src/hooks/useRecaptcha.ts`**

```tsx
import { useGoogleReCaptcha } from "react-google-recaptcha-v3";
import { useCallback } from "react";

export function useRecaptcha() {
  const { executeRecaptcha } = useGoogleReCaptcha();

  const getToken = useCallback(
    async (action: string): Promise<string> => {
      if (!executeRecaptcha) {
        console.warn("reCAPTCHA not yet available");
        return "";
      }

      try {
        const token = await executeRecaptcha(action);
        return token;
      } catch (error) {
        console.error("reCAPTCHA error:", error);
        return "";
      }
    },
    [executeRecaptcha],
  );

  return { getToken };
}
```

### Update Registration Form

**File: `src/app/(auth)/register/page.tsx`**

```tsx
"use client";

import { useRecaptcha } from "@/hooks/useRecaptcha";
// ... other imports

export default function RegisterPage() {
  const { getToken } = useRecaptcha();
  // ... existing code

  async function onSubmit(data: RegisterFormValues) {
    setIsLoading(true);

    try {
      // Get reCAPTCHA token
      const recaptchaToken = await getToken("register");

      if (!recaptchaToken) {
        toast.error("Verification failed", {
          description: "Please try again or contact support.",
        });
        return;
      }

      // Send token with registration data
      const response = await api.post("/auth/register", {
        ...data,
        recaptchaToken, // Add token to request
      });

      const { user, accessToken } = response.data;
      setAuth(user, accessToken);

      toast.success("Account created!", {
        description: `Welcome to SwapBuds, ${user.username}!`,
      });

      router.push("/");
    } catch (error) {
      logger.apiError("POST", "/auth/register", error);

      const message = getErrorMessage(
        error,
        "Failed to create account. Please try again.",
      );
      toast.error("Registration failed", {
        description: message,
      });
    } finally {
      setIsLoading(false);
    }
  }

  // ... rest of component
}
```

### Update Login Form

**File: `src/app/(auth)/login/page.tsx`**

```tsx
"use client";

import { useRecaptcha } from "@/hooks/useRecaptcha";
// ... other imports

export default function LoginPage() {
  const { getToken } = useRecaptcha();
  // ... existing code

  async function onSubmit(data: LoginFormValues) {
    setIsLoading(true);

    try {
      // Get reCAPTCHA token
      const recaptchaToken = await getToken("login");

      if (!recaptchaToken) {
        toast.error("Verification failed", {
          description: "Please try again or contact support.",
        });
        return;
      }

      // Send token with login data
      const response = await api.post("/auth/login", {
        ...data,
        recaptchaToken,
      });

      const { user, accessToken } = response.data;
      setAuth(user, accessToken);

      toast.success("Welcome back!", {
        description: `Logged in as ${user.username}`,
      });

      router.push("/");
    } catch (error) {
      logger.apiError("POST", "/auth/login", error);

      const message = getErrorMessage(
        error,
        "Invalid credentials. Please try again.",
      );
      toast.error("Login failed", {
        description: message,
      });
    } finally {
      setIsLoading(false);
    }
  }

  // ... rest of component
}
```

---

## Backend Implementation (NestJS)

### Install Package

```bash
yarn add axios
# or
npm install axios
```

### Create reCAPTCHA Service

**File: `src/recaptcha/recaptcha.service.ts`**

```typescript
import { Injectable, Logger } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import axios from "axios";

export interface RecaptchaVerifyResponse {
  success: boolean;
  score: number;
  action: string;
  challenge_ts: string;
  hostname: string;
  "error-codes"?: string[];
}

@Injectable()
export class RecaptchaService {
  private readonly logger = new Logger(RecaptchaService.name);
  private readonly secretKey: string;
  private readonly verifyUrl: string;
  private readonly minScore: number;

  constructor(private configService: ConfigService) {
    this.secretKey = this.configService.get<string>("RECAPTCHA_SECRET_KEY")!;
    this.verifyUrl = this.configService.get<string>(
      "RECAPTCHA_VERIFY_URL",
      "https://www.google.com/recaptcha/api/siteverify",
    );
    this.minScore = parseFloat(
      this.configService.get<string>("RECAPTCHA_MIN_SCORE", "0.5"),
    );
  }

  async verifyToken(
    token: string,
    expectedAction: string,
    remoteIp?: string,
  ): Promise<{ success: boolean; score: number; reason?: string }> {
    try {
      // Verify token with Google
      const response = await axios.post<RecaptchaVerifyResponse>(
        this.verifyUrl,
        null,
        {
          params: {
            secret: this.secretKey,
            response: token,
            remoteip: remoteIp,
          },
        },
      );

      const data = response.data;

      // Check if verification was successful
      if (!data.success) {
        this.logger.warn(
          `reCAPTCHA verification failed: ${data["error-codes"]?.join(", ")}`,
        );
        return {
          success: false,
          score: 0,
          reason: "Verification failed",
        };
      }

      // Check if action matches
      if (data.action !== expectedAction) {
        this.logger.warn(
          `reCAPTCHA action mismatch: expected ${expectedAction}, got ${data.action}`,
        );
        return {
          success: false,
          score: data.score,
          reason: "Action mismatch",
        };
      }

      // Check if score meets minimum threshold
      if (data.score < this.minScore) {
        this.logger.warn(
          `reCAPTCHA score too low: ${data.score} (min: ${this.minScore})`,
        );
        return {
          success: false,
          score: data.score,
          reason: "Score too low",
        };
      }

      this.logger.log(
        `reCAPTCHA verified successfully: action=${data.action}, score=${data.score}`,
      );

      return {
        success: true,
        score: data.score,
      };
    } catch (error) {
      this.logger.error("reCAPTCHA verification error:", error);
      return {
        success: false,
        score: 0,
        reason: "Verification error",
      };
    }
  }
}
```

### Create reCAPTCHA Module

**File: `src/recaptcha/recaptcha.module.ts`**

```typescript
import { Module } from "@nestjs/common";
import { RecaptchaService } from "./recaptcha.service";

@Module({
  providers: [RecaptchaService],
  exports: [RecaptchaService],
})
export class RecaptchaModule {}
```

### Update Auth DTOs

**File: `src/auth/dto/auth.dto.ts`**

```typescript
import { ApiProperty } from "@nestjs/swagger";
import {
  IsEmail,
  IsOptional,
  IsString,
  Matches,
  MaxLength,
  MinLength,
} from "class-validator";

export class RegisterDto {
  @ApiProperty({ example: "johndoe" })
  @IsString()
  @MinLength(3)
  @MaxLength(30)
  @Matches(/^[a-zA-Z0-9_-]+$/, {
    message:
      "Username can only contain letters, numbers, underscores, and hyphens",
  })
  username: string;

  @ApiProperty({ example: "john@example.com" })
  @IsEmail()
  email: string;

  @ApiProperty({ example: "StrongP@ssw0rd!" })
  @IsString()
  @MinLength(8)
  @MaxLength(128)
  @Matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/, {
    message:
      "Password must contain at least one uppercase letter, one lowercase letter, and one number",
  })
  password: string;

  @ApiProperty({
    example: "recaptcha_token_here",
    description: "Google reCAPTCHA v3 token",
    required: false,
  })
  @IsString()
  @IsOptional()
  recaptchaToken?: string;
}

export class LoginDto {
  @ApiProperty({ example: "john@example.com" })
  @IsEmail()
  email: string;

  @ApiProperty({ example: "StrongP@ssw0rd!" })
  @IsString()
  password: string;

  @ApiProperty({
    example: "recaptcha_token_here",
    description: "Google reCAPTCHA v3 token",
    required: false,
  })
  @IsString()
  @IsOptional()
  recaptchaToken?: string;
}

// ... rest of DTOs
```

### Update Auth Module

**File: `src/auth/auth.module.ts`**

```typescript
import { Module } from "@nestjs/common";
import { JwtModule } from "@nestjs/jwt";
import { PassportModule } from "@nestjs/passport";
import { ConfigModule, ConfigService } from "@nestjs/config";
import { AuthController } from "./auth.controller";
import { AuthService } from "./auth.service";
import { JwtStrategy } from "./jwt.strategy";
import { PrismaModule } from "../prisma/prisma.module";
import { RecaptchaModule } from "../recaptcha/recaptcha.module"; // Add this

@Module({
  imports: [
    PrismaModule,
    PassportModule,
    RecaptchaModule, // Add this
    JwtModule.registerAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => ({
        secret: configService.get<string>("JWT_SECRET"),
        signOptions: {
          expiresIn: configService.get<string>("JWT_EXPIRATION", "7d"),
        },
      }),
      inject: [ConfigService],
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy],
  exports: [AuthService],
})
export class AuthModule {}
```

### Update Auth Service

**File: `src/auth/auth.service.ts`**

```typescript
import {
  Injectable,
  Logger,
  ConflictException,
  UnauthorizedException,
  BadRequestException,
} from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
import { ConfigService } from "@nestjs/config";
import * as bcrypt from "bcrypt";
import { PrismaService } from "../prisma/prisma.service";
import { RecaptchaService } from "../recaptcha/recaptcha.service";
import { RegisterDto, LoginDto, AuthResponseDto } from "./dto/auth.dto";

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);
  private readonly SALT_ROUNDS = 10;

  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private configService: ConfigService,
    private recaptchaService: RecaptchaService, // Add this
  ) {}

  async register(
    registerDto: RegisterDto,
    ip?: string,
  ): Promise<AuthResponseDto> {
    const { username, email, password, recaptchaToken } = registerDto;

    // Verify reCAPTCHA token (if provided)
    if (recaptchaToken) {
      const verification = await this.recaptchaService.verifyToken(
        recaptchaToken,
        "register",
        ip,
      );

      if (!verification.success) {
        this.logger.warn(
          `Registration blocked: reCAPTCHA failed (score: ${verification.score}, reason: ${verification.reason})`,
        );
        throw new BadRequestException(
          "Bot detection failed. Please try again or contact support.",
        );
      }

      this.logger.log(
        `Registration reCAPTCHA verified: score=${verification.score}`,
      );
    }

    // Check if user exists
    const existingUser = await this.prisma.user.findFirst({
      where: {
        OR: [{ email }, { username }],
      },
    });

    if (existingUser) {
      if (existingUser.email === email) {
        throw new ConflictException("Email already registered");
      }
      throw new ConflictException("Username already taken");
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, this.SALT_ROUNDS);

    // Create user
    const user = await this.prisma.user.create({
      data: {
        username,
        email,
        password: hashedPassword,
      },
      select: {
        id: true,
        email: true,
        username: true,
        avatarUrl: true,
      },
    });

    this.logger.log(`New user registered: ${user.username} (${user.email})`);

    // Generate JWT
    const accessToken = await this.generateToken(user);

    return {
      accessToken,
      user,
    };
  }

  async login(loginDto: LoginDto, ip?: string): Promise<AuthResponseDto> {
    const { email, password, recaptchaToken } = loginDto;

    // Verify reCAPTCHA token (if provided)
    if (recaptchaToken) {
      const verification = await this.recaptchaService.verifyToken(
        recaptchaToken,
        "login",
        ip,
      );

      if (!verification.success) {
        this.logger.warn(
          `Login blocked: reCAPTCHA failed (score: ${verification.score}, reason: ${verification.reason})`,
        );
        throw new BadRequestException(
          "Bot detection failed. Please try again or contact support.",
        );
      }

      this.logger.log(`Login reCAPTCHA verified: score=${verification.score}`);
    }

    // Find user
    const user = await this.prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      throw new UnauthorizedException("Invalid credentials");
    }

    // Verify password
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      throw new UnauthorizedException("Invalid credentials");
    }

    this.logger.log(`User logged in: ${user.username} (${user.email})`);

    // Generate JWT
    const accessToken = await this.generateToken(user);

    return {
      accessToken,
      user: {
        id: user.id,
        email: user.email,
        username: user.username,
        avatarUrl: user.avatarUrl,
      },
    };
  }

  private async generateToken(user: {
    id: string;
    email: string;
    username: string;
  }): Promise<string> {
    const payload = {
      sub: user.id,
      email: user.email,
      username: user.username,
    };

    return this.jwtService.sign(payload);
  }

  // ... rest of methods
}
```

### Update Auth Controller

**File: `src/auth/auth.controller.ts`**

```typescript
import { Controller, Post, Body, Get, UseGuards, Req } from "@nestjs/common";
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from "@nestjs/swagger";
import { Request } from "express";
import { AuthService } from "./auth.service";
import { RegisterDto, LoginDto, AuthResponseDto } from "./dto/auth.dto";
import { JwtAuthGuard } from "./jwt-auth.guard";
import { Public } from "./public.decorator";

@ApiTags("auth")
@Controller("auth")
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Public()
  @Post("register")
  @ApiOperation({ summary: "Register a new user" })
  @ApiResponse({
    status: 201,
    description: "User successfully registered",
    type: AuthResponseDto,
  })
  @ApiResponse({ status: 400, description: "Invalid input or bot detected" })
  @ApiResponse({ status: 409, description: "Email or username already exists" })
  async register(
    @Body() registerDto: RegisterDto,
    @Req() request: Request,
  ): Promise<AuthResponseDto> {
    const ip = request.ip || request.socket.remoteAddress;
    return this.authService.register(registerDto, ip);
  }

  @Public()
  @Post("login")
  @ApiOperation({ summary: "Login user" })
  @ApiResponse({
    status: 200,
    description: "User successfully logged in",
    type: AuthResponseDto,
  })
  @ApiResponse({ status: 400, description: "Bot detected" })
  @ApiResponse({ status: 401, description: "Invalid credentials" })
  async login(
    @Body() loginDto: LoginDto,
    @Req() request: Request,
  ): Promise<AuthResponseDto> {
    const ip = request.ip || request.socket.remoteAddress;
    return this.authService.login(loginDto, ip);
  }

  // ... rest of methods
}
```

---

## Testing

### Frontend Testing

**Test in browser console:**

```javascript
// Check if reCAPTCHA is loaded
console.log(window.grecaptcha);

// Get token manually (replace 'register' with your action)
grecaptcha.enterprise
  .execute("YOUR_SITE_KEY", { action: "register" })
  .then((token) => console.log("Token:", token));
```

### Backend Testing with cURL

```bash
# Test registration with reCAPTCHA token
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "TestPass123!",
    "recaptchaToken": "your_token_here"
  }'
```

### Unit Tests

**File: `src/recaptcha/recaptcha.service.spec.ts`**

```typescript
import { Test, TestingModule } from "@nestjs/testing";
import { ConfigService } from "@nestjs/config";
import { RecaptchaService } from "./recaptcha.service";
import axios from "axios";

jest.mock("axios");
const mockedAxios = axios as jest.Mocked<typeof axios>;

describe("RecaptchaService", () => {
  let service: RecaptchaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        RecaptchaService,
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn((key: string, defaultValue?: string) => {
              const config = {
                RECAPTCHA_SECRET_KEY: "test-secret-key",
                RECAPTCHA_VERIFY_URL:
                  "https://www.google.com/recaptcha/api/siteverify",
                RECAPTCHA_MIN_SCORE: "0.5",
              };
              return config[key] || defaultValue;
            }),
          },
        },
      ],
    }).compile();

    service = module.get<RecaptchaService>(RecaptchaService);
  });

  it("should verify token successfully with good score", async () => {
    mockedAxios.post.mockResolvedValue({
      data: {
        success: true,
        score: 0.9,
        action: "register",
        challenge_ts: "2024-01-01T00:00:00Z",
        hostname: "localhost",
      },
    });

    const result = await service.verifyToken("valid-token", "register");

    expect(result.success).toBe(true);
    expect(result.score).toBe(0.9);
  });

  it("should fail verification with low score", async () => {
    mockedAxios.post.mockResolvedValue({
      data: {
        success: true,
        score: 0.3,
        action: "register",
        challenge_ts: "2024-01-01T00:00:00Z",
        hostname: "localhost",
      },
    });

    const result = await service.verifyToken("low-score-token", "register");

    expect(result.success).toBe(false);
    expect(result.reason).toBe("Score too low");
  });

  it("should fail verification with action mismatch", async () => {
    mockedAxios.post.mockResolvedValue({
      data: {
        success: true,
        score: 0.9,
        action: "login",
        challenge_ts: "2024-01-01T00:00:00Z",
        hostname: "localhost",
      },
    });

    const result = await service.verifyToken("token", "register");

    expect(result.success).toBe(false);
    expect(result.reason).toBe("Action mismatch");
  });
});
```

---

## Score Thresholds & Strategy

### Recommended Thresholds by Action

```typescript
const RECAPTCHA_THRESHOLDS = {
  // Critical actions - strict
  register: 0.7, // New account creation
  login: 0.5, // Existing user login (more lenient)
  passwordReset: 0.6, // Password reset request

  // Moderate actions
  createItem: 0.5, // Create new item listing
  sendMessage: 0.5, // Send chat message
  createTrade: 0.6, // Propose trade

  // Low-risk actions
  search: 0.3, // Search items
  viewProfile: 0.2, // View user profile

  // Sensitive actions - very strict
  deleteAccount: 0.8, // Delete user account
  reportUser: 0.7, // Report abuse
  fileDispute: 0.7, // File dispute
};
```

### Score-Based Response Strategy

**Score 0.9 - 1.0 (Very Likely Human):**

- Allow immediately
- No additional checks
- Normal user experience

**Score 0.7 - 0.8 (Likely Human):**

- Allow immediately
- Log for monitoring
- Analyze patterns over time

**Score 0.5 - 0.6 (Neutral):**

- Allow but add restrictions:
  - Rate limiting (stricter)
  - Email verification required
  - Account review after 24 hours
- Monitor closely

**Score 0.3 - 0.4 (Suspicious):**

- Block or challenge:
  - Require email verification
  - Require phone verification
  - Manual review by admin
- Log IP for analysis

**Score 0.0 - 0.2 (Very Likely Bot):**

- Block immediately
- Log IP for blacklist
- Return generic error (don't reveal detection)
- Consider CAPTCHA challenge (v2 fallback)

---

## Privacy & GDPR Compliance

### Cookie Policy Disclosure

Add to your Privacy Policy / Cookie Policy:

```markdown
### Bot Protection (reCAPTCHA)

We use Google reCAPTCHA v3 to protect our platform from automated abuse and spam.
reCAPTCHA analyzes your interactions with our website to determine if you're a human user.

**Data Collected by reCAPTCHA:**

- IP address
- Browser information
- Mouse movements and clicks
- Time spent on pages
- Other behavioral signals

**Purpose:**

- Prevent fake account creation
- Protect against automated spam
- Ensure platform security

**Google's Privacy Policy:**
https://policies.google.com/privacy

**reCAPTCHA Terms of Service:**
https://policies.google.com/terms

By using SwapBuds, you agree to Google's processing of data as described in their
Privacy Policy and Terms of Service.
```

### Cookie Consent Banner

Update your cookie consent to include:

```tsx
const cookieCategories = {
  essential: {
    name: "Essential Cookies",
    description: "Required for basic site functionality",
    required: true,
    cookies: ["session", "csrf_token"],
  },
  functional: {
    name: "Functional Cookies",
    description: "Remember your preferences",
    required: false,
    cookies: ["language", "theme"],
  },
  analytics: {
    name: "Analytics Cookies",
    description: "Help us understand how you use the site",
    required: false,
    cookies: ["_ga", "_gid"],
  },
  security: {
    // Add this
    name: "Security & Anti-Spam",
    description: "Protect against bots and automated abuse (reCAPTCHA)",
    required: false, // Can be optional if you want to respect user choice
    cookies: ["_GRECAPTCHA"],
  },
};
```

---

## Monitoring & Analytics

### Track reCAPTCHA Scores

**File: `src/recaptcha/recaptcha.service.ts`** (add logging)

```typescript
async verifyToken(
  token: string,
  expectedAction: string,
  remoteIp?: string,
): Promise<{ success: boolean; score: number; reason?: string }> {
  // ... existing code

  // Log score distribution for analysis
  await this.logScore({
    action: expectedAction,
    score: data.score,
    ip: remoteIp,
    success: data.score >= this.minScore,
    timestamp: new Date(),
  });

  // ... rest of code
}

private async logScore(data: {
  action: string;
  score: number;
  ip?: string;
  success: boolean;
  timestamp: Date;
}) {
  // Option 1: Log to database
  await this.prisma.recaptchaLog.create({
    data: {
      action: data.action,
      score: data.score,
      ip: data.ip,
      success: data.success,
      timestamp: data.timestamp,
    },
  });

  // Option 2: Send to analytics (Sentry, DataDog, etc.)
  // Sentry.captureMessage('reCAPTCHA Score', {
  //   level: 'info',
  //   extra: data,
  // });
}
```

### Prisma Schema for Logging

**File: `prisma/schema.prisma`**

```prisma
model RecaptchaLog {
  id        String   @id @default(cuid())
  action    String
  score     Float
  ip        String?
  success   Boolean
  timestamp DateTime @default(now())

  @@index([action])
  @@index([score])
  @@index([timestamp])
}
```

### Admin Dashboard Metrics

Track in admin panel:

- Average score by action
- Score distribution histogram
- Blocked requests per day
- Top IPs with low scores
- Actions most targeted by bots

---

## Fallback Strategy

### What if reCAPTCHA is Blocked?

Some users may have reCAPTCHA blocked (VPN, ad blockers, privacy tools):

**Option 1: Make it Optional (Recommended)**

```typescript
// Backend: Allow registration even without token
if (recaptchaToken) {
  const verification = await this.recaptchaService.verifyToken(
    recaptchaToken,
    "register",
    ip,
  );

  if (!verification.success) {
    // Don't block, just flag for review
    await this.flagForReview(user.id, verification.score);
  }
} else {
  // No token provided - still allow but with stricter rate limiting
  this.logger.warn("Registration without reCAPTCHA token");
}
```

**Option 2: Fallback to reCAPTCHA v2**

If v3 fails, show v2 checkbox challenge:

```tsx
import ReCAPTCHA from "react-google-recaptcha";

const [showV2Captcha, setShowV2Captcha] = useState(false);

// If v3 token fails or is unavailable
if (!recaptchaToken) {
  setShowV2Captcha(true);
}

{
  showV2Captcha && (
    <ReCAPTCHA
      sitekey={process.env.NEXT_PUBLIC_RECAPTCHA_V2_SITE_KEY!}
      onChange={(token) => {
        // Use v2 token instead
        onSubmit({ ...data, recaptchaToken: token });
      }}
    />
  );
}
```

---

## Cost & Limits

### Free Tier

- **1 million assessments/month**: Free
- Perfect for startups and small platforms

### Pricing (if exceeding 1M)

- **$1 per 1,000 assessments** after first million
- Estimated costs for SwapBuds:
  - 10K daily users = 300K/month = **FREE**
  - 50K daily users = 1.5M/month = **$500/month**
  - 100K daily users = 3M/month = **$2,000/month**

### Optimization Tips

1. **Don't verify every action** - only critical ones
2. **Cache tokens client-side** - reuse for 2 minutes
3. **Skip for authenticated users** - only verify on login/register
4. **Use selective verification** - based on user reputation

---

## Alternative Solutions

If reCAPTCHA doesn't fit your needs:

### 1. Cloudflare Turnstile (Free, privacy-focused)

- Similar to reCAPTCHA v3
- More privacy-friendly
- No data sent to Google
- Free unlimited assessments
- https://www.cloudflare.com/products/turnstile/

### 2. hCaptcha (Ethical, pays sites)

- GDPR compliant
- Pays sites per CAPTCHA solved
- Privacy-focused
- Free tier available
- https://www.hcaptcha.com/

### 3. Custom Bot Detection

- Honeypot fields (hidden inputs bots fill)
- Time-based checks (bots submit too fast)
- Mouse movement tracking
- Browser fingerprinting
- Rate limiting by IP

---

## Recommended Implementation Timeline

### Week 1-2 (Legal Compliance)

- [ ] Add reCAPTCHA disclosure to Privacy Policy
- [ ] Update Cookie Policy
- [ ] Update cookie consent banner
- [ ] Get user consent for security cookies

### Week 3 (Backend Setup)

- [ ] Register site with Google reCAPTCHA
- [ ] Create RecaptchaService and module
- [ ] Update AuthService to verify tokens
- [ ] Add environment variables
- [ ] Write unit tests

### Week 4 (Frontend Setup)

- [ ] Install react-google-recaptcha-v3
- [ ] Add GoogleReCaptchaProvider
- [ ] Create useRecaptcha hook
- [ ] Update register form
- [ ] Update login form

### Week 5 (Testing & Monitoring)

- [ ] Test with various score thresholds
- [ ] Add logging and analytics
- [ ] Create admin dashboard for scores
- [ ] Test with VPNs and ad blockers
- [ ] Implement fallback strategy

### Week 6 (Optimization)

- [ ] Analyze score distribution
- [ ] Adjust thresholds
- [ ] Add selective verification
- [ ] Optimize for performance
- [ ] Document for team

---

## Summary

✅ **Pros of reCAPTCHA v3:**

- Completely invisible to users
- Highly effective against bots
- Free up to 1M/month
- Easy to implement
- Industry standard

⚠️ **Cons:**

- Relies on Google (privacy concerns)
- May be blocked by privacy tools
- Not 100% accurate (false positives)
- Requires Google account
- Score-based (requires tuning)

**Recommendation for SwapBuds:**

Implement reCAPTCHA v3 for **registration and login** with:

- Minimum score: **0.5** (start conservative)
- Make it **optional** initially (don't block if missing)
- Add **logging** to track scores
- Implement **fallback** for blocked users
- Comply with **GDPR** (disclosure + consent)

Start with a lenient threshold (0.5) and adjust based on real-world data. Monitor score distribution for 2-4 weeks before making strict.
