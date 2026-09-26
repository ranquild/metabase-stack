FROM node:22-bookworm-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl git jq \
 && rm -rf /var/lib/apt/lists/*

RUN npm install -g opencode-ai @metabase/cli \
 && npm cache clean --force

COPY init.sh /usr/local/bin/init.sh

RUN mkdir -p /workspace && chown node:node /workspace
USER node
WORKDIR /workspace

RUN npx -y skills add metabase/agent-skills --skill metabase-cli --agent opencode --global --copy --yes

COPY --chown=node:node opencode.json /home/node/.config/opencode/opencode.json

ENV MB_URL=http://metabase:3000 \
    MB_CLI_DISABLE_KEYRING=1 \
    OPENCODE_DISABLE_AUTOUPDATE=1 \
    OPENCODE_MODELS_URL=https://models.dev

EXPOSE 4096
ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD ["opencode", "web", "--port", "4096", "--hostname", "0.0.0.0"]
