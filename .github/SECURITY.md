# Security Policy

## Scope

This repository contains the source for my personal static website at
<https://www.chicks.net>, built with Hugo and the PaperMod theme. There is no
server-side application, database, or user data. Security considerations are
limited to:

- Secrets or tokens accidentally committed to the repo
- Malicious content submitted via pull requests or issues
- Supply-chain risks in the Hugo theme or modules

Vulnerabilities in Hugo itself, the PaperMod theme, GitHub infrastructure, or
third-party CDN assets should be reported to their respective upstream projects,
not here.

## Automated Checks

Every pull request runs automated security scans via GitHub Actions:

- [gitleaks](https://github.com/gitleaks/gitleaks-action) scans commits for
  accidentally committed secrets or tokens (see
  [`.github/workflows/gitleaks.yml`](./workflows/gitleaks.yml)).
- [checkov](https://www.checkov.io/) scans configuration and infrastructure-as-code
  files for misconfigurations (see
  [`.github/workflows/checkov.yml`](./workflows/checkov.yml)).

Findings from either should be addressed substantively where possible
and otherwise add an ingore comment to the check results are clean.

## Reporting a Vulnerability

Please do **not** open a public issue for security concerns. Instead, email me
privately at <chicks.net@gmail.com>.
I'll acknowledge reports within 72 hours and aim to address verified issues on
the latest `main` branch as time permits.

## Supported Versions

This is a personal hobby project with no SLA. Only the latest `main` branch
receives updates.

## Rewards

No bounties or rewards are offered. Thanks in advance for helping keep the site
safe.
