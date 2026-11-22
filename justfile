# www-chicks-net justfile

import? '.just/claude.just'
import? '.just/compliance.just'
import? '.just/copilot.just'
import? '.just/cue-verify.just'
import? '.just/example.just'
import? '.just/gh-process.just'
import? '.just/hugo.just'
import? '.just/pr-hook.just'
import? '.just/repo-toml.just'
import? '.just/shellcheck.just'
import? '.just/template-sync.just'
import? '.just/utility.just'

# list recipes (default works without naming it)
[group('example')]
list:
    just --list

# start a new post
[group('Process')]
post branchname: _main_branch
    #!/usr/bin/env bash
    NOW=$(just utcdate)
    git co -b "chicks/post/$NOW-{{ branchname }}"
    hugo new content "content/posts/$NOW-{{ branchname }}.md"

[working-directory: 'content/posts']
[group('Compliance')]
check_images:
    #!/usr/bin/env bash
    set -e
    MISSING=0
    echo "Checking image references in content/posts/*.md..."
    while IFS= read -r line; do
        # Extract filename and image path from grep output
        FILE=$(echo "$line" | cut -d: -f1)
        IMAGE=$(echo "$line" | sed -n 's/.*!\[.*\](\(.*\)).*/\1/p')
        # Convert markdown path to filesystem path
        # Remove leading / and convert /posts/ to content/posts/
        IMGFILE=$(echo "$IMAGE" | sed 's|^/||' | sed 's|^posts/|content/posts/|')
        # Check from repo root
        if [[ ! -f "/Users/chicks/Documents/git/www-chicks-net/$IMGFILE" ]]; then
            echo "{{RED}}Missing image:{{NORMAL}} $FILE references $IMAGE"
            # Extract filename after last dash
            BASENAME=$(basename "$IMAGE")
            SHORTNAME="${BASENAME##*-}"
            # Look for the file in ~/Downloads/Takeout/
            TAKEOUT_SEARCH=$(find ~/Downloads/Takeout/ -type f -name "$SHORTNAME" 2>/dev/null | head -1)
            if [[ -n "$TAKEOUT_SEARCH" ]]; then
                echo "  {{GREEN}}Found in Takeout:{{NORMAL}} $TAKEOUT_SEARCH"
                # Copy with the full filename (including date prefix)
                cp "$TAKEOUT_SEARCH" "$BASENAME"
                echo "  {{GREEN}}Copied to:{{NORMAL}} content/posts/$BASENAME"
            else
                echo "  {{YELLOW}}Not found in Takeout as:{{NORMAL}} $SHORTNAME"
            fi
            MISSING=$((MISSING + 1))
        fi
    done < <(grep '^!\[.*/posts/' ./*.md 2>/dev/null || true)
    if [[ $MISSING -eq 0 ]]; then
        echo "{{GREEN}}All image references verified{{NORMAL}}"
    else
        echo "{{RED}}Found $MISSING missing image(s){{NORMAL}}"
        exit 1
    fi

# Verify a release's cosign signature, SLSA provenance, and GitHub attestations (defaults to latest)
# Usage: just verify-release [v2026.10]
# The default resolves the latest non-prerelease release (gh release view
# skips prereleases), so verifying a throwaway -rc tag requires passing it
# explicitly.
[group('Release')]
verify-release TAG=`gh release view --repo chicks-net/www-chicks-net --json tagName -q .tagName`:
    #!/usr/bin/env bash
    set -euo pipefail

    TAG="{{TAG}}"
    REPO="chicks-net/www-chicks-net"
    BUNDLE="www-chicks-net-${TAG}.tar.gz"
    BASE="https://github.com/${REPO}/releases/download/${TAG}"

    echo "{{BLUE}}Verifying release ${TAG} for ${REPO}...{{NORMAL}}"

    # Check required tools
    for tool in cosign slsa-verifier curl gh; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            echo "{{RED}}Error: '$tool' not found. Install with: brew install $tool{{NORMAL}}"
            exit 1
        fi
    done

    # The attestation flags need a recent gh: --signer-workflow arrived
    # in 2.51.0, --source-ref in 2.68.0 (the hard floor - older gh exits
    # with an unknown-flag error). Versions before 2.102.0 also compare
    # these exact flags loosely (regex/prefix matching, case-insensitive
    # refs - see SECURITY.md), which silently weakens the pinning, so
    # warn instead of fail there.
    read -r GH_MAJOR GH_MINOR <<<"$(gh --version | sed -n 's/^gh version \([0-9][0-9]*\)\.\([0-9][0-9]*\)\..*/\1 \2/p')"
    if [[ -z "${GH_MAJOR:-}" ]]; then
        echo "{{RED}}Error: could not parse gh version from: $(gh --version | head -1){{NORMAL}}"
        exit 1
    fi
    if (( GH_MAJOR < 2 || (GH_MAJOR == 2 && GH_MINOR < 68) )); then
        echo "{{RED}}Error: gh 2.68.0+ required for the attestation flags (found $(gh --version | head -1)){{NORMAL}}"
        exit 1
    fi
    if (( GH_MAJOR == 2 && GH_MINOR < 102 )); then
        echo "{{YELLOW}}Warning: gh 2.102.0+ recommended - older versions compare the signer/source flags loosely (see SECURITY.md){{NORMAL}}"
    fi

    WORKDIR="$(mktemp -d)"
    trap 'rm -rf "$WORKDIR"' EXIT
    cd "$WORKDIR"

    echo "{{GREEN}}Downloading assets for ${TAG}...{{NORMAL}}"
    # Use --fail so curl exits non-zero on 4xx/5xx (e.g. 404) instead of
    # silently saving the GitHub "Not Found" error page, which later makes
    # cosign choke with "invalid character 'N' looking for beginning of value".
    for ASSET in "${BUNDLE}" "${BUNDLE}.bundle" "multiple.intoto.jsonl" "checksums.txt"; do
        if ! curl --fail --location --output "${ASSET}" "${BASE}/${ASSET}"; then
            echo "{{RED}}Error: failed to download ${BASE}/${ASSET} (HTTP error).{{NORMAL}}"
            echo "{{RED}}       Release ${TAG} may have no signed assets attached.{{NORMAL}}"
            echo "{{RED}}       Check: gh release view ${TAG} --repo ${REPO} --json assets -q '.assets[].name'{{NORMAL}}"
            exit 1
        fi
    done

    echo "{{GREEN}}Verifying cosign keyless signature...{{NORMAL}}"
    # Exact-match identity (not regexp): the workflow ref is always a tag
    # here, so the identity is fully known - no wildcarded dots or
    # unanchored matching.
    cosign verify-blob \
        --bundle "${BUNDLE}.bundle" \
        --certificate-identity "https://github.com/${REPO}/.github/workflows/release.yml@refs/tags/${TAG}" \
        --certificate-oidc-issuer "https://token.actions.githubusercontent.com" \
        "${BUNDLE}"

    echo "{{GREEN}}Verifying SLSA build provenance...{{NORMAL}}"
    slsa-verifier verify-artifact \
        --provenance-path multiple.intoto.jsonl \
        --source-uri "github.com/${REPO}" \
        --source-tag "${TAG}" \
        "${BUNDLE}"

    echo "{{GREEN}}Verifying GitHub-native attestations...{{NORMAL}}"
    # gh attestation verify prints nothing when not attached to a TTY but
    # still exits 0 on success - GH_FORCE_TTY keeps the output visible.
    # --signer-workflow pins the trust boundary to this release workflow,
    # --source-ref pins it to this tag, and --deny-self-hosted-runners
    # rejects attestations from runner environments outside GitHub's;
    # together they match the exact-identity cosign check above. Without
    # them, any workflow in the repo (or any ref of this one, or a
    # self-hosted run of it) could have produced the attestation.
    GH_FORCE_TTY=1 gh attestation verify "${BUNDLE}" \
        --repo "${REPO}" \
        --signer-workflow "${REPO}/.github/workflows/release.yml" \
        --source-ref "refs/tags/${TAG}" \
        --deny-self-hosted-runners
    # checksums.txt is itself an attestation subject; verifying it directly
    # means the file that pins the bundle and SBOM digests is independently
    # attested (the SLSA steps verify the same subjects separately). The
    # SBOM is a subject too but is deliberately not verified here - its
    # digest is pinned by the attested checksums.txt and the recipe never
    # downloads it.
    GH_FORCE_TTY=1 gh attestation verify checksums.txt \
        --repo "${REPO}" \
        --signer-workflow "${REPO}/.github/workflows/release.yml" \
        --source-ref "refs/tags/${TAG}" \
        --deny-self-hosted-runners

    echo "{{GREEN}}Verifying checksums.txt...{{NORMAL}}"
    # checksums.txt is a SLSA subject alongside the bundle, so the
    # provenance attests it too - verifying it against the provenance
    # gives it trust beyond a same-release comparison, which only
    # catches corruption.
    slsa-verifier verify-artifact \
        --provenance-path multiple.intoto.jsonl \
        --source-uri "github.com/${REPO}" \
        --source-tag "${TAG}" \
        checksums.txt

    echo "{{GREEN}}Verifying bundle hash against checksums.txt...{{NORMAL}}"
    # With checksums.txt itself attested, regenerate the bundle hash
    # and compare against the (now trusted) file. awk matches the exact
    # filename - grep -E would treat the dots in the bundle name as
    # wildcards.
    EXPECTED="$(awk -v f="${BUNDLE}" '$2==f {print $1}' checksums.txt)"
    # sha256sum is GNU coreutils (absent on macOS); fall back to shasum -a 256
    if command -v sha256sum >/dev/null 2>&1; then
        ACTUAL="$(sha256sum "${BUNDLE}" | awk '{print $1}')"
    else
        ACTUAL="$(shasum -a 256 "${BUNDLE}" | awk '{print $1}')"
    fi
    if [[ "$EXPECTED" != "$ACTUAL" ]]; then
        echo "{{RED}}Checksum mismatch: expected $EXPECTED, got $ACTUAL{{NORMAL}}"
        exit 1
    fi

    echo "{{GREEN}}All signature and provenance checks passed for ${TAG}!{{NORMAL}}"
