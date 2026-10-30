---
name: GitHub Monthly Recap
description: Create a blog post for www.chicks.net recapping one month of public GitHub activity (default: the previous calendar month). Use this whenever the user asks for a GitHub recap, monthly recap, monthly wrap-up or wrapup, "what did I do last month", a summary of their GitHub activity or PRs, release stats for a month, or a blog post about their recent coding activity — even if they never say the word "recap" or "blog". Gathers real data with the gh CLI (PRs, comments, releases) and writes a ready-to-publish post with overall statistics, release summaries, and notable pull requests.
---

# GitHub Monthly Recap

Produce a Hugo post (published on merge) summarizing Christopher Hicks'
public GitHub activity for one month, in his voice, following this repo's
conventions.

## Ground rules

- Work happens in this repo (www-chicks-net). Posts go in `content/posts/`.
- Every number in the post must come from the data bundle — never invent
  stats. If the month was quiet, write a short, honest post.
- The post publishes on merge (`draft = false` is the default). The user
  still reviews before merging; if they want to sit on a post, they set
  `draft = true` themselves. Do not run `just pr` unless asked.
- Use TOML front matter (`+++`), never YAML. See `references/post-structure.md`
  for the exact template and section skeleton.

## 1. Pick the month

Default to the **previous calendar month** (a run in November → October recap).
If the user names a month ("recap September", "wrap up August"), use that.
Month format: `YYYY-MM`. Sanity-check anything older than a year — GitHub
search still works, but ask if they really want it.

## 2. Create the working branch and post file

Run `just post github-recap-YYYY-MM`. This creates the branch
`chicks/post/<today>-github-recap-YYYY-MM` (repo convention) plus a
skeleton post dated *today* — wrong for our purposes, so delete that
skeleton file and write the real post as:

```text
content/posts/<last-day-of-month>-github-recap-YYYY-MM.md
```

For example, the September 2026 recap lives at
`content/posts/2026-09-30-github-recap-2026-09.md` with
`date = 2026-09-30T12:00:00+00:00`. The post is dated as if written on the
last day of the summarized month (12:00 UTC keeps it on that day when Hugo
renders with `TZ=America/Los_Angeles`).

## 3. Gather the data

Run the stats script from this skill's base directory (the directory holding
this SKILL.md):

```bash
bash scripts/gh-monthly-stats.sh YYYY-MM
```

It queries GitHub through the authenticated `gh` CLI and prints one JSON
bundle:

- `totals` — GitHub profile counters for the month (commits, issues, PRs,
  reviews given, repos touched, private-restricted count)
- `prs` — PRs opened that month, public repos only, split into an
  `automation` bucket (bot noise), `own` (repos under chicks-net or
  fini-net), and `elsewhere` (repos owned by other people or orgs), plus
  `top_commented` and `by_repo`
- `releases` — releases published that month from the active repos, with
  tag, date, author, URL, and changelog body

The `automation` bucket is daily-bot noise like the data-curated
"Update GitHub data" PRs. Report it in the stats as a one-liner ("the robots
filed 46 of those on their own") but never treat it as notable work.

If the script fails, check `gh auth status` before anything else. Never
fabricate a bundle.

## 4. Choose notable pull requests

Shortlist roughly ten candidates from `prs.top_commented` and anything
interesting-looking in `prs.feature`, then fetch details for each:

```bash
gh pr view NUMBER --repo OWNER/REPO --json additions,deletions,commits,reviews,comments,body
```

A PR is notable when it meets either of the user's criteria:

- **Many review cycles.** In this workflow reviews usually happen in the
  comment thread, not the formal `reviews` array: the AI reviewer
  (`claude`, `copilot-pull-request-reviewer`) leaves a review, the author
  responds with fixes ("Round 2 review — point by point"), and it re-reviews.
  **Every PR gets at least one drive-by bot review, so one proves nothing.**
  The signal is *rounds*: fetch `comments` and `reviews` together and count
  the alternations between author responses and reviewer re-reviews, or
  explicit "Round N" language. Three or more rounds counts as many review
  cycles.
- **Landed a major feature.** A large diff (additions + deletions in the
  hundreds or more), or a title/body that adds, creates, ports, rewrites, or
  launches something significant.

Pick **3 to 5**. Skip the automation bucket and skip dependency bumps. For
each pick know: what it did, how big it was, how many review cycles it took,
and its URL. If nothing qualifies, say so — "nothing rose to notable this
month" is a perfectly fine sentence.

**Third-party repos**: PRs in `prs.elsewhere` — repos owned by neither
chicks-net nor fini-net — do **not** belong in Notable Pull Requests. The
user wants contributions to other people's projects called out separately in
their own "Elsewhere" section; an exceptional one gets its story told there,
with the same notability eye.

## 5. Write the post

Read `references/post-structure.md` for the front-matter template and
section skeleton: intro → "By the Numbers" → "Elsewhere" (only when
`prs.elsewhere_count` is nonzero) → "Releases Shipped" → "Notable Pull
Requests" → "Embedded Metadata".

**Series framing**: the recap series began with the September 2025 post.
Only that post gets "kicking off a new habit" framing — later recaps
reference the series plainly and never claim to be the first. Linking the
most recent earlier recap is a nice touch; find it with:

```bash
ls content/posts | grep github-recap | sort | tail -2
```

- **Voice**: Christopher's — casual, conversational, contractions,
  self-deprecating humor, direct and practical, a tech-history or nostalgia
  nod when it fits. Write for smart friends, not a committee. The global
  writing-style rules live in `~/.claude/CLAUDE.md`.
- **Balance**: stats-forward with light narrative. Get the numbers up top in
  a table, then tell the stories behind the interesting bits. Link every PR
  and release mentioned.
- **Tags**: lowercase, alphabetical, prefer tags already in use on the site
  (`github`, `programming`, and `free-software` are established). Check the
  vocabulary first:

```bash
grep -rhoE 'tags = \[[^]]*\]' content/posts --include='*.md' | sort | uniq -c | sort -rn | head -40
```

## 6. Lint, then report

```bash
markdownlint-cli2 '**/*.md' '!.github/**/*.md' '!public/**/*.md' '!static/**/*.md'
```

That is the exact invocation the CI `markdown-lint` job runs, over the
whole repo — use it rather than linting only the new post, so the skill's
own files (and anything else touched) get checked too. Fix any
complaints. Known traps in this repo: files must end with a single
trailing newline (MD047 is enabled), fenced code blocks need blank lines
around them (MD031), line length MD013 is disabled, and lists use
dashes. Verify the build accepts the post without touching the
committed `public/` directory:

```bash
hugo --renderToMemory --quiet
```

Then report to the user: the file path, the headline stats, which
PRs you picked as notable and why, and a reminder that the post publishes
when its PR merges — if they want to hold it back, they set
`draft = true` before merging. Offering a `just server` preview link is a
nice touch.
