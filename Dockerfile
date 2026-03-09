FROM alpine:3.20

# Install dependencies (curl, jq for JSON generation)
RUN apk add --no-cache curl jq libgcc libstdc++ pcompat gcompat caddy

# Create a non-root user
RUN addgroup -S nullclaw && adduser -S nullclaw -G nullclaw
WORKDIR /home/nullclaw

# Download NullClaw statically compiled binary (linux-amd64)
RUN wget -qO nullclaw https://github.com/nullclaw/nullclaw/releases/latest/download/nullclaw-linux-x86_64.bin && \
    chmod +x nullclaw && \
    mv nullclaw /usr/local/bin/

USER nullclaw

COPY entrypoint.sh .
CMD ["/bin/sh", "entrypoint.sh"]
