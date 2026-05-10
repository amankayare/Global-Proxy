# Global-Proxy

A standalone Caddy reverse proxy that serves as the single entry point for all services on `amankayare.com`.

It handles:
- **Automatic HTTPS** via Let's Encrypt
- **Traffic routing** to any project container on the shared `web-network`

---

## Services Routed

| Domain | Container | Project |
|---|---|---|
| `amankayare.com` | `dev47-frontend:80` + `dev47-backend:5000` | Dev47 |
| `email.amankayare.com` | `email-api:8080` | Email-Service |
| `polyglot.amankayare.com` | `polyglot-storage-proxy:3000` | Polyglot-Storage |

---

## Adding a New Service

1. Start the new project's containers on `web-network` (set `external: true` in its compose file).
2. Append a site block to `Caddyfile`:
   ```caddyfile
   new-service.amankayare.com {
       reverse_proxy new-service-container:PORT
   }
   ```
3. Reload Caddy (zero-downtime, no restart needed):
   ```bash
   docker exec global-caddy caddy reload --config /etc/caddy/Caddyfile
   ```

---

## Deployment

This must be started **first**, before any other project, because it creates the `web-network`.

```bash
# On the VPS — first time or after Caddyfile change
cd /opt/Global-Proxy
git pull
docker compose up -d
```

## Startup Order (on the VPS)

```bash
# 1. Proxy first — creates web-network
cd /opt/Global-Proxy && docker compose up -d

# 2. Dev47
cd /opt/Dev47/docker-prod && docker compose up -d --build

# 3. Email-Service
cd /opt/Email-Service/docker-prod && docker compose up -d --build
```
