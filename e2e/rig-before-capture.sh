#!/bin/sh
# Refuse a screenshot until every production data path has consumed its
# deterministic render fixture. This makes a loading-state capture impossible.
set -eu

log_file="${XDG_RUNTIME_DIR:?}/mlb-booth-fixture.log"

# The live-feed timer runs every 20 seconds. The rig reaches this hook after
# roughly 18 seconds, so a fast startup can arrive just before the first GUMBO
# poll. Wait only for the remaining bounded window instead of accepting a
# loading-state screenshot or making the proof depend on scheduler timing.
attempt=0
while [ "$attempt" -lt 12 ]; do
  ready=true
  for expected in schedule standings gumbo; do
    if ! test -s "$log_file" || ! grep -Fx "$expected" "$log_file" >/dev/null; then
      ready=false
      break
    fi
  done
  if [ "$ready" = true ]; then
    exit 0
  fi
  attempt=$((attempt + 1))
  sleep 1
done

printf 'mlb-booth render fixture did not exercise schedule, standings, and GUMBO within 12 seconds\n' >&2
exit 1
