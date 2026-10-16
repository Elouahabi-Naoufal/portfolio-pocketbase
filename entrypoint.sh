#!/bin/sh
set -e

if [ -n "$PB_SUPERUSER_EMAIL" ] && [ -n "$PB_SUPERUSER_PASSWORD" ]; then
  echo "Ensuring superuser $PB_SUPERUSER_EMAIL exists..."
  /pb/pocketbase superuser upsert "$PB_SUPERUSER_EMAIL" "$PB_SUPERUSER_PASSWORD" --dir=/pb/pb_data || true
fi

exec /pb/pocketbase serve --http=0.0.0.0:8090 "$@"
