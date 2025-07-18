# www-chicks-net justfile

import? '.just/utility.just'
import? '.just/example.just'
import? '.just/hugo.just'

# some useful variables
host := `uname -n`
release_branch := "main"

# thanks to https://stackoverflow.com/a/7293026/2002471 for the perfect git incantation
last_commit_message := `git log -1 --pretty=%B | grep '.'`

# list recipes (default works without naming it)
[group('example')]
list:
    just --list

# escape from branch, back to starting point
[group('Process')]
sync:
    git checkout main
    git pull
    git stp

# PR create
[group('Process')]
pr: on_a_branch
    #!/usr/bin/env bash
    set -euxo pipefail # strict mode

    just hugo
    git stp
    git pushup

    set +x # leave tracing off...

    bodyfile=$(mktemp /tmp/justfile.XXXXXX)

    echo "## Done:" >> $bodyfile
    echo "" >> $bodyfile
    echo "- {{ last_commit_message }}" >> $bodyfile
    echo "" >> $bodyfile
    echo "" >> $bodyfile
    echo "(Automated in \`justfile\`.)" >> $bodyfile

    echo ''
    cat "$bodyfile"
    echo ''

    gh pr create --title "{{ last_commit_message }}" --body-file "$bodyfile"
    rm "$bodyfile"

    if [[ ! -e ".github/workflows" ]]; then
        echo "{{BLUE}}there are no workflows in this repo so there are no PR checks to watch{{NORMAL}}"
        exit 0
    fi

    echo "{{BLUE}}sleeping for 10s because github is lazy with their API{{NORMAL}}"
    sleep 10
    gh pr checks --watch -i 4

# merge PR and return to starting point
[group('Process')]
merge:
    gh pr merge -s -d
    just sync

# start a new post
[group('Process')]
post branchname: main_branch
    #!/usr/bin/env bash
    NOW=`just utcdate`
    git co -b "chicks/post/$NOW-{{ branchname }}"
    hugo new content "content/posts/$NOW-{{ branchname }}.md"

# start a new branch
[group('Process')]
branch branchname: main_branch
    #!/usr/bin/env bash
    NOW=`just utcdate`
    git co -b "chicks/$NOW-{{ branchname }}"

# view PR in web browser
[group('Process')]
prweb: on_a_branch
    gh pr view --web

#test: on_a_branch
#  echo gh pr create --title "{{last_commit_message}}" --body "{{last_commit_message}}\nAutomated in 'justfile'."
# TODO: sanity check for making sure there are commits on the branch

# error if not on a git branch
[group('sanity check')]
[no-cd]
on_a_branch:
    #!/bin/bash

    # thanks to https://stackoverflow.com/a/12142066/2002471

    if [[ $(git rev-parse --abbrev-ref HEAD) == "main" ]]; then
      echo "{{RED}}You are on branch '{{ release_branch }}' (the release branch) so you are not ready to start a PR.{{NORMAL}}"
      exit 100
    fi

# error if not on the release branch
[group('sanity check')]
[no-cd]
main_branch:
    #!/bin/bash

    # thanks to https://stackoverflow.com/a/12142066/2002471

    if [[ ! $(git rev-parse --abbrev-ref HEAD) == "main" ]]; then
      echo "You are on a branch that is not the release branch so you are not ready to start a new branch."
      exit 100
    fi

# Thanks to https://apple.stackexchange.com/a/422206/210526

# print UTC date in ISO format
[group('Utility')]
[no-cd]
@utcdate:
	TZ=UTC date +"%Y-%m-%d"
