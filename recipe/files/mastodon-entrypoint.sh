#!/bin/sh
# ReadyStack Mastodon entrypoint. One image runs Mastodon's three processes (upstream publishes them as two images):
#   web (the default)  bundle exec puma -C config/puma.rb   the web UI and API on port 3000
#   sidekiq            bundle exec sidekiq                   the job queue
#   streaming          node ./streaming/index.js             the streaming API on port 4000
# Upstream's own commands (its docker-compose.yml) work as they are. Before the web server starts, the database is
# prepared with `rails db:prepare`: an empty database gets the schema and the seed data, an existing one gets its
# pending migrations, which upstream's upgrade notes otherwise ask you to run by hand. MASTODON_SKIP_MIGRATE=1 skips it
# (several web containers on one database). Anything else (bin/tootctl, bin/rails console) runs as given.
set -e
cd /opt/mastodon
case "$1" in
  web) shift; set -- bundle exec puma -C config/puma.rb "$@" ;;
  sidekiq) shift; set -- bundle exec sidekiq "$@" ;;
  streaming) shift; set -- node ./streaming/index.js "$@" ;;
esac
if [ "$1" = "bundle" ] && [ "$2" = "exec" ] && [ "$3" = "puma" ] && [ "${MASTODON_SKIP_MIGRATE:-0}" != "1" ]; then
  echo "mastodon: preparing the database (rails db:prepare)" >&2
  bundle exec rails db:prepare
fi
exec "$@"
