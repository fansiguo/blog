# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Hexo 8.x static blog site using the default **landscape** theme. Content is written in Markdown with YAML front matter.

## Commands

```bash
# Development server (http://localhost:4000)
npx hexo server            # or: npm run server

# Generate static files into public/
npx hexo generate          # or: npm run build

# Clean generated files and cache
npx hexo clean             # or: npm run clean

# Clean + regenerate (useful when things look stale)
npx hexo clean && npx hexo generate

# Create a new post
npx hexo new "Post Title"

# Create a draft (not published until promoted)
npx hexo new draft "Draft Title"

# Promote a draft to a post
npx hexo publish "Draft Title"

# Create a new page (e.g., about page)
npx hexo new page "page-name"

# Deploy (requires deploy config in _config.yml)
npx hexo deploy            # or: npm run deploy
```

## Architecture

```
_config.yml              # Main site configuration (title, URL, theme, permalink pattern, etc.)
_config.landscape.yml    # Theme-specific config overrides for the landscape theme
source/
  _posts/                # Published blog posts (Markdown with front matter)
  _drafts/               # Draft posts (not generated unless --draft flag is used)
  <other>/               # Standalone pages (e.g., source/about/index.md)
scaffolds/               # Templates for `hexo new` — defines default front matter
  post.md                # Template for new posts (title, date, tags)
  draft.md               # Template for new drafts (title, tags — no date until published)
  page.md                # Template for new pages (title, date)
themes/                  # Theme directory; active theme set by `theme:` in _config.yml
public/                  # Generated output (gitignored)
db.json                  # Hexo cache (gitignored)
```

## Post Front Matter

Posts use YAML front matter. The scaffold template includes `title`, `date`, and `tags`. Common fields:

```yaml
---
title: My Post Title
date: 2026-03-24 10:00:00
tags:
  - javascript
  - tutorial
categories:
  - Tech
---
```

## Key Configuration

- **Permalink pattern**: `:year/:month/:day/:title/` (set in `_config.yml`)
- **Syntax highlighting**: highlight.js (configured in `_config.yml` under `syntax_highlighter`)
- **Pagination**: 10 posts per page
- **Theme config**: Theme-specific settings go in `_config.landscape.yml` (not inside the theme directory), following Hexo's alternate theme config convention
