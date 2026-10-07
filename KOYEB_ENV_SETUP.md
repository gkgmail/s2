# Koyeb Environment Variables Setup Guide

Isse guide follow karke aap Koyeb dashboard mein sab environment variables correctly set kar sakte ho.

---

## Quick Setup (Minimum Required)

Ye 3 variables **mandatory** hain:

```bash
SAVEANY_TELEGRAM_TOKEN=your_bot_token_here
SAVEANY_API_ENABLE=true
SAVEANY_API_TOKEN=random_secure_token_here
```

---

## Full Environment Variables List

### 🔴 REQUIRED Variables

| Variable | Value | Example |
|----------|-------|---------|
| `SAVEANY_TELEGRAM_TOKEN` | Your Telegram bot token from @BotFather | `123456789:ABCDefgh...` |

### 🟡 STRONGLY RECOMMENDED

| Variable | Default | Example |
|----------|---------|---------|
| `SAVEANY_API_TOKEN` | - | `my_super_secure_random_token_12345` |
| `SAVEANY_TELEGRAM_APP_ID` | `1025907` (default) | `12345678` |
| `SAVEANY_TELEGRAM_APP_HASH` | - | `a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6` |

### 🟢 OPTIONAL (Use Defaults)

| Variable | Default | Options |
|----------|---------|---------|
| `SAVEANY_LANG` | `en` | `en`, `zh-Hans` |
| `SAVEANY_LOG_LEVEL` | `info` | `debug`, `info`, `warn`, `error`, `fatal` |
| `SAVEANY_API_ENABLE` | `true` | `true`, `false` |
| `SAVEANY_API_HOST` | `0.0.0.0` | - |
| `SAVEANY_API_PORT` | `8080` | - |
| `SAVEANY_WORKERS` | `3` | `1-8` (concurrent downloads) |
| `SAVEANY_THREADS` | `4` | `1-16` (threads per download) |
| `SAVEANY_RETRY` | `3` | `1-10` (retry count) |

---

## Step-by-Step Koyeb Setup

### Step 1: Go to Koyeb Dashboard

1. https://app.koyeb.com
2. Select **gkgmail/s2** app
3. Click **Settings** → **Environment Variables**

### Step 2: Copy-Paste These Commands

Koyeb CLI se:

```bash
koyeb secret create SAVEANY_TELEGRAM_TOKEN "your_bot_token_here"
koyeb secret create SAVEANY_API_TOKEN "random_secure_token_12345"
koyeb secret create SAVEANY_TELEGRAM_APP_ID "12345678"
koyeb secret create SAVEANY_TELEGRAM_APP_HASH "a1b2c3d4e5f6..."
```

Ya **Dashboard** mein manually:

1. Click **Add Environment Variable**
2. Add karo ye values:

```
SAVEANY_TELEGRAM_TOKEN = 123456789:ABCDefgh...
SAVEANY_API_ENABLE = true
SAVEANY_API_TOKEN = random_secure_token_12345
SAVEANY_API_HOST = 0.0.0.0
SAVEANY_API_PORT = 8080
SAVEANY_LANG = en
SAVEANY_LOG_LEVEL = info
SAVEANY_WORKERS = 3
SAVEANY_THREADS = 4
SAVEANY_RETRY = 3
```

3. Click **Save**
4. Koyeb automatically redeploy karega ✅

---

## How to Get Each Value

### 1. SAVEANY_TELEGRAM_TOKEN

```
Telegram par @BotFather ko message karo:
  /start
  /newbot
  Bot ka naam do (e.g., "My SaveAny Bot")
  Unique username do (must end with 'bot', e.g., "my_saveany_bot")
  Token milega ⬇️
  Copy kar lo: 123456789:ABCDefgh...
```

**Set in Koyeb:**
```
SAVEANY_TELEGRAM_TOKEN = 123456789:ABCDefgh...
```

### 2. SAVEANY_API_TOKEN

```
Ye koi bhi strong random string ho sakta hai.
Password manager se generate karo ya:

Linux/Mac:
  openssl rand -hex 32

Windows:
  python -c "import secrets; print(secrets.token_hex(32))"

Ya random string bana do:
  my_api_token_abc123xyz789
```

**Set in Koyeb:**
```
SAVEANY_API_TOKEN = my_api_token_abc123xyz789
```

### 3. SAVEANY_TELEGRAM_APP_ID & SAVEANY_TELEGRAM_APP_HASH

**Optional** - Default values already set. Lekin agar custom API use karna ho:

```
1. https://my.telegram.org par jao
2. "API development tools" select karo
3. App create karo (ya existing select karo)
4. App ID copy karo: 12345678
5. API Hash copy karo: a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6
```

**Set in Koyeb:**
```
SAVEANY_TELEGRAM_APP_ID = 12345678
SAVEANY_TELEGRAM_APP_HASH = a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6
```

---

## Advanced Configuration

### Enable External Storage (S3, WebDAV, etc.)

Edit `config.toml` in repo:

```toml
[[storages]]
name = "My S3 Bucket"
type = "s3"
enable = true
endpoint = "s3.amazonaws.com"
bucket = "my-bucket-name"
access_key = "AKIAIOSFODNN7EXAMPLE"
secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
base_path = "/telegram-files"
```

Then push to GitHub:
```bash
git add config.toml
git commit -m "Add S3 storage"
git push origin main
```

Koyeb automatically redeploy karega! ✨

### Enable yt-dlp (Video Download)

```
SAVEANY_YTDLP_ENABLE = true
SAVEANY_YTDLP_MAX_HEIGHT = 1080
SAVEANY_YTDLP_FORMAT = 
SAVEANY_YTDLP_RECODE = mp4
```

### Enable Aria2 (Download Manager)

```
SAVEANY_ARIA2_ENABLE = true
SAVEANY_ARIA2_URL = http://aria2-server:6800/jsonrpc
SAVEANY_ARIA2_SECRET = your_aria2_secret
```

---

## Testing Your Setup

After deployment, test via curl:

```bash
# Get Koyeb service URL
KOYEB_URL=your-koyeb-domain.koyeb.app

# Test bot is running
curl https://${KOYEB_URL}/api/info \
  -H "Authorization: Bearer your_api_token"

# Should return bot info ✅
```

---

## Troubleshooting

### App crashes after deploy?

```bash
Check logs:
  koyeb service logs saveany-bot -f

Look for:
  ❌ "SAVEANY_TELEGRAM_TOKEN environment variable is not set!"
     → Set token in dashboard
  ❌ "Error reading config file"
     → Check config.toml syntax
  ❌ "Address already in use"
     → Check port 8080 is free
```

### Bot nahi start ho raha?

```bash
Ensure ye set ho:
  SAVEANY_TELEGRAM_TOKEN ✅ (non-empty)
  SAVEANY_API_ENABLE = true ✅
  SAVEANY_API_PORT = 8080 ✅
```

### Storage issue?

```bash
If using local disk, attach Koyeb volume:
  /app/downloads → downloads-volume
  /app/data → data-volume
```

---

## Quick Deploy Checklist

- [ ] Telegram bot token obtained from @BotFather
- [ ] Random API token generated
- [ ] SAVEANY_TELEGRAM_TOKEN set in Koyeb dashboard
- [ ] SAVEANY_API_TOKEN set in Koyeb dashboard
- [ ] SAVEANY_API_ENABLE = true
- [ ] SAVEANY_API_PORT = 8080
- [ ] Deploy button clicked
- [ ] Logs checked for errors
- [ ] Bot tested on Telegram
- [ ] API tested via curl

✅ Done! Bot live hai! 🎉

