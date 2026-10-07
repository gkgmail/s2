#!/bin/sh

# Override Koyeb environment issues with shorter, simpler paths
export SAVEANY_DB_PATH="/tmp/bot.db"
export SAVEANY_DB_SESSION="/tmp/session.db"
export SAVEANY_TEMP_BASE_PATH="/tmp/cache/"

# Create necessary directories
mkdir -p /tmp/cache
mkdir -p /tmp/downloads

# Check if Telegram token is provided (required for bot operation)
if [ -z "$SAVEANY_TELEGRAM_TOKEN" ]; then
    echo "[CRITICAL] SAVEANY_TELEGRAM_TOKEN environment variable is not set!"
    echo "[INFO] Please set your Telegram bot token before starting."
    echo "[INFO] Get token from @BotFather on Telegram: https://t.me/BotFather"
    exit 1
fi

# Download config from URL if CONFIG_URL is provided
if [ -n "$CONFIG_URL" ]; then
    echo "[INFO] Downloading config from $CONFIG_URL"
    if curl -sSLo /app/config.toml "$CONFIG_URL"; then
        echo "[INFO] Configuration downloaded successfully"
    else
        echo "[ERROR] Failed to download config from $CONFIG_URL"
        exit 1
    fi
fi
    
echo "[INFO] Starting SaveAny Bot..."
echo "[INFO] Using database: $SAVEANY_DB_PATH"
echo "[INFO] Using session: $SAVEANY_DB_SESSION"
exec /app/saveany-bot
