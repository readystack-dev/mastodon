# Provenance — Mastodon (`v4.7.6-CE-ubuntu24.04-r2`)

Every item below is copied from a record in this archive; the record is named in brackets.

## Source

- Upstream repository: https://github.com/mastodon/mastodon
- Revision built: `v4.7.6` (commit `a593c9420d2ff4664d448a9cb71bf8ed4ff0c29a`)
- Source tree: `66fa0a9ee21b341cf1bde47e22d905c3296233c69d950ee483bbcb7209929066` over 9932 files [`docs/provenance/SOURCE_TREE_HASH.json`]
- Community Edition only: enterprise code is removed or refused before the build (CE audit at acquire).

## Build

- Method: `source-rebuild-ruby`; base image `ubuntu:24.04`
- Compiled with `--network=none` from vendored source, dependencies and base images; BuildKit pinned to `moby/buildkit:v0.31.2` (shipped in `toolchain/`).
- SOURCE_DATE_EPOCH: `1795543185` [`SOURCE_DATE_EPOCH.txt`]
- Frozen inputs: [`docs/provenance/FREEZE_MANIFEST.json`], build recipe: [`docs/provenance/BUILD_RECIPE.json`].

## Output

- Published image: `readystack/mastodon:v4.7.6-CE-ubuntu24.04-r2` — index digest `sha256:9f066caf558c5065f3e0834e80d648fdc41dcf43a0c5c67155d4b9b3bc644964` [`docs/provenance/LOCKED_DIGEST.txt`]
- linux/amd64 image digest `sha256:1938eb27869ae3e5a7961fc384f717b03bf3bccbd35c60da2d3da8d2111506f4` — reproduced from this archive before publishing [`docs/provenance/REPRO_VERIFICATION.json`].

## Attestations and signature

- SBOM + SLSA provenance attached to the image: attached: an SPDX SBOM and SLSA v1 provenance [`docs/provenance/SCOUT_VERDICT.json`]
- cosign signature by the ReadyStack release key: verified before publishing. Check it: `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/mastodon:v4.7.6-CE-ubuntu24.04-r2`

## Pinned inputs, and why

- 28 pinned inputs, each with where it came from, why this one, how it was checked and when it was decided: `docs/PINS.md` [`docs/provenance/PINS.json`] (upstream source 2, base and build images 1, image digests 1, language runtimes and toolchains 2, dependency versions readystack sets 9, files the vendor stage downloads 2, pins in the kit's dockerfiles 6, readystack's build engine 1, dependencies upstream chose 2, services the release checks run beside 2).

## Build trail

- How this release passed through the ReadyStack harness, record by record (every chain, drive, stage, review round, defect and check, each naming the record it is copied from): `ReadyStack-mastodon-v4.7.6-CE-ubuntu24.04-r2.trail.json`, published beside this archive and signed with the release key (`ReadyStack-mastodon-v4.7.6-CE-ubuntu24.04-r2.trail.json.sigstore`), and readable at https://readystack.dev/products/mastodon/trail/v4.7.6-CE-ubuntu24.04-r2.

