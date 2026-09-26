# Egress proxy for the claude-code container: lets it reach api.anthropic.com only.
FROM alpine:3.22
RUN apk add --no-cache tinyproxy
COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf
COPY allowlist /etc/tinyproxy/allowlist
USER tinyproxy
EXPOSE 8888
CMD ["tinyproxy", "-d", "-c", "/etc/tinyproxy/tinyproxy.conf"]
