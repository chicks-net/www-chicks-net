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
test:
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

# PR create
[group('Process')]
pr: on_a_branch
    hugo
    git stp
    git pushup
    gh pr create --title "{{ last_commit_message }}" --body "{{ last_commit_message }} (Automated in 'justfile'.)"

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
      echo "You are on branch {{ release_branch }} (the release branch) so you are not ready to start a PR."
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
