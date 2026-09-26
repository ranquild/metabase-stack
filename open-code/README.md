# Metabase + OpenCode

1. Copy the env file:
   ```sh
   cp .env.example .env
   ```
2. Set `OPENCODE_MODEL` (`provider/model`, e.g. `anthropic/claude-sonnet-5`,
   `openai/gpt-5`, `openrouter/<provider>/<model>`, `google/gemini-2.5-pro`)
   and paste the API key for that provider.
3. Start the stack:
   ```sh
   docker compose up -d --build
   ```
4. Open http://127.0.0.1:3001 for Metabase (`admin@example.com` /
   `metasample123`), and http://127.0.0.1:7682 for OpenCode.

Switch models inside OpenCode with `/models`. Stop with `docker compose down`
(add `-v` to wipe Metabase and the workspace).
