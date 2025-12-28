#!/bin/bash
# Script to create GitHub issues from TODO.md
# Run this script when ready to migrate TODO items to GitHub issues
#
# Prerequisites: gh CLI must be installed and authenticated
# Usage: ./create-github-issues.sh

set -euo pipefail

# Create labels if they don't exist
#echo "Creating labels..."
#gh label create "priority:definite" --color "d73a4a" --description "Definite TODO items" --force || true
#gh label create "priority:probable" --color "e99695" --description "Probable TODO items" --force || true
#gh label create "priority:possible" --color "f9d0c4" --description "Possible TODO items" --force || true
#gh label create "priority:unlikely" --color "fef2c0" --description "Unlikely TODO items" --force || true
#gh label create "priority:impossible" --color "c2e0c6" --description "Impossible TODO items (archive)" --force || true
#gh label create "type:content" --color "0075ca" --description "Content creation (blog/video)" --force || true
#gh label create "type:technical" --color "1d76db" --description "Technical/development work" --force || true
#gh label create "type:link" --color "bfdadc" --description "Link additions" --force || true
#gh label create "status:drafting" --color "fbca04" --description "Currently drafting" --force || true
#gh label create "status:outlined" --color "fef2c0" --description "Outlined but not drafted" --force || true
#gh label create "status:blocked" --color "d93f0b" --description "Blocked by dependency" --force || true

echo "Creating issues..."

# Definite TODOs - November
# gh issue create \
#   --title "Video/blog on fini-coredns-example" \
#   --body "Create video and/or blog entry on [fini-coredns-example](https://github.com/fini-net/fini-coredns-example)
# 
# Status: DRAFTing, ready soon
# 
# Original TODO: content/posts/" \
#   --label "priority:definite,type:content,status:drafting"
# 
# gh issue create \
#   --title "Blog entry on gamification in Google Maps" \
#   --body "Write blog entry discussing gamification aspects in Google Maps.
# 
# Status: DRAFTing
# 
# Original TODO: content/posts/" \
#   --label "priority:definite,type:content,status:drafting"
# 
# gh issue create \
#   --title "Get non-SSL site to redirect to the SSL site" \
#   --body "Configure HTTP to HTTPS redirect for the site.
# 
# Original TODO: technical task" \
#   --label "priority:definite,type:technical"

# # Definite TODOs - December
# gh issue create \
#   --title "Video/blog on evolved just-based workflow" \
#   --body "Create video and/or blog entry on my evolved \`just\`-based workflow.
# 
# Status: Outlining in [\`just-quick\`](https://github.com/chicks-net/presentation-notes/tree/main/just-quick)
# 
# Original TODO: content/posts/" \
#   --label "priority:definite,type:content,status:outlined"
# 
# gh issue create \
#   --title "Blog entry on cryptocurrency being a Potemkin village" \
#   --body "Write blog entry on cryptocurrency being a Potemkin village.
# 
# Status: DRAFTing
# 
# Original TODO: content/posts/" \
#   --label "priority:definite,type:content,status:drafting"
# 
# gh issue create \
#   --title "Blog entry on the value of playlists" \
#   --body "Write blog entry discussing the value of playlists.
# 
# Original TODO: content/posts/" \
#   --label "priority:definite,type:content"
# 
# gh issue create \
#   --title "Track config in .fini/??.toml" \
#   --body "Implement configuration tracking in \`.fini/??.toml\`.
# 
# Status: DRAFTing
# 
# Original TODO: technical task" \
#   --label "priority:definite,type:technical,status:drafting"

