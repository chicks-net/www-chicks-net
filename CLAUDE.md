# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About This Project

This is a Hugo-based static site for <https://www.chicks.net> built with the PaperMod theme. The site contains blog posts, links, and personal content for Christopher Hicks.

## Common Development Tasks

### Building and Development

- **Build site**: `just hugo` - Builds the site with `TZ=America/Los_Angeles`, manages backup directories (public.prev), and runs git stp. Use `just hugo force` to override if public.prev exists.
- **Development server**: `just server` - Runs Hugo development server at <http://localhost:1313>, automatically rebuilds site on exit
- **Open dev server**: `just see-server` - Opens browser and starts server
- **Hugo module maintenance**: `just hugo_mod_tidy` and `just hugo_mod_update`

### Content Creation

- **Create new post**: `just post <branchname>` - Creates new branch and post template in content/posts/
- **Create new branch**: `just branch <branchname>` - Creates timestamped feature branch
- **Extract hashtags**: `just hashtags <filename>` - Extracts tags/keywords as hashtags from post frontmatter
- **Tag optimization**: Use the `post-tagger` Claude agent (in `.claude/agents/`) to review and optimize tags across posts for consistency and discoverability
- **Remove GPS data**: `just gps_rm <image>` - Strips GPS metadata from images before publishing

### Development Workflow

The project uses a streamlined git workflow with just commands:

1. **Start work**: `just branch <name>` or `just post <name>` (creates timestamped branches)
2. **Create PR**: `just pr` - Runs `just hugo` automatically via PR hook, pushes branch, creates PR with first commit message as title, then watches GHA checks and displays Copilot/Claude code review comments
3. **Update PR**: `just pr_update` - Updates PR description's Done section with current commits
4. **Add verification**: `just pr_verify` - Adds or appends to Verify section from stdin
5. **View PR**: `just prweb` - Opens PR in browser
6. **Merge**: `just merge` - Merges PR, deletes branch, returns to main
7. **Sync**: `just sync` - Returns to main branch and pulls latest

### Code Quality

- **Markdown linting**: Run `markdownlint-cli2` (configured in `.markdownlint.yml`)
- **Shellcheck**: `just shellcheck` - Lints bash scripts embedded in justfiles
- **CUE verification**: `just cue_verify` - Validates metadata files against CUE schema (docs/cue/meta.cue)
- **Git workflow**: All branches are timestamped and prefixed with `chicks/` or `chicks/post/`
- **Content structure**: Posts go in `content/posts/`, use ISO date prefixes (YYYY-MM-DD format)

## Architecture

- **Hugo static site generator** with PaperMod theme imported as Go module
- **Content organization**:
  - `content/posts/` - Blog posts (many imported from LinkedIn)
  - `content/links/` - Links and bragging page
  - `content/intro/` - Introduction content
  - `content/reference/` - Reference documentation organized by topic
- **Just-based automation** with modular justfiles in `.just/` directory:
  - `.just/gh-process.just` - Git/GitHub workflow automation (v4.0)
  - `.just/hugo.just` - Hugo build and server commands (builds with Pacific timezone)
  - `.just/pr-hook.just` - Pre-PR automation (runs `just hugo`)
  - `.just/utility.just` - Utility functions (hashtags, GPS removal, date formatting)
  - `.just/shellcheck.just` - Shellcheck linting for justfile scripts
  - `.just/example.just` - Example recipes and color tests
- **Git-centric workflow** with GitHub CLI integration for PRs
- **Generated HTML** is in the `public/` directory and kept in sync with content changes (needed for current deployment strategy)
- **Custom Claude agent**: `post-tagger` agent for optimizing tags across posts (`.claude/agents/post-tagger.md`)
- **Timezone handling**: Hugo builds use Pacific timezone (`TZ=America/Los_Angeles`) for consistent date rendering

## Key Files

- `hugo.toml` - Hugo configuration with theme and site settings
- `justfile` - Main automation commands, imports from `.just/`
- `.just/hugo.just` - Hugo-specific commands
- `.just/gh-process.just` - Git/GitHub workflow (v4.0)
- `go.mod` - Hugo module dependencies (primarily PaperMod theme)
- `.markdownlint.yml` - Markdown linting rules
- `.claude/agents/post-tagger.md` - Custom agent for tag optimization
- `docs/cue/meta.cue` - CUE schema for metadata validation
- `.fini/meta.toml` - Project metadata (validated by CUE)

## Branch Naming

All branches follow the pattern `chicks/<timestamp>-<description>` or
`chicks/post/<timestamp>-<description>` for posts. Timestamps are in ISO date format (YYYY-MM-DD) using UTC.
