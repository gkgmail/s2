# Koyeb Deployment Guide

> Isse repo ab **Koyeb par directly deploy ho sakta hai!** 🚀

## Prerequisites

Aapko chahiye:
1. **Telegram Bot Token** - @BotFather se le lo: https://t.me/BotFather
2. **GitHub Account** - repo push karne ke liye
3. **Koyeb Account** - https://www.koyeb.com (free tier available)

---

## Step 1: Telegram Bot Token Setup

```bash
# Telegram par @BotFather ko message karo
/start
/newbot
# Bot ka naam do aur username (must end with 'bot')
# Token milega, copy kar lo
```

---

## Step 2: Push Repo to GitHub

```bash
git add .
git commit -m "Ready for Koyeb deployment"
git push origin main
```

---

## Step 3: Deploy on Koyeb

### Option A: CLI Deployment

```bash
# Install Koyeb CLI
# https://docs.koyeb.com/getting-started/installation

# Login
koyeb login

# Deploy
koyeb app deploy \
  --name saveany-bot \
  --git gkgmail/s2 \
  --git-branch main \
  --dockerfile-path Dockerfile \
  --ports 8080:http \
  --env SAVEANY_TELEGRAM_TOKEN="your_bot_token_here"
```

### Option B: Koyeb Dashboard (Easy)

1. Go to https://app.koyeb.com
2. **Create App** → **GitHub** → Select your `gkgmail/s2` repo
3. Select **main** branch
4. Docker settings:
   - Dockerfile: `Dockerfile` ✓
   - Build context: `.` ✓
5. Instance type: **Micro** (free tier)
6. **Environment Variables** tab - add these:
   ```
   SAVEANY_TELEGRAM_TOKEN = your_bot_token_here
   SAVEANY_API_TOKEN = your_secure_random_token_here
   SAVEANY_TELEGRAM_APP_ID = 0  (or your own from my.telegram.org)
   SAVEANY_TELEGRAM_APP_HASH =  (or your own)
   ```
7. Click **Deploy** ✅

---

## Step 4: Verify Deployment

After deployment completes:

```bash
# Get Koyeb service URL
koyeb service get saveany-bot

# Test API endpoint
curl https://your-koyeb-domain/health

# Check logs
koyeb service logs saveany-bot -f
```

---

## Environment Variables Reference

| Variable | Required | Default | Notes |
|----------|----------|---------|-------|
| `SAVEANY_TELEGRAM_TOKEN` | ✅ YES | - | Bot token from @BotFather |
| `SAVEANY_TELEGRAM_APP_ID` | ❌ Optional | `1025907` | From my.telegram.org |
| `SAVEANY_TELEGRAM_APP_HASH` | ❌ Optional | - | From my.telegram.org |
| `SAVEANY_API_TOKEN` | ✅ YES | - | For API authentication |
| `SAVEANY_API_ENABLE` | ❌ Optional | `true` | Enable HTTP API |
| `SAVEANY_API_PORT` | ❌ Optional | `8080` | Port for API |
| `SAVEANY_LANG` | ❌ Optional | `en` | `en` or `zh-Hans` |
| `SAVEANY_LOG_LEVEL` | ❌ Optional | `info` | `debug`, `info`, `warn`, `error` |
| `SAVEANY_WORKERS` | ❌ Optional | `3` | Concurrent download workers |

---

## Using the Bot

After deployment:

1. **Find your bot** on Telegram (search by username)
2. **/start** - See available commands
3. **Send file/link** - Bot download aur save karega
4. **Configure storage** - config.toml edit kar ke storage add kar sakte ho

---

## Storage Configuration

Current default setup: **Local Disk** (`/app/downloads`)

Koyeb par persistent storage ke liye:

### Option A: Koyeb Volumes (Recommended)

```bash
koyeb service update saveany-bot \
  --mount /app/data:data-volume \
  --mount /app/downloads:downloads-volume
```

### Option B: External Storage (S3, WebDAV, etc.)

Edit `config.toml` aur add karo:

```toml
[[storages]]
name = "S3 Storage"
type = "s3"
enable = true
endpoint = "s3.amazonaws.com"
bucket = "your-bucket"
access_key = "YOUR_KEY"
secret_key = "YOUR_SECRET"
base_path = "/telegram-files"
```

Phir:
```bash
git add config.toml
git commit -m "Add S3 storage"
git push origin main
# Koyeb automatically redeploy karega
```

---

## Troubleshooting

### Bot nahi start ho raha?

```bash
koyeb service logs saveany-bot -f

# Look for:
# ❌ "SAVEANY_TELEGRAM_TOKEN environment variable is not set!"
#    → Set token in Koyeb dashboard
# ❌ "Error reading config file"
#    → config.toml syntax check karo
```

### API accessible nahi hai?

```bash
# Check if API is enabled
koyeb service env saveany-bot | grep API_ENABLE

# Should show: SAVEANY_API_ENABLE=true
```

### Storage issues?

```bash
# Check volumes
koyeb service describe saveany-bot | grep -i mount

# Add volume if needed
koyeb service update saveany-bot \
  --mount /app/downloads:downloads-volume
```

---

## Advanced: Custom Config via URL

TOML config ko publicly hosted karo (GitHub Pages, etc.), phir:

```bash
koyeb service update saveany-bot \
  --env CONFIG_URL="https://example.com/config.toml"
```

Bot startup mein automatically download karega! ✨

---

## Next Steps

1. ✅ Deploy on Koyeb
2. Set up your storage (Local/S3/WebDAV/etc.)
3. Add users in config.toml
4. Set up file organization rules
5. (Optional) Enable additional features (yt-dlp, aria2, parsers)

Happy file saving! 📂
