[![ReadyStack](https://readystack.dev/logo.svg)](https://readystack.dev)

**Stable, Open-source Releases, Automated** · [readystack.dev](https://readystack.dev)

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-readystack%2Fmastodon-2496ED?logo=docker&logoColor=white)](https://hub.docker.com/r/readystack/mastodon) [![Docker pulls](https://img.shields.io/docker/pulls/readystack/mastodon)](https://hub.docker.com/r/readystack/mastodon) [![Grade at release](https://img.shields.io/badge/grade%20at%20release-A%20%2894%25%29-2ea44f)](https://readystack.dev/products/mastodon) [![Signed: cosign](https://img.shields.io/badge/signed-cosign-2ea44f)](https://readystack.dev/keys/cosign.pub) ![SBOM: SPDX](https://img.shields.io/badge/SBOM-SPDX-2ea44f) ![Provenance: SLSA v1](https://img.shields.io/badge/provenance-SLSA%20v1-2ea44f) ![Offline rebuild: verified](https://img.shields.io/badge/offline%20rebuild-verified-2ea44f)

# Mastodon: ReadyStack build kit

The offline build kit for the Docker image `readystack/mastodon:v4.7.6-CE-ubuntu24.04-r3`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [v4.7.6-CE-ubuntu24.04-r3](https://github.com/readystack-dev/mastodon/releases/tag/v4.7.6-CE-ubuntu24.04-r3)
- Image: [`docker.io/readystack/mastodon:v4.7.6-CE-ubuntu24.04-r3`](https://hub.docker.com/r/readystack/mastodon/tags), manifest digest `sha256:2616072058fe63933e680002b12220a27a3fd14c3fd9edfce8e5933546ff5e83`
- Product page: https://readystack.dev/products/mastodon
- Source and build recipe: https://readystack.dev/products/mastodon/recipe
- Build trail: https://readystack.dev/products/mastodon/trail/v4.7.6-CE-ubuntu24.04-r3
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=mastodon

## The image

One image, three processes, each its own container from the same image: `web` (the default command, puma on port 3000: the web UI and the API; it prepares the database before it starts), `sidekiq` (the job queue) and `streaming` (the streaming API on Node, port 4000). They share PostgreSQL and Redis, which you provide, and the uploaded media in /opt/mastodon/public/system (or S3-compatible storage). A TLS reverse proxy in front sends / to port 3000 and /api/v1/streaming to port 4000, as upstream's nginx example does. Runs as the non-root user mastodon (uid 991).

## This release

- Docker Scout policy grade at release: **A** (94%), graded 2026-11-27 with `docker scout policy` (CLI 1.26.0, docker-default configuration).
  - Docker Scout counts 120 packages with copyleft licences (AGPL, GPL, LGPL, MPL), 114 of them operating-system packages (it counts only packages whose licence it can read; the SBOM lists every component). AGPL: @mastodon/mastodon, @mastodon/streaming.
- Signed with ReadyStack's release key (fingerprint `04daa92344a52dbc`): https://readystack.dev/keys/cosign.pub.
- Runs as a non-root user (`mastodon`).
- Attestations on the image: an SPDX SBOM and SLSA provenance v1.
- Rebuilt from this kit with network egress blocked on 2026-11-27; the rebuilt image digest is the published one.
- Base: Ubuntu 24.04.

The current grade, measured again every day, is on https://readystack.dev/products/mastodon.

Mastodon is distributed under its upstream licence (AGPL-3.0-only); the kit contains upstream's source under that licence, and each vendored component under its own.

## Download

From the [v4.7.6-CE-ubuntu24.04-r3 release](https://github.com/readystack-dev/mastodon/releases/tag/v4.7.6-CE-ubuntu24.04-r3): `ReadyStack-mastodon-v4.7.6-CE-ubuntu24.04-r3.tar.gz` (636.1 MB), SHA-256 `457398a6475e06b8c0bc5c4b8d0137c86e6241a308805857dc0526fca5f76b50`.

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

## Verify and rebuild

The rebuild statement is signed with the ReadyStack release key. Check the signature before you rely on it:

```sh
cosign verify-blob --key https://readystack.dev/keys/cosign.pub \
  --bundle ReadyStack-mastodon-v4.7.6-CE-ubuntu24.04-r3.rebuild.json.sigstore ReadyStack-mastodon-v4.7.6-CE-ubuntu24.04-r3.rebuild.json
```

Unpack with `-p` so file modes are kept, then follow the kit's own README.md and docs/REBUILD.md:

```sh
tar -xpzf ReadyStack-mastodon-v4.7.6-CE-ubuntu24.04-r3.tar.gz
cd v4.7.6-CE-ubuntu24.04-r3
less README.md docs/REBUILD.md
```

The build trail (`ReadyStack-mastodon-v4.7.6-CE-ubuntu24.04-r3.trail.json`, signed the same way, and its Markdown copy) records how this release was built and checked.

## This repository

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/mastodon/recipe. The complete kit is the release download. Each release is a tag here. How to report a vulnerability: [SECURITY.md](SECURITY.md).

## About ReadyStack

**Stable, Open-source Releases, Automated.** ReadyStack releases popular open-source apps every week with every available critical and high security fix applied, plus full documentation, reference data, tests and a build recipe that recreates each release bit-for-bit. Each release is rebuilt from its pinned inputs with the network off, checked against its published digest, signed, and scanned and graded again every day. The images and build kits are free, and ReadyStack is soon to be a nonprofit.

[readystack.dev](https://readystack.dev) · [All products](https://readystack.dev/products.html) · [Build kits on GitHub](https://github.com/readystack-dev) · [Defect log](https://readystack.dev/defects.html) · contact@readystack.dev

— ReadyStack · https://readystack.dev
