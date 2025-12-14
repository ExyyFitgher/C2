# Exy Attack Command Center

## Overview

This is a web-based command and control (C2) interface prototype designed for red team operations visualization. The application provides a cyberpunk-themed dashboard for managing simulated targets, building payloads, monitoring processes, and various other security research demonstration features.

**Important**: This is a frontend-focused prototype. The "backend" features like network scanning and target connections are simulated in the React code for demonstration purposes. To make it functional, real backend implementations would need to replace the simulation logic.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Frontend Architecture
- **Framework**: React with TypeScript
- **Routing**: Wouter (lightweight React router)
- **State Management**: TanStack React Query for server state, React useState for local state
- **Styling**: Tailwind CSS v4 with custom cyberpunk theme (neon green on black)
- **UI Components**: Radix UI primitives with shadcn/ui component library
- **Animations**: Framer Motion for transitions and effects
- **Build Tool**: Vite

### Backend Architecture
- **Runtime**: Node.js with Express
- **Language**: TypeScript compiled with tsx
- **API Pattern**: RESTful JSON endpoints under `/api/*`
- **Database ORM**: Drizzle ORM with PostgreSQL dialect
- **Schema Validation**: Zod with drizzle-zod integration

### Data Storage
- **Database**: PostgreSQL (configured via DATABASE_URL environment variable)
- **Schema Location**: `shared/schema.ts`
- **Tables**: users, serverConfig, targets, logs
- **Migrations**: Managed via drizzle-kit (`npm run db:push`)

### Application Structure
```
client/           # Frontend React application
├── src/
│   ├── pages/    # Route components (dashboard, targets, builder, etc.)
│   ├── components/  # Reusable UI components
│   ├── hooks/    # Custom React hooks
│   └── lib/      # Utilities and query client
server/           # Backend Express server
├── index.ts      # Server entry point
├── routes.ts     # API route definitions
├── storage.ts    # Database access layer
└── db.ts         # Drizzle database connection
shared/           # Shared code between client and server
└── schema.ts     # Database schema and Zod validators
```

### Key Design Patterns
- **Monorepo Structure**: Client and server in same repository with shared types
- **Storage Interface**: `IStorage` interface abstracts database operations for testability
- **Path Aliases**: `@/` maps to client/src, `@shared/` maps to shared/
- **Development Mode**: Vite dev server with HMR proxied through Express
- **Production Build**: Vite builds static assets, esbuild bundles server

## External Dependencies

### Database
- PostgreSQL database required (connection via DATABASE_URL environment variable)
- Drizzle ORM handles all database operations

### Frontend Libraries
- Radix UI for accessible component primitives
- TanStack React Query for data fetching and caching
- Framer Motion for animations
- Various shadcn/ui components

### Build & Development
- Vite for frontend bundling and dev server
- esbuild for production server bundling
- tsx for TypeScript execution in development

### Fonts
- JetBrains Mono (monospace, primary)
- Rajdhani (display font for headers)
- Loaded from Google Fonts CDN