#!/usr/bin/env bash
#
# gh-monthly-stats.sh — one month of public GitHub activity for the recap post.
#
# Usage: gh-monthly-stats.sh [YYYY-MM]
#   No argument: use the previous calendar month (UTC).
#
# Requires: gh (authenticated), jq
# Output: one JSON bundle on stdout (progress notes go to stderr).
#
# The bundle contains:
#   totals   - contributionsCollection counters (GitHub profile numbers)
#   prs      - PRs opened in the month, public repos only, split into
#              "feature" and "automation" buckets
#   releases - releases published in the month from repos that had PRs
#
# Automation bucket: PRs whose (repo + normalized title) pair shows up 5+
# times in the month — the daily "Update GitHub data (YYYY-MM-DD)" clones
# collapse to one key — or whose title matches known automation patterns.
# Human-shaped work stays in the feature bucket.
#
# The 5+ rule is a heuristic, not a law: a quiet month with a legitimately
# repetitive batch (five "Bump X" dependency PRs, say) would get bucketed
# as automation and vanish from the narrative.  Check prs.automation before
# believing a suspicious zero.
#
# Releases are only collected from repos with PR activity in the month;
# in this workflow releases always ride on merged PRs, so that set is
# reliable and keeps the API call count sane.

set -euo pipefail

GH_USER="${GH_RECAP_USER:-chicks-net}"
GH_ORG="${GH_RECAP_ORG:-fini-net}"

die() {
  echo "ERROR: $*" >&2
  exit 1
}

command -v gh >/dev/null 2>&1 || die "gh CLI not found; install it from https://cli.github.com/"
command -v jq >/dev/null 2>&1 || die "jq not found; try: brew install jq"
gh auth status >/dev/null 2>&1 || die "gh is not authenticated; run: gh auth login"

WORK="$(mktemp -d "${TMPDIR:-/tmp}/gh-recap.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT

# --- month -----------------------------------------------------------------

MONTH_ARG="${1:-}"
if [[ -n "$MONTH_ARG" ]]; then
  [[ "$MONTH_ARG" =~ ^[0-9]{4}-(0[1-9]|1[0-2])$ ]] ||
    die "month must look like YYYY-MM, got: $MONTH_ARG"
  TARGET="$MONTH_ARG"
else
  NOW_YEAR="$(date -u +%Y)"
  NOW_MONTH="$((10#$(date -u +%m)))"
  if [[ "$NOW_MONTH" -eq 1 ]]; then
    TARGET="$((NOW_YEAR - 1))-12"
  else
    TARGET="${NOW_YEAR}-$(printf '%02d' $((NOW_MONTH - 1)))"
  fi
fi

YEAR="${TARGET:0:4}"
MONTH_NUM="${TARGET:5:2}"
case "$MONTH_NUM" in
  02)
    if ((YEAR % 4 == 0 && (YEAR % 100 != 0 || YEAR % 400 == 0))); then
      LAST_DAY=29
    else
      LAST_DAY=28
    fi
    ;;
  04 | 06 | 09 | 11) LAST_DAY=30 ;;
  *) LAST_DAY=31 ;;
esac

FROM="${TARGET}-01T00:00:00Z"
TO="${TARGET}-${LAST_DAY}T23:59:59Z"
CREATED_RANGE="${TARGET}-01..${TARGET}-${LAST_DAY}"

echo "Gathering ${GH_USER} activity for ${TARGET} (${FROM} .. ${TO})" >&2

# --- profile-level totals (GraphQL) -----------------------------------------

# SC2016: the $ variables in the query are GraphQL parameters, not shell.
# pullRequestContributionsByRepository is deliberately NOT requested: with
# the owner's token it can include private repo names, and this bundle
# feeds a public blog post.  restrictedContributionsCount below is the
# public/private caveat that actually matters.
# shellcheck disable=SC2016
gh api graphql \
  -f query='query($login: String!, $from: DateTime!, $to: DateTime!) {
    user(login: $login) {
      contributionsCollection(from: $from, to: $to) {
        totalCommitContributions
        totalIssueContributions
        totalPullRequestContributions
        totalPullRequestReviewContributions
        totalRepositoriesWithContributedCommits
        restrictedContributionsCount
      }
    }
  }' \
  -f login="$GH_USER" -f from="$FROM" -f to="$TO" \
  > "$WORK/totals.json"

# --- PRs opened in the month -------------------------------------------------

gh search prs --author="$GH_USER" --created="$CREATED_RANGE" --limit 1000 \
  --json number,title,url,state,createdAt,closedAt,commentsCount,isDraft,repository \
  > "$WORK/prs_raw.json"

RAW_COUNT="$(jq 'length' "$WORK/prs_raw.json")"
if [[ "$RAW_COUNT" -ge 1000 ]]; then
  echo "WARNING: search returned ${RAW_COUNT} PRs; the search API caps at" \
    "1000 results — this month may be truncated" >&2
fi

# Keep only PRs in public repos.  The search API surfaces everything the
# token can see, including private repos, and this is a *public* activity
# recap — so a repo we cannot inspect fails CLOSED (excluded), because
# silence must not leak private PR titles into a public post.
REPOS="$(jq -r '[.[].repository.nameWithOwner] | unique | .[]' "$WORK/prs_raw.json")"
: > "$WORK/private_repos.txt"
while IFS= read -r repo; do
  [[ -n "$repo" ]] || continue
  VIS="$(gh api "repos/${repo}" --jq '.private' 2>/dev/null || true)"
  if [[ -z "$VIS" ]]; then
    echo "WARNING: could not inspect ${repo}; treating it as private" >&2
    echo "$repo" >> "$WORK/private_repos.txt"
  elif [[ "$VIS" == "true" ]]; then
    echo "$repo" >> "$WORK/private_repos.txt"
  fi
