#!/bin/sh

set -euo pipefail

# Default CORS origins to the rootsglasswholesale.com storefront so the public
# subscription API works out of the box. Override any of these via the
# LISTMONK_ORIGIN_* env vars in Railway to add more sites (e.g. rootsglass.com).
export ORIGIN_0=${LISTMONK_ORIGIN_0:-https://rootsglasswholesale.com}
export ORIGIN_1=${LISTMONK_ORIGIN_1:-https://www.rootsglasswholesale.com}
export ORIGIN_2=${LISTMONK_ORIGIN_2:-$(openssl rand -hex 12)}
export ORIGIN_3=${LISTMONK_ORIGIN_3:-$(openssl rand -hex 12)}
export ORIGIN_4=${LISTMONK_ORIGIN_4:-$(openssl rand -hex 12)}

exec caddy run \
    --config Caddyfile \
    --adapter caddyfile 2>&1