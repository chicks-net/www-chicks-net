# www-chicks-net justfile

# some useful variables
host := `uname -n`
release_branch := "main"

# thanks to https://stackoverflow.com/a/7293026/2002471 for the perfect git incantation
last_commit_message := `git log -1 --pretty=%B | grep '.'`

# default works without naming it
[group('example')]
whatever:
  just --list

# goofing off
[group('example')]
cause:
  @echo haha on {{host}} running {{os()}}
  @echo "invocation_dir={{invocation_directory()}}"
  git stp

# escape from branch, back go starting point
[group('Process')]
sync:
  git checkout main
  git pull

# under development
[group('Process')]
pr:
  just on_a_branch # confirm or quit
  hugo
  git stp
  git pushup
  gh pr create --title "{{last_commit_message}}" --body "{{last_commit_message}} (Automated in 'justfile'.)"

# merge PR and return to starting point
[group('Process')]
merge:
  gh pr merge -s
  just sync

#test:
#  just on_a_branch
#  echo gh pr create --title "{{last_commit_message}}" --body "{{last_commit_message}}\nAutomated in 'justfile'."

# error if not on a git branch
[no-cd, group('sanity check')]
on_a_branch:
  #!/bin/bash

  # thanks to https://stackoverflow.com/a/12142066/2002471

  if [[ $(git rev-parse --abbrev-ref HEAD) == "main" ]]; then
    echo "You are on branch {{release_branch}} (the release branch) so you are not ready to start a PR."
    exit 100
  fi

# Thanks to https://apple.stackexchange.com/a/422206/210526
# remove GPS information from an image
[no-cd, group('Utility')]
gps_rm image:
  exiftool -overwrite_original -gps:all= {{image}}

# from ancient html/Makefile
#favicon.ico: img/favicon.pnm
#	ppmtowinicon -output favicon.ico favicon.pnm 
