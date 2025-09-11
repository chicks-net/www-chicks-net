# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About This Project

This is a Hugo-based static site for https://www.chicks.net built with the PaperMod theme. The site contains blog posts, links, and personal content for Christopher Hicks.

## Common Development Tasks

### Building and Development

- **Build site**: `just hugo` - Builds the site, manages backup directories, and runs git stp
- **Development server**: `just server` - Runs Hugo development server at http://localhost:1313
- **Open dev server**: `just see-server` - Opens browser and starts server
- **Hugo module maintenance**: `just hugo_mod_tidy` and `just hugo_mod_update`

### Content Creation

- **Create new post**: `just post <branchname>` - Creates new branch and post template
- **Create new branch**: `just branch <branchname>` - Creates timestamped feature branch

### Development Workflow

The project uses a streamlined git workflow with just commands:

1. **Start work**: `just branch <name>` or `just post <name>` (creates timestamped branches)
2. **Create PR**: `just pr` - Builds site, pushes branch, creates PR with commit message as title
3. **Merge**: `just merge` - Merges PR, deletes branch, returns to main
4. **Sync**: `just sync` - Returns to main branch and pulls latest

### Code Quality

- **Markdown linting**: Uses `markdownlint-cli2` with configuration in `.markdownlint.yml`
- **Git workflow**: All branches are timestamped and prefixed with `chicks/`
- **Content structure**: Posts go in `content/posts/`, use ISO date prefixes

## Architecture

- **Hugo static site generator** with PaperMod theme imported as Go module
- **Content organization**: 
  - `content/posts/` - Blog posts (many imported from LinkedIn)
  - `content/links/` - Links and bragging page
  - `content/intro/` - Introduction content
- **Just-based automation** with modular justfiles in `.just/` directory
- **Git-centric workflow** with GitHub CLI integration for PRs

## Key Files

- `hugo.toml` - Hugo configuration with theme and site settings
- `justfile` - Main automation commands, imports from `.just/`
- `.just/hugo.just` - Hugo-specific commands
- `go.mod` - Hugo module dependencies (primarily PaperMod theme)
- `.markdownlint.yml` - Markdown linting rules

## Branch Naming

All branches follow the pattern `chicks/<timestamp>-<description>` or `chicks/post/<timestamp>-<description>` for posts.