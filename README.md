# portfolio-pocketbase

PocketBase backend for [naoufalelouahabi.com](https://naoufalelouahabi.com) — manages `projects` and `articles` records for the portfolio site.

Pinned to **PocketBase v0.40.5** (no official Docker image exists; this follows the official docs' Dockerfile pattern).

## Deploy (Dokploy)

- Compose app `portfolio-pocketbase`, port **8090**
- Domain: `pb.naoufalelouahabi.com` (HTTPS via Traefik + Let's Encrypt)
- Data persisted in the `pb_data` named volume

## Superuser

On first boot (or any time), exec into the container:

```bash
docker exec -it pocketbase /pb/pocketbase superuser upsert you@example.com 'strong-password'
```

Admin dashboard: `https://pb.naoufalelouahabi.com/_/`

## Collections

Created via the frontend repo's setup script (`portfolio/scripts/setup-pocketbase.mjs`):

- `projects` — portfolio case studies (public list/view when `published = true`)
- `articles` — reserved for future blog (same rules, empty for now)

## Backup & restore

```bash
# backup (SQLite is backed up while running; includes uploads)
docker exec pocketbase /pb/pocketbase backup create /pb/pb_data/backups/manual

# list
docker exec pocketbase /pb/pocketbase backup list

# restore (from a backup file name in the list)
docker exec pocketbase /pb/pocketbase backup restore <backup-file>
```

Backups land in the `pb_data` volume under `backups/`. Copy them off-box periodically (e.g. `docker run --rm -v portfolio-pocketbase_pb_data:/data -v $(pwd):/backup alpine tar czf /backup/pb-$(date +%F).tar.gz -C /data .`).

## Upgrade

Bump `PB_VERSION` in the Dockerfile, redeploy in Dokploy. Take a backup first — PocketBase is pre-1.0; pin versions and never skip backups.
