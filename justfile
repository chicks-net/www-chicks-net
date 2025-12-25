# www-chicks-net justfile

import? '.just/utility.just'
import? '.just/example.just'
import? '.just/hugo.just'
import? '.just/gh-process.just'
import? '.just/pr-hook.just'
import? '.just/shellcheck.just'

# list recipes (default works without naming it)
[group('example')]
list:
    just --list

# start a new post
[group('Process')]
post branchname: _main_branch
    #!/usr/bin/env bash
    NOW=$(just utcdate)
    git co -b "chicks/post/$NOW-{{ branchname }}"
    hugo new content "content/posts/$NOW-{{ branchname }}.md"

# verify metadata with CUE
[group('Compliance')]
cue_verify:
    cue vet docs/cue/meta.cue .fini/meta.toml
    @echo "{{GREEN}}cue verify passed{{NORMAL}}"

[working-directory: 'content/posts']
[group('Compliance')]
check_images:
    #!/usr/bin/env bash
    set -e
    MISSING=0
    echo "Checking image references in content/posts/*.md..."
    while IFS= read -r line; do
        # Extract filename and image path from grep output
        FILE=$(echo "$line" | cut -d: -f1)
        IMAGE=$(echo "$line" | sed -n 's/.*!\[.*\](\(.*\)).*/\1/p')
        # Convert markdown path to filesystem path
        # Remove leading / and convert /posts/ to content/posts/
        IMGFILE=$(echo "$IMAGE" | sed 's|^/||' | sed 's|^posts/|content/posts/|')
        # Check from repo root
        if [[ ! -f "/Users/chicks/Documents/git/www-chicks-net/$IMGFILE" ]]; then
            echo "{{RED}}Missing image:{{NORMAL}} $FILE references $IMAGE"
            # Extract filename after last dash
            BASENAME=$(basename "$IMAGE")
            SHORTNAME=$(echo "$BASENAME" | sed 's/.*-//')
            # Look for the file in ~/Downloads/Takeout/
            TAKEOUT_SEARCH=$(find ~/Downloads/Takeout/ -type f -name "$SHORTNAME" 2>/dev/null | head -1)
            if [[ -n "$TAKEOUT_SEARCH" ]]; then
                echo "  {{GREEN}}Found in Takeout:{{NORMAL}} $TAKEOUT_SEARCH"
                # Copy with the full filename (including date prefix)
                cp "$TAKEOUT_SEARCH" "$BASENAME"
                echo "  {{GREEN}}Copied to:{{NORMAL}} content/posts/$BASENAME"
            else
                echo "  {{YELLOW}}Not found in Takeout as:{{NORMAL}} $SHORTNAME"
            fi
            MISSING=$((MISSING + 1))
        fi
    done < <(grep '^!\[.*/posts/' *.md 2>/dev/null || true)
    if [[ $MISSING -eq 0 ]]; then
        echo "{{GREEN}}All image references verified{{NORMAL}}"
    else
        echo "{{RED}}Found $MISSING missing image(s){{NORMAL}}"
        exit 1
    fi