# # Definite TODOs - Someday
# gh issue create \
#   --title "Retroblogging google+ content" \
#   --body "Complete retroblogging of [google+ content](https://github.com/chicks-net/google-plus-posts-dumper).
# 
# Original TODO: technical task" \
#   --label "priority:definite,type:technical"
# 
# gh issue create \
#   --title "Blog entry on habits and streaks" \
#   --body "Write blog entry on habits and streaks.
# 
# Status: DRAFTing, ready soon
# 
# Original TODO: content/posts/" \
#   --label "priority:definite,type:content,status:drafting"
# 
# gh issue create \
#   --title "Blog entry on backing into parking spaces" \
#   --body "Write blog entry on backing into parking spaces.
# 
# Status: Outlined
# 
# Original TODO: content/posts/" \
#   --label "priority:definite,type:content,status:outlined"
# 
# gh issue create \
#   --title "Blog entry on calendaring" \
#   --body "Write blog entry on calendaring.
# 
# Status: Outlined
# 
# Original TODO: content/posts/" \
#   --label "priority:definite,type:content,status:outlined"
# 
# gh issue create \
#   --title "Blog entry on news organizations that I support" \
#   --body "Write blog entry on news organizations that I support.
# 
# Original TODO: content/posts/" \
#   --label "priority:definite,type:content"
# 
# gh issue create \
#   --title "Blog entry on the AI hype cycle" \
#   --body "Write blog entry on the AI hype cycle.
# 
# Mention: <https://www.economist.com/business/2025/09/08/faith-in-god-like-large-language-models-is-waning>
# 
# Original TODO: content/posts/" \
#   --label "priority:definite,type:content"

# gh issue create \
#   --title "Blog entry on shell programming best practices" \
#   --body "Write blog entry on shell programming (bash, zsh) best practices.
# 
# Status: DRAFTing
# 
# Original TODO: content/posts/" \
#   --label "priority:definite,type:content,status:drafting"
# 
# gh issue create \
#   --title "Blog entry on usernames" \
#   --body "Write blog entry on usernames.
# 
# Original TODO: content/posts/" \
#   --label "priority:definite,type:content"
# 
# gh issue create \
#   --title "Blog entry on retroblogging" \
#   --body "Write blog entry on \"retroblogging\".
# 
# Status: Blocked by [google+ content](https://github.com/chicks-net/google-plus-posts-dumper)
# 
# Original TODO: content/posts/" \
#   --label "priority:definite,type:content,status:blocked"
# 
# gh issue create \
#   --title "Video/blog on the California Weather Refund Form" \
#   --body "Create video and/or blog entry on the California Weather Refund Form.
# 
# Original TODO: content/posts/" \
#   --label "priority:definite,type:content"
# 
# gh issue create \
#   --title "Configure webhook for updates" \
#   --body "Set up webhook configuration for site updates.
# 
# Original TODO: technical task" \
#   --label "priority:definite,type:technical"

# Probable TODOs
# gh issue create \
#   --title "Blog entry on git branch naming for racial sensitivity" \
#   --body "Write blog entry on git branch naming for racial sensitivity.
# 
# Status: Blocked by an interview
# 
# Original TODO: content/posts/" \
#   --label "priority:probable,type:content,status:blocked"
# 
# gh issue create \
#   --title "Video/blog entry on places we like in Pismo" \
#   --body "Create video and/or blog entry on places we like in Pismo.
# 
# Status: Outlined
# 
# Original TODO: content/posts/" \
#   --label "priority:probable,type:content,status:outlined"
# 
# gh issue create \
#   --title "Blog entry on cataloging books with LibraryThing" \
#   --body "Write blog entry on cataloging books with LibraryThing.
# 
# Original TODO: content/posts/" \
#   --label "priority:probable,type:content"
# 
# gh issue create \
#   --title "Blog entry on East vs West" \
#   --body "Write blog entry on East vs West.
# 
# Status: Outline started
# 
# Original TODO: content/posts/" \
#   --label "priority:probable,type:content,status:outlined"
# 
# gh issue create \
#   --title "Video/blog entry on riding in a Waymo" \
#   --body "Create video and/or blog entry on riding in a Waymo.
# 
# Original TODO: content/posts/" \
#   --label "priority:probable,type:content"