done <<< "$REPOS"
jq -R . "$WORK/private_repos.txt" | jq -s . > "$WORK/private_repos.json"

jq --slurpfile private "$WORK/private_repos.json" \
  '[.[] | select(.repository.nameWithOwner as $r | ($private[0] | index($r)) == null)]' \
  "$WORK/prs_raw.json" > "$WORK/prs_public.json"

PR_TOTAL="$(jq 'length' "$WORK/prs_public.json")"
echo "Found $PR_TOTAL public PRs opened in ${TARGET}" >&2

# --- automation bucket --------------------------------------------------------

# Normalizing by stripping a trailing parenthesized chunk collapses
# "Update GitHub data (2026-09-30)" style titles into one key per repo.
jq '
  def normtitle: gsub("\\s*\\([^)]*\\)\\s*$"; "");
  [.[] | .repository.nameWithOwner + "|" + (.title | normtitle)]
  | group_by(.)
  | [.[] | select(length >= 5) | .[0]]
' "$WORK/prs_public.json" > "$WORK/repeated_keys.json"

jq --argjson repeated "$(cat "$WORK/repeated_keys.json")" '
  def normtitle: gsub("\\s*\\([^)]*\\)\\s*$"; "");
  [.[] | . as $pr
    | ($pr.repository.nameWithOwner + "|" + ($pr.title | normtitle)) as $key
    | select(($pr.title | test("Update GitHub data")) or ($repeated | index($key) != null))]
' "$WORK/prs_public.json" > "$WORK/automation.json"

echo "Automation-bucketed $(jq 'length' "$WORK/automation.json") PRs" >&2
# Show what was bucketed, so a suspicious swallow can be spotted by eye.
jq -r '.[] | .repository.nameWithOwner + "|" + (.title | gsub("\\s*\\([^)]*\\)\\s*$"; ""))' \
  "$WORK/automation.json" | sort | uniq -c | sed 's/^/  automation: /' >&2

# --- releases ------------------------------------------------------------------
# Only own repos: a release from someone else's repo is theirs, not ours,
# even when we contributed a PR there that month.
# per_page=30 covers any realistic single month; a repo shipping more than
# 30 releases in a month would need paging here.

mkdir -p "$WORK/parts"
echo "[]" > "$WORK/parts/0.json"
N=0
while IFS= read -r repo; do
  [[ -n "$repo" ]] || continue
  N=$((N + 1))
  if gh api "repos/${repo}/releases?per_page=30" > "$WORK/rel.json" 2>/dev/null; then
    jq --arg repo "$repo" --arg from "$FROM" --arg to "$TO" '
      [.[] | select(.published_at != null)
        | select(.published_at >= $from and .published_at <= $to)
        | {repo: $repo, name, tag_name, published_at, html_url,
           prerelease, author: .author.login, body}]
    ' "$WORK/rel.json" > "$WORK/parts/$N.json"
  else
    echo "[]" > "$WORK/parts/$N.json"
  fi
done <<< "$(jq -r --arg user "$GH_USER" --arg org "$GH_ORG" \
  '[.[].repository.nameWithOwner] | unique | .[]
   | select((. | startswith($user + "/")) or (. | startswith($org + "/")))' \
  "$WORK/prs_public.json")"

jq -s '[.[][]]' "$WORK"/parts/*.json > "$WORK/releases.json"
echo "Found $(jq 'length' "$WORK/releases.json") releases published in ${TARGET}" >&2

# --- assemble the bundle --------------------------------------------------------

jq -n \
  --slurpfile totals "$WORK/totals.json" \
  --slurpfile all "$WORK/prs_public.json" \
  --slurpfile automation "$WORK/automation.json" \
  --slurpfile releases "$WORK/releases.json" \
  --arg user "$GH_USER" --arg org "$GH_ORG" \
  --arg month "$TARGET" --arg from "$FROM" --arg to "$TO" \
  '{
    user: $user,
    org: $org,
    month: $month,
    from: $from,
    to: $to,
    totals: $totals[0].data.user.contributionsCollection,
    prs: (
      $all[0] as $prs
      | ($automation[0] | map(.url)) as $auto_urls
      | ($prs | [.[] | select((.url as $u | $auto_urls | index($u)) == null)]) as $feature
      | ($feature
          | [.[] | select(.repository.nameWithOwner as $r
              | (($r | startswith($user + "/")) or ($r | startswith($org + "/"))))]) as $own
      | {
          total: ($prs | length),
          merged: ($prs | map(select(.state == "merged")) | length),
          open: ($prs | map(select(.state == "open")) | length),
          closed_unmerged: ($prs | map(select(.state == "closed")) | length),
          automation_count: ($automation[0] | length),
          automation: $automation[0],
          feature_count: ($feature | length),
          feature: $feature,
          own_count: ($own | length),
          own: $own,
          elsewhere_count: (($feature | length) - ($own | length)),
          elsewhere: ($feature
            | [.[] | select(.repository.nameWithOwner as $r
                | (($r | startswith($user + "/")) or ($r | startswith($org + "/")))
                | not)]),
          top_commented: ($feature | sort_by(.commentsCount) | reverse | .[0:15]),
          by_repo: ($own
            | group_by(.repository.nameWithOwner)
            | map({repo: .[0].repository.nameWithOwner, count: length})
            | sort_by(-.count))
        }
    ),
    releases: $releases[0]
  }'
