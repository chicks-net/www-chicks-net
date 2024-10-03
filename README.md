# www-chicks-net

![W3C Validation](https://img.shields.io/w3c-validation/html?targetUrl=https%3A%2F%2Fwww.chicks.net%2F)
[![GitHub branches](https://badgen.net/github/branches/chicks-net/www-chicks-net)](https://github.com/chicks-net/www-chicks-net/)
[![GitHub commits](https://badgen.net/github/commits/chicks-net/www-chicks-net)](https://GitHub.com/chicks-net/www-chicks-net/commit/)
[![GitHub latest commit](https://badgen.net/github/last-commit/chicks-net/www-chicks-net)](https://GitHub.com/chicks-net/www-chicks-net/commit/)
[![GitHub go.mod Go version of a Go module](https://img.shields.io/github/go-mod/go-version/chicks-net/www-chicks-net.svg)](https://github.com/chicks-net/www-chicks-net)
![Dynamic TOML Badge](https://img.shields.io/badge/dynamic/toml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fchicks-net%2Fwww-chicks-net%2Frefs%2Fheads%2Fmain%2Fhugo.toml&query=%24.theme%5B0%5D&label=theme%5B0%5D)

[![ForTheBadge powered-by-electricity](http://ForTheBadge.com/images/badges/powered-by-electricity.svg)](http://ForTheBadge.com)

https://www.chicks.net/ web site

There is [a plan](TODO.md).

## Code of Conduct

Please refer to [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) to learn about our expectations for contributors.

## Thanks

* Hosted by [Flamingo Internet Navigators](https://www.fini.net/).
* Thanks to github for hosting the repo.
* Thanks to neovim for showing that `vi` still has a worthy place in tech, 50 years after `vi`s invention.
* Thanks to the [hugo](https://gohugo.io/) community for the tools and themes that made this possible.

## Development Cycle

1. Start a new branch with `git co -b $branch_name`.
1. Make some new content with `hugo new` or update some other content.
1. Add a commit to the branch.
1. Push to github and create a new Pull Request with `just pr`.
1. Merge the PR with `just merge` which also gets our local repo back to latest `main`.  So we can start the whole process over again.