# gh issue create \
#   --title "Video/blog entry on UTC (for the win!)" \
#   --body "Create video and/or blog entry on UTC.
# 
# Original TODO: content/posts/" \
#   --label "priority:probable,type:content"
# 
# gh issue create \
#   --title "Blog entry on how to wrap cables with Velcro" \
#   --body "Write blog entry on how to wrap cables with Velcro.
# 
# Original TODO: content/posts/" \
#   --label "priority:probable,type:content"
# 
# gh issue create \
#   --title "Blog entry on the Williamsburg Pottery Factory (WPF)" \
#   --body "Write blog entry on the Williamsburg Pottery Factory.
# 
# Original TODO: content/posts/" \
#   --label "priority:probable,type:content"
# 
# gh issue create \
#   --title "Retroblog PvZ game guide" \
#   --body "Retroblog [PvZ game guide](https://steamcommunity.com/sharedfiles/filedetails/?id=396162375).
# 
# Original TODO: content/posts/" \
#   --label "priority:probable,type:content"
# 
# gh issue create \
#   --title "Retroblog google maps reviews" \
#   --body "Retroblog google maps reviews.
# 
# Original TODO: content/posts/" \
#   --label "priority:probable,type:content"
# 
# gh issue create \
#   --title "Retroblog StackExchange posts" \
#   --body "Retroblog StackExchange posts.
# 
# Note: [post on licensing](https://meta.stackexchange.com/q/344491/275180)
# 
# Original TODO: content/posts/" \
#   --label "priority:probable,type:content"

# Possible TODOs
# gh issue create \
#   --title "Try weaver for tag compliance" \
#   --body "Evaluate [weaver](https://github.com/open-telemetry/weaver) for tag compliance.
# 
# Original TODO: technical task" \
#   --label "priority:possible,type:technical"
# 
# gh issue create \
#   --title "Blog entry on webhook journey" \
#   --body "Write blog entry on webhook journey.
# 
# Original TODO: content/posts/" \
#   --label "priority:possible,type:content"
# 
# gh issue create \
#   --title "Blog entry on nushell" \
#   --body "Write blog entry on nushell.
# 
# Reference: [my nuggets](https://gist.github.com/chicks-net/7fa2425f6afb14261f39352605019209)
# 
# Original TODO: content/posts/" \
#   --label "priority:possible,type:content"
# 
# gh issue create \
#   --title "Blog entry on tmux" \
#   --body "Write blog entry on tmux.
# 
# Original TODO: content/posts/" \
#   --label "priority:possible,type:content"
# 
# gh issue create \
#   --title "Blog entry on Markdown linting and grammar checking" \
#   --body "Write blog entry on Markdown linting and grammar checking.
# 
# Original TODO: content/posts/" \
#   --label "priority:possible,type:content"
# 
# gh issue create \
#   --title "Blog entry on getting a tech job" \
#   --body "Write blog entry on getting a tech job.
# 
# Original TODO: content/posts/" \
#   --label "priority:possible,type:content"

# gh issue create \
#   --title "Blog entry on Hubspace string lights review" \
#   --body "Write blog entry reviewing Hubspace string lights.
# 
# Original TODO: content/posts/" \
#   --label "priority:possible,type:content"
# 
# gh issue create \
#   --title "Blog entry on 3D rendering LEGO in Blender" \
#   --body "Write blog entry on 3D rendering LEGO in Blender.
# 
# Original TODO: content/posts/" \
#   --label "priority:possible,type:content"
# 
# gh issue create \
#   --title "Blog entry on chicks doesn't sleep" \
#   --body "Write blog entry on sleep patterns/habits.
# 
# Note: Should wait until certain people retire
# 
# Original TODO: content/posts/" \
#   --label "priority:possible,type:content"
# 
# gh issue create \
#   --title "Blog entry on the characters in Duolingo" \
#   --body "Write blog entry on the characters in Duolingo.
# 
# Original TODO: content/posts/" \
#   --label "priority:possible,type:content"
# 
# gh issue create \
#   --title "Blog entry on books about the crazy computer business" \
#   --body "Write blog entry on books about the computer industry.
# 
# Original TODO: content/posts/" \
#   --label "priority:possible,type:content"
# 
# gh issue create \
#   --title "Blog entry on unanswered questions" \
#   --body "Write blog entry on unanswered questions.
# 
# Original TODO: content/posts/" \
#   --label "priority:possible,type:content"
# 
# gh issue create \
#   --title "Blog entry on review of in-terminal web browsers" \
#   --body "Write blog entry reviewing in-terminal web browsers.
# 
# Original TODO: content/posts/" \
#   --label "priority:possible,type:content"
# 
# gh issue create \
#   --title "Blog entry on immoral origins of copyright laws" \
#   --body "Write blog entry on immoral origins of copyright laws.
# 
# Original TODO: content/posts/" \
#   --label "priority:possible,type:content"
# 
# gh issue create \
#   --title "Blog entry on labels and tags" \
#   --body "Write blog entry on labels and tags (AWS, TZ tape, Obs, etc.).
# 
# Original TODO: content/posts/" \
#   --label "priority:possible,type:content"

