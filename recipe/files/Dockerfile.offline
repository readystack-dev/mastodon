# GENERATED L-009 hermetic Ruby build (--network=none, SBOM+SLSA-attestation-producing).
# Compiles CRuby 4.0.10 from the vendored ruby-lang.org tarball and the native gems from vendor/cache, then
# copies Ruby + the installed bundle onto the pinned base with only runtime debs: no compiler, headers or Node.
FROM ubuntu:24.04@sha256:9c7f200c07e3d4a03e7249d2c16bf66a51120fb876aa2242cf31451412543289 AS rubybuild
ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8
RUN --mount=type=bind,source=vendored/debs,target=/tmp/debs --mount=type=bind,source=vendored/build-debs,target=/tmp/bdebs \
    set --; for f in /tmp/debs/*.deb /tmp/bdebs/*.deb; do [ -e "$f" ] && set -- "$@" "$f"; done; \
    for pass in 1 2 3 4 5; do [ $# -eq 0 ] || dpkg -i --skip-same-version "$@" >/dev/null 2>&1 && break; done; \
    dpkg --configure -a && bad= && for d in "$@"; do p=$(dpkg-deb -f "$d" Package) v=$(dpkg-deb -f "$d" Version); \
      case "$(dpkg-query -W -f='${Version} ${db:Status-Abbrev}' "$p" 2>/dev/null)" in "$v ii"*) ;; *) bad="$bad $p=$v" ;; esac; done && \
    { [ -z "$bad" ] || { echo "vendored debs not installed at their vendored version:$bad" >&2; false; }; }
ARG SOURCE_DATE_EPOCH=1795543185
ENV SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH}
COPY vendored/ruby/ /tmp/ruby/
RUN cd /tmp/ruby && echo 'b53eef3371fa5d3e3b74340edcd015f06d5d8853968d4e539a5264fce41ed9f1  ruby-4.0.10.tar.gz' | sha256sum -c - && \
    tar -xzf ruby-4.0.10.tar.gz && cd ruby-4.0.10 && \
    ./configure --prefix=/usr/local --enable-shared --disable-install-doc --disable-install-static-library --enable-yjit --with-jemalloc && \
    make -j"$(nproc)" && make install && \
    cd / && rm -rf /tmp/ruby && \
    find /usr/local/lib/ruby \( -name gem_make.out -o -name mkmf.log \) -delete && \
    ruby --version | grep -qF 'ruby 4.0.10'
COPY kitforge-ruby-gems.rb /tmp/kitforge-ruby-gems.rb
COPY vendored/ruby-gems/ /tmp/ruby-gems/
RUN ruby /tmp/kitforge-ruby-gems.rb install /tmp/ruby-gems json=2.21.2 && \
    find /usr/local/lib/ruby \( -name gem_make.out -o -name mkmf.log \) -delete && \
    rm -rf /tmp/ruby-gems /tmp/kitforge-ruby-gems.rb
WORKDIR /opt/mastodon
COPY vendored/mastodon-src/ /opt/mastodon/
RUN bundle install --local --jobs "$(nproc)" && bundle check && \
    rm -rf vendor/cache vendor/bundle/ruby/*/cache && \
    find vendor/bundle \( -name '*.o' -o -name '*.a' -o -name mkmf.log -o -name gem_make.out \) -delete && \
    chmod -R go-w vendor/bundle && \
    bundle check
