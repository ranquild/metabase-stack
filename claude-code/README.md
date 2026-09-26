# Metabase + Claude Code

1. Get a Claude Code token:
   ```sh
   claude setup-token
   ```
2. Copy the env file and paste the token into `CLAUDE_CODE_OAUTH_TOKEN`:
   ```sh
   cp .env.example .env
   ```
3. Start the stack:
   ```sh
   docker compose up -d --build
   ```
4. Open http://127.0.0.1:3000 for Metabase (`admin@example.com` /
   `metasample123`), and http://127.0.0.1:7681 for Claude Code.

Stop with `docker compose down` (add `-v` to wipe Metabase and the workspace).
