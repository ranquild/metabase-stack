#!/usr/bin/env bash
# Bootstraps Metabase over its API, then logs the mb CLI in with a fresh API key.
#   - first boot: runs /api/setup to create the admin user
#   - every boot: creates (or regenerates) the "claude-code" admin API key
set -euo pipefail

: "${MB_URL:?}" "${MB_ADMIN_EMAIL:?}" "${MB_ADMIN_PASSWORD:?}"
KEY_NAME=claude-code

api() {
  local method=$1 path=$2; shift 2
  curl -fsS --noproxy '*' -X "$method" -H 'Content-Type: application/json' \
    ${MB_SESSION:+-H "X-Metabase-Session: $MB_SESSION"} "$@" "$MB_URL/api$path"
}

echo "Waiting for Metabase at $MB_URL..."
until api GET /health >/dev/null 2>&1; do sleep 2; done

props=$(api GET /session/properties)
if [ "$(jq -r '."has-user-setup"' <<<"$props")" != "true" ]; then
  echo "Creating admin $MB_ADMIN_EMAIL..."
  MB_SESSION=$(api POST /setup -d "$(jq -n \
    --arg token "$(jq -r '."setup-token"' <<<"$props")" \
    --arg email "$MB_ADMIN_EMAIL" --arg password "$MB_ADMIN_PASSWORD" \
    '{token: $token,
      user: {first_name: "Admin", last_name: "User", email: $email, password: $password},
      prefs: {site_name: "Metabase + Claude Code", allow_tracking: false}}')" | jq -r .id)
else
  MB_SESSION=$(api POST /session -d "$(jq -n \
    --arg username "$MB_ADMIN_EMAIL" --arg password "$MB_ADMIN_PASSWORD" \
    '{username: $username, password: $password}')" | jq -r .id)
fi

key_id=$(api GET /api-key | jq -r --arg name "$KEY_NAME" '.[] | select(.name == $name) | .id' | head -n1)
if [ -n "$key_id" ]; then
  key=$(api PUT "/api-key/$key_id/regenerate" | jq -r .unmasked_key)
else
  admin_group=$(api GET /permissions/group | jq -r '.[] | select(.name == "Administrators") | .id')
  key=$(api POST /api-key -d "$(jq -n --arg name "$KEY_NAME" --argjson group "$admin_group" \
    '{name: $name, group_id: $group}')" | jq -r .unmasked_key)
fi

printf '%s' "$key" | mb auth login --url "$MB_URL" >/dev/null
echo "mb CLI logged in to $MB_URL as $MB_ADMIN_EMAIL (API key \"$KEY_NAME\")."

exec "$@"
