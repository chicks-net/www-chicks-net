# .just/pr-hook.just

# called from pr recipe in .just/gh-process.just

# run this before creating a PR
_pr-hook:
    just hugo
