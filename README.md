# www-chicks-net

![W3C Validation](https://img.shields.io/w3c-validation/html?targetUrl=https%3A%2F%2Fwww.chicks.net%2F)
[![GitHub branches](https://badgen.net/github/branches/chicks-net/www-chicks-net)](https://github.com/chicks-net/www-chicks-net/)
[![GitHub commits](https://badgen.net/github/commits/chicks-net/www-chicks-net)](https://GitHub.com/chicks-net/www-chicks-net/commit/)
[![GitHub latest commit](https://badgen.net/github/last-commit/chicks-net/www-chicks-net)](https://GitHub.com/chicks-net/www-chicks-net/commit/)
[![GitHub go.mod Go version of a Go module](https://img.shields.io/github/go-mod/go-version/chicks-net/www-chicks-net.svg)](https://github.com/chicks-net/www-chicks-net)
![Dynamic TOML Badge](https://img.shields.io/badge/dynamic/toml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fchicks-net%2Fwww-chicks-net%2Frefs%2Fheads%2Fmain%2Fhugo.toml&query=%24.theme%5B0%5D&label=theme%5B0%5D)

[![ForTheBadge powered-by-electricity](http://ForTheBadge.com/images/badges/powered-by-electricity.svg)](http://ForTheBadge.com)

The [https://www.chicks.net/](https://www.chicks.net) web site is built and
maintained with [Hugo](https://gohugo.io/)!

There is [a plan](TODO.md) -- that is moving at a glacial yet humane speed.

## Code of Conduct

Please refer to the [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) to learn about our
expectations for contributors.  I would guess the chances of collaboration on
this repo are so small as to be unmeasurable, but this is a trivial compliance
thing to check off and I'm trying to get all of my repos closer to best
practices.

## Thanks

- Hosted by [Flamingo Internet Navigators](https://www.fini.net/).
- Thanks to github for hosting the git repo.
- Thanks to neovim for showing that `vi` still has a worthy place in tech, 50
  years after `vi`s invention.
- Thanks to the [hugo](https://gohugo.io/) community for the tools and themes
  that made this possible.
- Thanks to [just](https://just.systems/man/en/) and
  [GitHub CLI](https://cli.github.com/) for fostering automation.

## Just is awesome

Check out the [`justfile`](https://github.com/chicks-net/www-chicks-net/blob/main/justfile)
for all of the ways to remember less and do more.  Watching
[my youtube video on just](https://youtu.be/m7ZCnGnYyvs?si=QNvUZJiGo20FVdnD)
would be a great way to see what I'm trying to do here.
Between [just](https://just.systems/man/en/) and
[GitHub CLI](https://cli.github.com/) you can get a way to manage the full
development cycle from the command line.

The resulting development cycle is as toil-free as I can imagine making it:

### Development Cycle

1. Start a new branch with `just branch $branch_name` or `just post $title_slug`.
1. If making a post, edit the template built by `just post`.  Otherwise, make
   some change.
1. Add a commit to the branch.
1. Push to github and create a new Pull Request with `just pr`.
1. Merge the PR with `just merge` which also gets our local repo back to latest
   `main`.  So we can start the whole process over again.

I love that I can do all of this from the terminal, but the web UX is there if you still want it.
