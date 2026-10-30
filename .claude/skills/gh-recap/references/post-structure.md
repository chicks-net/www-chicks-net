# Post structure for GitHub recap posts

The recap is a regular Hugo post in `content/posts/`, TOML front matter,
dated the last day of the summarized month. Stats-forward with light
narrative: numbers first, stories second.

## Front matter template

```toml
+++
title = '<Month Year> on GitHub: <light flavor phrase>'
date = <YYYY-MM-DD>T12:00:00+00:00
draft = false
description = '<one casual sentence about the month>'
cover.hidden = true
keywords = ["github", "monthly-recap", "<topic>", "<topic>"]
tags = ["<existing>", "<existing>", "<existing>"]
ShowToc = true
+++
```

- `date` is the **last day of the summarized month** (e.g. the 2026-09 recap
  is dated `2026-09-30T12:00:00+00:00`), even though you usually write the
  post days later. 12:00 UTC keeps the date on that day in the Pacific
  timezone Hugo builds with.
- `draft = false` by default — the post goes live when its PR merges. Set
  `draft = true` only when the user explicitly wants to preview unpublished.
- Title format follows posts like "Announcing gh-observer: Waiting for CI
  Should Not Be Misery" — a statement, then a colon, then the hook. Good
  hooks name the biggest thing that happened ("The Month ctm Shipped Twice").
- Tags: lowercase, alphabetical, reuse existing site tags. `github`,
  `programming`, and `free-software` are established. Only coin a new tag if
  the month had a distinct theme worth collecting.

## Section skeleton

### Intro (2-4 sentences, no heading)

Casual hook, what this post is, one joke at your own expense. Something
like: "Another month, another pile of merged PRs. Here's what actually
happened on GitHub in September, robots and all."

Series framing rules:

- The series starts with the **September 2025** recap — that post, and only
  that post, says it's kicking off the habit.
- Later recaps never claim to be the first. Reference the series plainly
  ("another in the series of monthly recaps") and link the most recent
  earlier recap when one exists.

### `## By the Numbers`

A table first, then a couple sentences of commentary. Pull every number
from the data bundle — totals are in `totals`, PR counts in `prs`.

```markdown
| Metric | Count |
| ------ | ----- |
| Pull requests opened | 202 |
| ... merged | 190 |
| ... still open | 5 |
| Issues opened | 69 |
| Commits | 200 |
| PR reviews given | 74 |
| Repos touched | 30 |
| Bot-filed data updates | 46 |
```

Notes on the numbers:

- `prs.*` counts come from the public-repo-filtered search and are the
  ground truth for PR counts.
- `totals.*` are GitHub profile counters. If
  `totals.restrictedContributionsCount` is nonzero, some of those are
  private contributions — say "per my GitHub profile" or lean on the
  PR-list numbers instead of implying everything is public.
- The automation bucket deserves a wry one-liner, not a section.

### `## Elsewhere`

Only when `prs.elsewhere_count` is nonzero — skip the section entirely
otherwise. This covers PRs in repos owned by neither chicks-net nor
fini-net: contributions to other people's projects. The user wants these
called out separately, so give each a short paragraph — repo, what the PR
did, whether it merged, and a link. If one of them is a big deal (large
diff, lively review thread, landed in a well-known project), tell its story
here rather than in Notable Pull Requests.

### `## Releases Shipped`

One `###` sub-heading per release — `### repo vX.Y` — each with a short
casual paragraph summarizing what the changelog body says shipped, and a
link to the release. Group multiple releases of the same repo into one
sub-heading when they tell one story (ctm v0.1 and v0.2 two days apart is
one story). If the month had zero releases, skip the section.

### `## Notable Pull Requests`

3-5 picks, each as a short paragraph (or bolded lead-in plus paragraph):
what it did, the size, how many review cycles it survived, why it mattered,
and the PR link. Exclude bot reviewers when counting review cycles — Copilot
and Claude comment on everything in this workflow. If nothing qualifies,
a sentence saying so is fine.

### `## Embedded Metadata`

Every post closes with the AI/cross-post disclosure section, matching the
convention at the bottom of posts like the gh-observer announcement:

```markdown
## Embedded Metadata

These are times where it seems good to be explicit about our choices about and
usage of AI (Artificial Intelligence). Plus any links to cross-posts I do.

- This post was drafted by Claude in OpenCode using the `gh-recap` skill;
  the numbers came straight from GitHub's API via the `gh` CLI on <date>.
- The draft was reviewed and edited by me before publishing.
```

Adjust the wording honestly for whatever actually happened. Add cross-post
links if the user mentions any.

## Voice reminders

- Casual, conversational, contractions. "I merged", not "the author merged".
- Self-deprecating humor lands better than bragging; let the numbers brag.
- A nostalgia or tech-history nod fits naturally in the intro or around
  the automation numbers.
- Write for an audience that's college educated or equivalent — no jargon
  explanations needed for git/PR/CI concepts.
- markdownlint: line length is unchecked (MD013 off), lists use `-`,
  bare URLs are fine in this repo's posts but prefer proper Markdown links
  for PRs and releases.
