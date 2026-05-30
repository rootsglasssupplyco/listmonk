# Listmonk — rootsglasswholesale.com

Self-hosted [listmonk](https://listmonk.app/) newsletter / mailing-list manager,
packaged to deploy on [Railway](https://railway.app/) behind a Caddy reverse-proxy.

CORS is pre-configured for `rootsglasswholesale.com` (see `scripts/start_caddy.sh`),
so the public subscription API works from the storefront with no extra config.

## Deploy checklist

### 1. Create the Railway project
- New Railway project → deploy from this repo.
- Add a **PostgreSQL** service to the same project (one-click).

### 2. Set environment variables on the listmonk service
Use Railway variable references so the DB values auto-fill from Postgres:

| Variable | Value |
|---|---|
| `LISTMONK_db__host` | `${{Postgres.PGHOST}}` |
| `LISTMONK_db__port` | `${{Postgres.PGPORT}}` |
| `LISTMONK_db__user` | `${{Postgres.PGUSER}}` |
| `LISTMONK_db__password` | `${{Postgres.PGPASSWORD}}` |
| `LISTMONK_db__database` | `${{Postgres.PGDATABASE}}` |
| `LISTMONK_db__ssl_mode` | `require` |
| `LISTMONK_ADMIN_USER` | `admin` |
| `LISTMONK_ADMIN_PASSWORD` | _a strong password_ |

`scripts/start.sh` waits on `LISTMONK_db__host` / `LISTMONK_db__port`, so those
two must be set or the container hangs on "Waiting for database...".

### 3. CORS (already done)
`scripts/start_caddy.sh` defaults the allowed origins to
`https://rootsglasswholesale.com` and `https://www.rootsglasswholesale.com`.
To change them, set `LISTMONK_ORIGIN_0` … `LISTMONK_ORIGIN_4` (full scheme +
host, no trailing slash).

### 4. Custom domain (optional)
- Railway → listmonk service → **Settings → Networking → Custom Domain** →
  add e.g. `lists.rootsglasswholesale.com` and create the CNAME it gives you.
- In listmonk admin: **Settings → General → Root URL** → set to the same URL
  (used in email links & unsubscribe URLs).

### 5. Email sending (SMTP)
In listmonk admin: **Settings → SMTP**. Use a real provider (Amazon SES,
Postmark, Mailgun, …) and add the SPF/DKIM DNS records they give you on
`rootsglasswholesale.com` — required for deliverability.

## Notes
- App is AGPLv3 and free to self-host. You only pay for Railway hosting + your SMTP provider.
- Upstream source: https://github.com/knadh/listmonk
- Docs: https://listmonk.app/docs/
