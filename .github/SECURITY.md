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
provenance attestation (`multiple.intoto.jsonl`). The release workflow also
registers GitHub-native artifact attestations, so `gh attestation verify`
works on the bundle, SBOM, and checksums. The SBOM is an unsigned
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
# Replace v2026.10 with the tag you want to verify. -f: fail on HTTP
# errors instead of saving a 404 page as the asset.
TAG="v2026.10"
curl -fLO "https://github.com/chicks-net/www-chicks-net/releases/download/${TAG}/www-chicks-net-${TAG}.tar.gz"
curl -fLO "https://github.com/chicks-net/www-chicks-net/releases/download/${TAG}/www-chicks-net-${TAG}.tar.gz.bundle"

cosign verify-blob \
  --bundle "www-chicks-net-${TAG}.tar.gz.bundle" \
  --certificate-identity "https://github.com/chicks-net/www-chicks-net/.github/workflows/release.yml@refs/tags/${TAG}" \
  --certificate-oidc-issuer "https://token.actions.githubusercontent.com" \
  "www-chicks-net-${TAG}.tar.gz"
```

### Verify SLSA build provenance

```bash
TAG="v2026.10"
curl -fLO "https://github.com/chicks-net/www-chicks-net/releases/download/${TAG}/www-chicks-net-${TAG}.tar.gz"
curl -fLO "https://github.com/chicks-net/www-chicks-net/releases/download/${TAG}/multiple.intoto.jsonl"

slsa-verifier verify-artifact \
  --provenance-path multiple.intoto.jsonl \
  --source-uri github.com/chicks-net/www-chicks-net \
  --source-tag "${TAG}" \
  "www-chicks-net-${TAG}.tar.gz"
```

### Verify the GitHub-native attestation

```bash
# Replace v2026.10 with the tag you want to verify. -f: fail on HTTP
# errors instead of saving a 404 page as the asset.
TAG="v2026.10"
curl -fLO "https://github.com/chicks-net/www-chicks-net/releases/download/${TAG}/www-chicks-net-${TAG}.tar.gz"
curl -fLO "https://github.com/chicks-net/www-chicks-net/releases/download/${TAG}/checksums.txt"

# --signer-workflow pins the attestation to the release workflow,
# --source-ref pins it to this tag, and --deny-self-hosted-runners
# rejects attestations from self-hosted runners, so only this release
# workflow, at this tag, on GitHub's own runners can verify.
gh attestation verify "www-chicks-net-${TAG}.tar.gz" \
  --repo chicks-net/www-chicks-net \
  --signer-workflow chicks-net/www-chicks-net/.github/workflows/release.yml \
  --source-ref "refs/tags/${TAG}" \
  --deny-self-hosted-runners

# checksums.txt is itself an attestation subject, so it verifies too.
gh attestation verify checksums.txt \
  --repo chicks-net/www-chicks-net \
  --signer-workflow chicks-net/www-chicks-net/.github/workflows/release.yml \
  --source-ref "refs/tags/${TAG}" \
  --deny-self-hosted-runners
```

The signature is produced via keyless signing using GitHub Actions OIDC
identities, so there are no long-lived signing keys to trust or rotate - you
only trust the Sigstore Fulcio certificate chain and the exact workflow
identity shown in the command above.

These flags need `gh` 2.68.0 or newer (`--signer-workflow` arrived in
2.51.0, `--source-ref` in 2.68.0). Prefer `gh` 2.102.0 or newer: older
releases compared these exact flags loosely - `--signer-workflow` as an
unescaped regex (CVE-2026-64655, fixed in 2.97.0) and as an unchecked
prefix, and `--source-ref` case-insensitively (GHSA-wjmr-j3rp-mh2g,
GHSA-4mq3-hpgx-9cx8, fixed in 2.102.0) - so the pinning above is only as
strong as the `gh` running it. `just verify-release` enforces the same
floors, so update the two together.

The SBOM is an attestation subject too but is deliberately not verified
directly here: its digest is pinned by the attested `checksums.txt`. To
check it against that file, run `shasum -a 256 --check checksums.txt`
(macOS) or `sha256sum -c checksums.txt` (Linux).

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
