# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Full-stack blog system with admin panel. Spring Boot 3.2 backend + Vue 3 frontend + MySQL storage.

## Commands

### Backend (blog-backend/)

```bash
cd blog-backend

# Run dev server (requires MySQL on localhost:3306, database: blog)
mvn spring-boot:run

# Build jar
mvn clean package -DskipTests

# Run tests
mvn test

# Run single test class
mvn test -Dtest=ArticleServiceTest
```

### Frontend (blog-frontend/)

```bash
cd blog-frontend

# Install dependencies
npm install

# Dev server (http://localhost:5173, proxies /api to :8080)
npm run dev

# Production build (outputs to dist/)
npm run build
```

### Full deploy

```bash
./deploy.sh                    # Build & deploy everything
./deploy.sh -d /usr/share/nginx/html   # Custom frontend dir
./deploy.sh --skip-build       # Redeploy without rebuilding
```

## Architecture

```
blog-backend/                  # Spring Boot 3.2 + JPA + Spring Security + JWT
  src/main/java/com/blog/
    config/                    # SecurityConfig, CorsConfig, JWT (JwtUtil, JwtAuthFilter)
    controller/                # REST API controllers
      ArticleController        # GET /api/articles (public)
      AdminArticleController   # /api/admin/articles (authenticated)
      CategoryController       # /api/categories + /api/admin/categories
      TagController            # /api/tags + /api/admin/tags
      AuthController           # POST /api/auth/login
    entity/                    # JPA entities: Article, Category, Tag, User
    repository/                # Spring Data JPA repositories
    service/                   # Business logic
    dto/                       # ArticleDTO, LoginRequest, LoginResponse
  src/main/resources/
    application.yml            # DB connection, JWT config
    schema.sql                 # Default admin user seed

blog-frontend/                 # Vue 3 + Vite + Vue Router + Axios
  src/
    api/index.js               # Axios instance with JWT interceptor
    router/index.js            # Routes with auth guard on /admin/*
    views/
      Home.vue                 # Public article list with pagination
      ArticleDetail.vue        # Article page with Markdown rendering
      Login.vue                # Admin login
      admin/
        Dashboard.vue          # Admin layout with sidebar
        ArticleList.vue        # Article CRUD list
        ArticleEdit.vue        # Markdown editor (md-editor-v3)
        CategoryList.vue       # Category management
        TagList.vue            # Tag management
    components/
      Navbar.vue, Pagination.vue
```

## API Design

- **Public** (no auth): `GET /api/articles`, `GET /api/articles/:id`, `GET /api/categories`, `GET /api/tags`
- **Auth**: `POST /api/auth/login` → returns JWT token
- **Admin** (Bearer token required): `/api/admin/articles` (CRUD), `/api/admin/categories` (CRUD), `/api/admin/tags` (CRUD)

## Database

MySQL `blog` database. JPA auto-creates tables (`ddl-auto: update`). Tables: `user`, `article`, `category`, `tag`, `article_tag`.

Default admin credentials: `admin` / `admin123`

## Key Patterns

- JWT auth: token in `Authorization: Bearer <token>` header, validated by `JwtAuthFilter`
- Frontend proxy: Vite proxies `/api` to `localhost:8080` in dev mode
- Article content stored as Markdown, rendered client-side with `markdown-it`
- Markdown editing uses `md-editor-v3` with live preview
