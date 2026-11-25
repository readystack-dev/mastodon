# Mastodon: ReadyStack build kit

The offline build kit for the Docker image `readystack/mastodon:v4.7.6-CE-ubuntu24.04-r2`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [v4.7.6-CE-ubuntu24.04-r2](https://github.com/readystack-dev/mastodon/releases/tag/v4.7.6-CE-ubuntu24.04-r2)
- Image: [`docker.io/readystack/mastodon:v4.7.6-CE-ubuntu24.04-r2`](https://hub.docker.com/r/readystack/mastodon/tags), manifest digest `sha256:1938eb27869ae3e5a7961fc384f717b03bf3bccbd35c60da2d3da8d2111506f4`
- Product page: https://readystack.dev/products/mastodon
- Source and build recipe: https://readystack.dev/products/mastodon/recipe
- Build trail: https://readystack.dev/products/mastodon/trail/v4.7.6-CE-ubuntu24.04-r2
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=mastodon

## The image

One image, three processes, each its own container from the same image: `web` (the default command, puma on port 3000: the web UI and the API; it prepares the database before it starts), `sidekiq` (the job queue) and `streaming` (the streaming API on Node, port 4000). They share PostgreSQL and Redis, which you provide, and the uploaded media in /opt/mastodon/public/system (or S3-compatible storage). A TLS reverse proxy in front sends / to port 3000 and /api/v1/streaming to port 4000, as upstream's nginx example does. Runs as the non-root user mastodon (uid 991).

## This release

- Docker Scout policy grade at release: **A** (94%), graded 2026-11-25 with `docker scout policy` (CLI 1.26.0, docker-default configuration).
  - Docker Scout counts 120 packages with copyleft licences (AGPL, GPL, LGPL, MPL), 114 of them operating-system packages (it counts only packages whose licence it can read; the SBOM lists every component). AGPL: @mastodon/mastodon, @mastodon/streaming.
- Signed with ReadyStack's release key (fingerprint `04daa92344a52dbc`): https://readystack.dev/keys/cosign.pub.
- Runs as a non-root user (`mastodon`).
- Attestations on the image: an SPDX SBOM and SLSA provenance v1.
- Rebuilt from this kit with network egress blocked on 2026-11-25; the rebuilt image digest is the published one.
- Base: Ubuntu 24.04.

The current grade, measured again every day, is on https://readystack.dev/products/mastodon.

Mastodon is distributed under its upstream licence (AGPL-3.0-only); the kit contains upstream's source under that licence, and each vendored component under its own.

## Download

From the [v4.7.6-CE-ubuntu24.04-r2 release](https://github.com/readystack-dev/mastodon/releases/tag/v4.7.6-CE-ubuntu24.04-r2): `ReadyStack-mastodon-v4.7.6-CE-ubuntu24.04-r2.tar.gz` (636.1 MB), SHA-256 `856d7b812263d44e01becf833a89e3c0a9207f34cf2a6dfe3f28a5dfb7e4da28`.

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

## Verify and rebuild

The rebuild statement is signed with the ReadyStack release key. Check the signature before you rely on it:

```sh
cosign verify-blob --key https://readystack.dev/keys/cosign.pub \
  --bundle ReadyStack-mastodon-v4.7.6-CE-ubuntu24.04-r2.rebuild.json.sigstore ReadyStack-mastodon-v4.7.6-CE-ubuntu24.04-r2.rebuild.json
```

Unpack with `-p` so file modes are kept, then follow the kit's own README.md and docs/REBUILD.md:

```sh
tar -xpzf ReadyStack-mastodon-v4.7.6-CE-ubuntu24.04-r2.tar.gz
cd v4.7.6-CE-ubuntu24.04-r2
less README.md docs/REBUILD.md
```

The build trail (`ReadyStack-mastodon-v4.7.6-CE-ubuntu24.04-r2.trail.json`, signed the same way, and its Markdown copy) records how this release was built and checked.

## This repository

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/mastodon/recipe. The complete kit is the release download. Each release is a tag here.

— ReadyStack · https://readystack.dev
