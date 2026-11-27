# Mastodon v4.7.6 — ReadyStack release `v4.7.6-CE-ubuntu24.04-r3`

Generated 2026-11-27 from this release's build records and strategy. Statements that come from a single record name it in brackets; the others come from this release's strategy and build log.

## Release

- **Image:** `readystack/mastodon:v4.7.6-CE-ubuntu24.04-r3` (linux/amd64). Index digest `sha256:ac98c3e1e30a541ee5541edb849c8ae399edd797dccc34576780a522bfa48768` [`docs/provenance/LOCKED_DIGEST.txt`].
- **Image manifest digest:** `sha256:2616072058fe63933e680002b12220a27a3fd14c3fd9edfce8e5933546ff5e83` [`TARGET_DIGEST.txt`].
- **Upstream:** Mastodon v4.7.6 built from source at `v4.7.6` of https://github.com/mastodon/mastodon — upstream notes: https://github.com/mastodon/mastodon/releases/tag/v4.7.6 [`docs/provenance/BUILD_RECIPE.json`].
- **Base image:** `ubuntu:24.04`; runtime user `mastodon`.
- **Build:** `source-rebuild-ruby`, compiled offline with `--network=none`.
- **Supersedes:** ReadyStack release `v4.7.6-CE-ubuntu24.04-r2`.

## What changed in this release

- Upstream version unchanged (v4.7.6); ReadyStack rebuild.
- Mastodon v4.7.6 is unchanged from the release this supersedes (v4.7.6-CE-ubuntu24.04-r2); this release rebuilds it. Changes: libexpat1 moves from 2.6.1-2ubuntu0.6 to 2.6.1-2ubuntu0.7 (USN-9196-1). Settings, ports and data volumes are those of v4.7.6-CE-ubuntu24.04-r2: replace the container with this image on the same volumes.

## Security status at release (measured 2026-11-27)

- **Docker Scout:** 0 fixable critical/high vulnerabilities; runs as `mastodon` (non-root); SBOM + provenance attestations present (SPDX SBOM + SLSA v1) [`docs/provenance/SCOUT_VERDICT.json`].
- **OSV cross-check:** no fixable critical/high vulnerability beyond Docker Scout's findings.
- **Signature:** cosign signature verified by ReadyStack's release gate before publishing; check it yourself with `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/mastodon:v4.7.6-CE-ubuntu24.04-r3` (signatures are recorded in the public Sigstore transparency log).
- **ReadyStack release check at release:** passed (ReadyStack's own test, not a Docker Scout grade). Vulnerabilities are disclosed every day and the image never changes, so it is re-checked daily, beside Docker Scout's own dated grade, at https://readystack.dev/queue.
- **Before exposing this service:** Mastodon expects a TLS reverse proxy: it redirects plain http to https, sets secure cookies and HSTS, and answers only for LOCAL_DOMAIN. Ports 3000 and 4000 serve plain http: publish them only to that proxy. Keep SECRET_KEY_BASE and the ACTIVE_RECORD_ENCRYPTION_* keys secret and backed up: losing them makes encrypted data unreadable.

## Reproducibility

Rebuilds offline from this archive to the identical image digest `sha256:2616072058fe63933e680002b12220a27a3fd14c3fd9edfce8e5933546ff5e83`: run `./BUILD_OFFLINE.sh`, then `./VERIFY_OFFLINE.sh` (add `--online` to confirm the Docker Hub tag holds the same digest). Before publishing, ReadyStack rebuilt the kit with `./BUILD_OFFLINE.sh` and compared the result with the published digest [`docs/provenance/REPRO_VERIFICATION.json`], then ran `./BUILD_OFFLINE.sh` and `./VERIFY_OFFLINE.sh` from this archive (without `--online`).

## Validation

- 6 of 6 use cases passed (6 authored) against the running image [`docs/validation/test-results.json`].

## Known issues

- None found (reviewed by held semantic review (Claude) on 2026-11-27).

## Verify this archive

```
sha256sum -c CHECKSUMS.sha256
./BUILD_OFFLINE.sh && ./VERIFY_OFFLINE.sh --online
cosign verify --key https://readystack.dev/keys/cosign.pub readystack/mastodon:v4.7.6-CE-ubuntu24.04-r3
```

ReadyStack records every signature in the public Sigstore transparency log (Rekor), so the command needs no extra flags.

