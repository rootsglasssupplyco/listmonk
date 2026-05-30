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

### 5. Email sending (SMTP) — Cloudways
Email is sent via the **Cloudways SMTP add-on** (powered by Elastic Email).
1. Cloudways panel → enable the **SMTP add-on** → copy the **host, port,
   username, password** it gives you.
2. listmonk admin → **Settings → SMTP** → paste those four values
   (use port 587 with STARTTLS/TLS enabled).
3. Add the **SPF + DKIM** DNS records Cloudways/Elastic Email provides to the
   `rootsglasswholesale.com` DNS zone — required for inbox deliverability.
4. Set the campaign **From** address (e.g. `news@rootsglasswholesale.com`) on a
   domain that matches those SPF/DKIM records.

## Notes
- App is AGPLv3 and free to self-host. You only pay for Railway hosting + your SMTP provider.
- Upstream source: https://github.com/knadh/listmonk
- Docs: https://listmonk.app/docs/
