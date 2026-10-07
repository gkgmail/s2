## Koyeb Deployment

This repo is ready to deploy on Koyeb using the included `koyeb.yaml` and Dockerfile.

### 1. Create the Koyeb app

- Push this repo to GitHub.
- In Koyeb, create a new App and select GitHub repo.
- Use `koyeb.yaml` as the deployment config.

### 2. Required environment variables

Set these in the Koyeb dashboard before deploying:

```bash
SAVEANY_TELEGRAM_TOKEN=your_bot_token_here
SAVEANY_TELEGRAM_APP_ID=your_app_id
SAVEANY_TELEGRAM_APP_HASH=your_app_hash
SAVEANY_API_TOKEN=change-me
```

Important:
- `SAVEANY_TELEGRAM_TOKEN` is required for the Telegram bot to start.
- `SAVEANY_API_TOKEN` is used for the HTTP API if you enable it.
- The default `config.toml` in this repo is a starter config for Koyeb.

### 3. Koyeb runtime notes

- The app listens on port `8080` when API mode is enabled.
- Data is stored under `/app/data` and `/app/downloads` inside the container.
- For persistent storage, attach a Koyeb volume to those paths in the app settings.

### 4. Deploy command

```bash
koyeb app deploy -f koyeb.yaml
```