COPY vendored/downloads/ /downloads/
RUN cd /downloads && printf '%s\n' '5baaead3b0bb20ffdb9e9ff09aa9fda08620923df77b63b436654cb5e0b3bf94  vips-8.18.7.tar.xz' '1a4d394ae63d190a526cd052eb4415c156b5c5e2df37efab41a7de0b8fde2433  ffmpeg-9.1.tar.xz' | sha256sum -c -
RUN mkdir -p /tmp/vips && tar -xJf /downloads/vips-8.18.7.tar.xz -C /tmp/vips --strip-components 1 --no-same-owner && cd /tmp/vips && meson setup build --prefix /usr/local --libdir=lib -Ddeprecated=false -Dintrospection=disabled -Dmodules=disabled -Dexamples=false && ninja -C build && ninja -C build install && cd / && rm -rf /tmp/vips
RUN mkdir -p /tmp/ffmpeg && tar -xJf /downloads/ffmpeg-9.1.tar.xz -C /tmp/ffmpeg --strip-components 1 --no-same-owner && cd /tmp/ffmpeg && ./configure --prefix=/usr/local --toolchain=hardened --disable-debug --disable-devices --disable-doc --disable-ffplay --disable-network --disable-static --enable-ffmpeg --enable-ffprobe --enable-gpl --enable-libdav1d --enable-libmp3lame --enable-libopus --enable-libsnappy --enable-libvorbis --enable-libvpx --enable-libwebp --enable-libx264 --enable-libx265 --enable-shared --enable-version3 && make -j"$(nproc)" && make install && cd / && rm -rf /tmp/ffmpeg
RUN ldconfig && vips -v && ffmpeg -version | head -1 && ffprobe -version | head -1
FROM ubuntu:24.04@sha256:9c7f200c07e3d4a03e7249d2c16bf66a51120fb876aa2242cf31451412543289
ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8 BIND=0.0.0.0 NODE_ENV=production RAILS_ENV=production RAILS_SERVE_STATIC_FILES=true RUBY_YJIT_ENABLE=1 TZ=Etc/UTC PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/mastodon/bin MALLOC_CONF=narenas:2,background_thread:true,thp:never,dirty_decay_ms:1000,muzzy_decay_ms:0 MASTODON_SIDEKIQ_READY_FILENAME=sidekiq_process_has_started_and_will_begin_processing_jobs
RUN --mount=type=bind,source=vendored/debs,target=/tmp/debs \
    set --; for f in /tmp/debs/*.deb; do [ -e "$f" ] && set -- "$@" "$f"; done; \
    for pass in 1 2 3 4 5; do [ $# -eq 0 ] || dpkg -i --skip-same-version "$@" >/dev/null 2>&1 && break; done; \
    dpkg --configure -a && bad= && for d in "$@"; do p=$(dpkg-deb -f "$d" Package) v=$(dpkg-deb -f "$d" Version); \
      case "$(dpkg-query -W -f='${Version} ${db:Status-Abbrev}' "$p" 2>/dev/null)" in "$v ii"*) ;; *) bad="$bad $p=$v" ;; esac; done && \
    { [ -z "$bad" ] || { echo "vendored debs not installed at their vendored version:$bad" >&2; false; }; } && \
    rm -rf /var/lib/apt/lists/* \
           /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /var/cache/ldconfig/aux-cache /var/cache/fontconfig
ARG SOURCE_DATE_EPOCH=1795543185
RUN groupadd -g 991 mastodon && useradd -u 991 -g mastodon -s /bin/sh -d /opt/mastodon -m mastodon && \
    : "${SOURCE_DATE_EPOCH:?SOURCE_DATE_EPOCH must be set for a reproducible build}" && \
    sed -ri "s/^([^:]*:[^:]*):[0-9]*:/\1:$((SOURCE_DATE_EPOCH/86400)):/" /etc/shadow && \
    rm -f /etc/passwd- /etc/shadow- /etc/group- /etc/gshadow-
COPY --from=rubybuild /usr/local/bin/ /usr/local/bin/
COPY --from=rubybuild /usr/local/lib/ /usr/local/lib/
COPY --from=rubybuild --chown=mastodon:mastodon /opt/mastodon /opt/mastodon
COPY vendored/node/bin/node /usr/local/bin/node
COPY mastodon-entrypoint.sh /usr/local/bin/mastodon-entrypoint.sh
RUN ln -s /opt/mastodon /mastodon && \
    ldconfig && vips -v | grep -q '^vips-8.18.7' && ffmpeg -version | grep -q '^ffmpeg version 9.1' && ! ldd /usr/local/bin/ffmpeg /usr/local/lib/libvips.so.42 | grep -F 'not found' && \
    mkdir -p /opt/mastodon/public/system /opt/mastodon/tmp && chown -R mastodon:mastodon /opt/mastodon/public/system /opt/mastodon/tmp && \
    chmod 0755 /usr/local/bin/mastodon-entrypoint.sh && \
    ldconfig && rm -f /var/cache/ldconfig/aux-cache && \
    ruby --version | grep -qF 'ruby 4.0.10' && \
    node --version | grep -qx 'v24.22.3'
LABEL org.opencontainers.image.licenses="AGPL-3.0-only"
LABEL org.opencontainers.image.title="Mastodon"
LABEL org.opencontainers.image.version="v4.7.6-CE-ubuntu24.04-r2"
LABEL org.opencontainers.image.description="Mastodon is the open-source, decentralised social network server of the fediverse (ActivityPub). This image runs Mastodon 4.7 built from source on Ubuntu 24.04 as a non-root user: the web server, the Sidekiq worker and the streaming server from one image, with libvips and FFmpeg compiled from source as upstream's image does."
LABEL org.opencontainers.image.revision="a593c9420d2ff4664d448a9cb71bf8ed4ff0c29a"
LABEL com.readystack.license.disclosure="This image includes Mastodon (https://github.com/mastodon/mastodon), licensed under AGPL-3.0-only, built from upstream's tag v4.7.6 (commit a593c9420d2ff4664d448a9cb71bf8ed4ff0c29a). Modifications: the build adds Yarn resolutions to package.json that raise four npm dependencies of the streaming server (body-parser 2.4.0, proxy-addr 2.0.8, source-map-js 1.2.2, undici 8.12.2) to fixed, upstream-published releases (security updates; no Mastodon source file is edited); full diff of every upstream file the build changes at https://readystack.dev/source/mastodon/v4.7.6/mastodon-v4.7.6-readystack.patch. The upstream source is https://github.com/mastodon/mastodon/tree/v4.7.6. Ruby's own json gem is replaced by the json 2.21.2 that Mastodon's Gemfile.lock uses. Operating-system packages come from Ubuntu's archive, unmodified."
LABEL org.opencontainers.image.source="https://github.com/mastodon/mastodon"
HEALTHCHECK --interval=10s --timeout=30s --start-period=300s \
  CMD curl -fsS http://127.0.0.1:3000/health | grep -q OK || exit 1
USER mastodon
WORKDIR /opt/mastodon
EXPOSE 3000 4000
ENTRYPOINT ["tini", "--", "/usr/local/bin/mastodon-entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
