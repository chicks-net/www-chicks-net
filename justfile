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
    NOW=`just utcdate`
    git co -b "chicks/post/$NOW-{{ branchname }}"
    hugo new content "content/posts/$NOW-{{ branchname }}.md"
