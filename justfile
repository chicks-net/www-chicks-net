# www-chicks-net justfile

# some useful variables
host := `uname -n`
release_branch := "main"

# thanks to https://stackoverflow.com/a/7293026/2002471 for the perfect git incantation
last_commit_message := `git log -1 --pretty=%B | grep '.'`

# list recipes (default works without naming it)
[group('example')]
list:
    just --list

# display date with reversed background
[group('example')]
color-test:
    #!/usr/bin/env bash
    NOW=`just utcdate`
    echo "NOW={{ INVERT }}$NOW{{ BG_WHITE }}"

# goofing off
[group('example')]
cause:
    @echo haha on {{ host }} running {{ os() }}
    @echo "invocation_dir={{ invocation_directory() }}"
    git stp

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
    sleep 10
    gh pr checks --watch

# merge PR and return to starting point
[group('Process')]
merge:
    gh pr merge -s
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

# clean out references to old hugo modules
[group('Process')]
hugo_mod_tidy:
    hugo mod tidy

# update hugo modules
[group('Process')]
hugo_mod_update:
    hugo mod get -u

# view PR in web browser
[group('Process')]
prweb: on_a_branch
    gh pr view --web

# run hugo from the top of the repo
[group('Process')]
hugo:
    #!/usr/bin/env bash
    [[ -e public.prev ]] && exit 5
    echo "{{GREEN}}no prev directory, so safe to rebuild with hugo...{{NORMAL}}"

    set -euxo pipefail # strict mode

    mv public public.prev

    TZ=America/Los_Angeles hugo

    git stp

    rm -rf public.prev

# run hugo server
[group('Process')]
server:
    #!/usr/bin/env bash
    TZ=America/Los_Angeles hugo server
    just hugo # cleanup after server!

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

# remove GPS information from an image
[group('Utility')]
[no-cd]
gps_rm image:
    exiftool -overwrite_original -gps:all= {{ image }}

# from ancient html/Makefile
#favicon.ico: img/favicon.pnm
#	ppmtowinicon -output favicon.ico favicon.pnm

# print UTC date/time
[group('Utility')]
[no-cd]
@utcdatetime:
	TZ=UTC date

# print UTC date in ISO format
[group('Utility')]
[no-cd]
@utcdate:
	TZ=UTC date +"%Y-%m-%d"

# test network speed
[group('Utility')]
[no-cd]
[macos]
speedtest:
	networkQuality
