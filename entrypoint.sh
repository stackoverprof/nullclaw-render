#!/bin/sh

# Set defaults
PORT=${PORT:-3000}
BOT_TOKEN=${TELEGRAM_BOT_TOKEN:-""}
ALLOWED_USERS=${TELEGRAM_ALLOWED_USERS:-""}
API_KEY=${AI_API_KEY:-""}
PROVIDER=${AI_PROVIDER:-"openrouter"}
MODEL=${AI_MODEL:-"openrouter/anthropic/claude-3-haiku"}

# Create config directory
mkdir -p ~/.nullclaw

# Generate config.json using jq
# we split the allowed users by comma so the user doesn't have to write valid JSON in the dashboard
jq -n \
  --arg port "$PORT" \
  --arg bot_token "$BOT_TOKEN" \
  --arg api_key "$API_KEY" \
  --arg provider "$PROVIDER" \
  --arg model "$MODEL" \
  --arg allowed_users_csv "$ALLOWED_USERS" \
  '{
    "models": {
      "providers": {
        ($provider): {
          "api_key": $api_key
        }
      }
    },
    "agents": {
      "defaults": {
        "model": {
          "primary": $model
        }
      }
    },
    "channels": {
      "telegram": {
        "accounts": {
          "main": {
            "bot_token": $bot_token,
            "allow_from": ($allowed_users_csv | split(",")),
            "reply_in_private": true
          }
        }
      }
    },
    "gateway": {
      "host": "0.0.0.0",
      "port": ($port | tonumber),
      "require_pairing": false,
      "allow_public_bind": true
    }
  }' > ~/.nullclaw/config.json

echo "Configuration generated."
echo "Starting NullClaw on port $PORT..."

# Start nullclaw gateway
exec nullclaw gateway --port $PORT
