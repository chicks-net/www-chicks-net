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

Findings from either should be addressed substantively where possible.
Otherwise, add an ignore/suppression comment explaining why, so check results
stay clean.

## Verifying Releases

Each tagged release (e.g. `v2026.10`) ships an asset bundle
(`www-chicks-net-<tag>.tar.gz` containing the rendered site from `public/` -
the exact files deployed to <https://www.chicks.net>), a `checksums.txt` file,
a cosign keyless signature (`.bundle`), an SBOM (`.sbom.json`), and an SLSA
provenance attestation (`multiple.intoto.jsonl`). The SBOM is an unsigned
inventory of the bundle's contents; the cosign signature and `checksums.txt`
cover the bundle; the SLSA provenance covers both the bundle and
`checksums.txt`. Releases published before the signing workflow landed
(before `v2026.11`) have no signed assets; `just verify-release` against them
fails with a download error, which is expected.

### Quick verify with just

```bash
# Defaults to the latest release; pass a tag to verify a specific one.
just verify-release
just verify-release v2026.10
```

### Verify the asset signature with cosign

```bash
# Replace v2026.10 with the tag you want to verify.
TAG="v2026.10"
curl -L -O "https://github.com/chicks-net/www-chicks-net/releases/download/${TAG}/www-chicks-net-${TAG}.tar.gz"
curl -L -O "https://github.com/chicks-net/www-chicks-net/releases/download/${TAG}/www-chicks-net-${TAG}.tar.gz.bundle"

cosign verify-blob \
  --bundle www-chicks-net-${TAG}.tar.gz.bundle \
  --certificate-identity "https://github.com/chicks-net/www-chicks-net/.github/workflows/release.yml@refs/tags/${TAG}" \
  --certificate-oidc-issuer "https://token.actions.githubusercontent.com" \
  www-chicks-net-${TAG}.tar.gz
```

### Verify SLSA build provenance

```bash
TAG="v2026.10"
curl -L -O "https://github.com/chicks-net/www-chicks-net/releases/download/${TAG}/www-chicks-net-${TAG}.tar.gz"
curl -L -O "https://github.com/chicks-net/www-chicks-net/releases/download/${TAG}/multiple.intoto.jsonl"

slsa-verifier verify-artifact \
  --provenance-path multiple.intoto.jsonl \
  --source-uri github.com/chicks-net/www-chicks-net \
  --source-tag "${TAG}" \
  www-chicks-net-${TAG}.tar.gz
```

The signature is produced via keyless signing using GitHub Actions OIDC
identities, so there are no long-lived signing keys to trust or rotate - you
only trust the Sigstore Fulcio certificate chain and the exact workflow
identity shown in the command above.

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