# gh issue create \
#   --title "Link to fitbit profile" \
#   --body "Add link to fitbit profile on the site.
# 
# Original TODO: links page" \
#   --label "priority:possible,type:link"
# 
# gh issue create \
#   --title "More StackExchange profiles" \
#   --body "Add more StackExchange profile links to the site.
# 
# Original TODO: links page" \
#   --label "priority:possible,type:link"
# 
# gh issue create \
#   --title "Link to bricklink when it is working again" \
#   --body "Add link to bricklink when it is working again.
# 
# Original TODO: links page" \
#   --label "priority:possible,type:link"
# 
# gh issue create \
#   --title "Link to calendly" \
#   --body "Add link to calendly profile on the site.
# 
# Original TODO: links page" \
#   --label "priority:possible,type:link"
# 
# gh issue create \
#   --title "Use github issues instead of TODO.md" \
#   --body "Migrate from text file tracking to GitHub issues for site TODOs.
# 
# Original TODO: technical task" \
#   --label "priority:possible,type:technical"

# Unlikely TODOs
# gh issue create \
#   --title "Try dagger" \
#   --body "Evaluate dagger for potential use.
# 
# Original TODO: technical task" \
#   --label "priority:unlikely,type:technical"
# 
# gh issue create \
#   --title "Link to Amazon profile" \
#   --body "Add link to Amazon profile on the site.
# 
# Original TODO: links page" \
#   --label "priority:unlikely,type:link"
# 
# gh issue create \
#   --title "Calendar view" \
#   --body "Add calendar view functionality to the site.
# 
# Original TODO: technical task" \
#   --label "priority:unlikely,type:technical"
# 
# gh issue create \
#   --title "Geolocation" \
#   --body "Add geolocation features to the site.
# 
# Original TODO: technical task" \
#   --label "priority:unlikely,type:technical"
# 
# gh issue create \
#   --title "Game character links" \
#   --body "Add links to game character profiles.
# 
# Original TODO: links page" \
#   --label "priority:unlikely,type:link"
# 
# gh issue create \
#   --title "Enable github pages for this repo as backup" \
#   --body "Enable GitHub Pages for this repo as a backup way to see the site.
# 
# Note: Tried with FINI and the URLs don't work out well.
# 
# Original TODO: technical task" \
#   --label "priority:unlikely,type:technical"
# 
# gh issue create \
#   --title "Retroblog mysql mailing list posts" \
#   --body "Retroblog mysql mailing list posts.
# 
# Note: Hard to find so far
# 
# Original TODO: content/posts/" \
#   --label "priority:unlikely,type:content"

# Impossible TODOs (creating for archive purposes)
gh issue create \
  --title "Retroblogging bloglines content" \
  --body "Retroblog bloglines content.

Status: Could not find it in the WayBack machine.

Original TODO: Archive - impossible task" \
  --label "priority:impossible,type:content" \
  --assignee "@me"

gh issue create \
  --title "Blog entry on long email announcing departure from OpenX" \
  --body "Write blog entry about the long email announcing departure from OpenX.

Status: Cannot find the email.

Original TODO: Archive - impossible task" \
  --label "priority:impossible,type:content" \
  --assignee "@me"

echo ""
echo "✅ All GitHub issues created successfully!"
echo "You may want to close the 'impossible' issues immediately or use them as archive."
