# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About This Project

This is a Hugo-based static site for <https://www.chicks.net> built with the PaperMod theme. The site contains blog posts, links, and personal content for Christopher Hicks.

## Common Development Tasks

### Building and Development

- **Build site**: `just hugo` - Builds the site, manages backup directories, and runs git stp
- **Development server**: `just server` - Runs Hugo development server at <http://localhost:1313>
- **Open dev server**: `just see-server` - Opens browser and starts server
- **Hugo module maintenance**: `just hugo_mod_tidy` and `just hugo_mod_update`

### Content Creation

- **Create new post**: `just post <branchname>` - Creates new branch and post template
- **Create new branch**: `just branch <branchname>` - Creates timestamped feature branch
- **Extract hashtags**: `just hashtags <filename>` - Extracts tags/keywords as hashtags from post frontmatter

### Development Workflow

The project uses a streamlined git workflow with just commands:

1. **Start work**: `just branch <name>` or `just post <name>` (creates timestamped branches)
2. **Create PR**: `just pr` - Runs `just hugo` automatically via PR hook, pushes branch, creates PR with first commit message as title
3. **Merge**: `just merge` - Merges PR, deletes branch, returns to main
4. **Sync**: `just sync` - Returns to main branch and pulls latest

### Code Quality

- **Markdown linting**: Run `markdownlint-cli2` (configured in `.markdownlint.yml`)
- **Shellcheck**: `just shellcheck` - Lints bash scripts embedded in justfiles
- **Git workflow**: All branches are timestamped and prefixed with `chicks/`
  because that is the only user actively contributing to the project.
- **Content structure**: Posts go in `content/posts/`, use ISO date prefixes (YYYY-MM-DD format)

## Architecture

- **Hugo static site generator** with PaperMod theme imported as Go module
- **Content organization**:
  - `content/posts/` - Blog posts (many imported from LinkedIn)
  - `content/links/` - Links and bragging page
  - `content/intro/` - Introduction content
  - `content/reference/` - Reference documentation organized by topic
- **Just-based automation** with modular justfiles in `.just/` directory:
  - `.just/gh-process.just` - Git/GitHub workflow automation
  - `.just/hugo.just` - Hugo build and server commands
  - `.just/pr-hook.just` - Pre-PR automation (runs `just hugo`)
  - `.just/utility.just` - Utility functions (hashtags, GPS removal, etc.)
  - `.just/shellcheck.just` - Shellcheck linting for justfile scripts
- **Git-centric workflow** with GitHub CLI integration for PRs
- Generated HTML is in the `public/` directory and it is kept in
  sync with any content changes.  This is needed for the current deployment
  strategy.

## Key Files

- `hugo.toml` - Hugo configuration with theme and site settings
- `justfile` - Main automation commands, imports from `.just/`
- `.just/hugo.just` - Hugo-specific commands
- `.just/gh-process.just` - Git/GitHub workflow (v3.9)
- `go.mod` - Hugo module dependencies (primarily PaperMod theme)
- `.markdownlint.yml` - Markdown linting rules

## Branch Naming

All branches follow the pattern `chicks/<timestamp>-<description>` or
`chicks/post/<timestamp>-<description>` for posts. Timestamps are in ISO date format (YYYY-MM-DD) using UTC.
