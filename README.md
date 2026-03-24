# Blog

A full-stack blog system with admin panel, built with Spring Boot and Vue 3.

![Java](https://img.shields.io/badge/Java-17-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2-green)
![Vue](https://img.shields.io/badge/Vue-3.4-blue)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![License](https://img.shields.io/badge/License-MIT-yellow)

## Features

- **Article Management** — Create, edit, publish, and delete articles with Markdown editor (live preview)
- **Category & Tag System** — Organize articles with categories and tags
- **Image Upload** — Upload images directly in the Markdown editor
- **JWT Authentication** — Secure admin panel with JSON Web Token
- **Responsive Design** — Clean, modern UI with smooth page transitions
- **One-Click Deploy** — Automated deployment scripts for Linux servers and macOS

## Tech Stack

| Layer    | Technology                                           |
|----------|------------------------------------------------------|
| Backend  | Spring Boot 3.2, Spring Data JPA, Spring Security    |
| Frontend | Vue 3, Vite 5, Vue Router, Axios                     |
| Database | MySQL 8.0 (JPA auto-schema)                          |
| Auth     | JWT (jjwt 0.12.5)                                    |
| Editor   | md-editor-v3 (editing), markdown-it (rendering)       |
| Deploy   | Nginx, systemd, Bash scripts                         |

## Quick Start

### Prerequisites

- Java 17+
- Maven 3.6+
- Node.js 18+
- MySQL 8.0+

### 1. Clone the repository

```bash
git clone https://github.com/fansiguo/blog.git
cd blog
```

### 2. Set up the database

```sql
CREATE DATABASE blog DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 3. Configure the backend

Edit `blog-backend/src/main/resources/application.yml` to match your MySQL credentials:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/blog?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Shanghai&characterEncoding=UTF-8
    username: root
    password: your_password
```

### 4. Start the backend

```bash
cd blog-backend
mvn spring-boot:run
```

The API will be available at `http://localhost:8080`.

### 5. Start the frontend

```bash
cd blog-frontend
npm install
npm run dev
```

Visit `http://localhost:5173` to see the blog. The dev server proxies `/api` requests to the backend automatically.

### Default Admin Login

- URL: `http://localhost:5173/login`
- Username: `admin`
- Password: `admin123`

## Project Structure

```
blog/
├── blog-backend/                  # Spring Boot backend
│   ├── pom.xml
│   └── src/main/java/com/blog/
│       ├── config/                # Security, CORS, JWT, WebMvc
│       ├── controller/            # REST API controllers
│       ├── entity/                # JPA entities
│       ├── repository/            # Spring Data repositories
│       ├── service/               # Business logic
│       └── dto/                   # Data transfer objects
├── blog-frontend/                 # Vue 3 frontend
│   ├── package.json
│   ├── vite.config.js
│   └── src/
│       ├── api/                   # Axios instance with JWT interceptor
│       ├── router/                # Vue Router with auth guard
│       ├── views/                 # Page components
│       └── components/            # Shared components
├── deploy.sh                      # Linux server deploy script
└── deploy-mac.sh                  # macOS local deploy script
```

## API Reference

### Public Endpoints (no auth required)

| Method | Endpoint              | Description             |
|--------|-----------------------|-------------------------|
| GET    | `/api/articles`       | List articles (paginated) |
| GET    | `/api/articles/:id`   | Get article by ID       |
| GET    | `/api/categories`     | List all categories     |
| GET    | `/api/tags`           | List all tags           |

### Authentication

| Method | Endpoint          | Description              |
|--------|-------------------|--------------------------|
| POST   | `/api/auth/login` | Login, returns JWT token |

### Admin Endpoints (Bearer token required)

| Method | Endpoint                    | Description         |
|--------|-----------------------------|---------------------|
| GET    | `/api/admin/articles`       | List all articles   |
| POST   | `/api/admin/articles`       | Create article      |
| PUT    | `/api/admin/articles/:id`   | Update article      |
| DELETE | `/api/admin/articles/:id`   | Delete article      |
| POST   | `/api/admin/categories`     | Create category     |
| PUT    | `/api/admin/categories/:id` | Update category     |
| DELETE | `/api/admin/categories/:id` | Delete category     |
| POST   | `/api/admin/tags`           | Create tag          |
| PUT    | `/api/admin/tags/:id`       | Update tag          |
| DELETE | `/api/admin/tags/:id`       | Delete tag          |
| POST   | `/api/admin/upload`         | Upload image        |

## Deployment

### Linux Server (one-click)

```bash
chmod +x deploy.sh
./deploy.sh
```

The script automatically installs Java, Maven, Node.js, Nginx, and MySQL client if missing. Supports Ubuntu/Debian and CentOS/RHEL/Fedora.

Options:

```
-d, --dir DIR        Frontend static files dir (default: /var/www/blog)
-b, --branch NAME    Git branch (default: master)
--skip-build         Skip build steps
--skip-deps          Skip dependency installation
```

### macOS Local Development

```bash
chmod +x deploy-mac.sh
./deploy-mac.sh          # Start all services
./deploy-mac.sh --stop   # Stop all services
```

Uses Homebrew to install dependencies and starts MySQL, backend, and frontend dev server.

### Production Build

```bash
# Backend
cd blog-backend
mvn clean package -DskipTests
java -jar target/blog-backend-1.0.0.jar

# Frontend
cd blog-frontend
npm run build
# Deploy dist/ to your web server
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
