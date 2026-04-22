# node-pnpm

Auto-updated Docker image bundling the latest stable **Node.js LTS** and **pnpm**, published daily to both [ghcr.io](https://ghcr.io) and [Docker Hub](https://hub.docker.com).

## Images

| Registry | Repository |
|----------|------------|
| ghcr.io  | `ghcr.io/wnwd/node-pnpm` |
| Docker Hub | `wnwd/node-pnpm` |

### Tags

| Tag | Example | Meaning |
|-----|---------|---------|
| `latest` | `latest` | Most recent build |
| `<node>-<pnpm>` | `24.15.0-10.33.0` | Exact versions |
| `<node_major>-<pnpm_major>` | `24-10` | Major versions |

## Usage

```bash
# Always latest
docker pull ghcr.io/wnwd/node-pnpm:latest

# Pin to exact versions
docker pull ghcr.io/wnwd/node-pnpm:24.15.0-10.33.0
```

```dockerfile
FROM ghcr.io/wnwd/node-pnpm:latest
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm build
```

## How it works

```
Every day 02:00 UTC
        │
        ▼
┌─────────────────────┐
│  check-versions.yml │  ── fetch latest Node LTS + pnpm from upstream
└─────────────────────┘
        │ version changed?
        ▼
 update versions.env
 git commit + tag  ──────► push tag "nodeX.Y.Z-pnpmA.B.C"
        │
        ▼
┌─────────────────────┐
│   build-push.yml    │  ── triggered by tag push
└─────────────────────┘
        │
        ├──► ghcr.io  (latest / exact / major)
        └──► Docker Hub (latest / exact / major)
```

### Workflows

| File | Trigger | Purpose |
|------|---------|---------|
| `check-versions.yml` | Daily cron / manual | Detect upstream updates, commit & tag |
| `build-push.yml` | Tag push `node*-pnpm*` / manual | Build & publish image |

## Setup

### 1. Repository secrets

| Secret | Description |
|--------|-------------|
| `DOCKERHUB_USERNAME` | Docker Hub username |
| `DOCKERHUB_TOKEN` | Docker Hub access token |

`GITHUB_TOKEN` is provided automatically by GitHub Actions for ghcr.io access.

### 2. Allow Actions to write to the repository

Go to **Settings → Actions → General → Workflow permissions** and select **Read and write permissions**.

### 3. First build

Trigger `build-push.yml` manually from the Actions tab to publish the initial image without waiting for a version change.

## Current versions

Tracked in [`versions.env`](./versions.env).

| Component | Version |
|-----------|---------|
| Node.js LTS | 24.15.0 |
| pnpm | 10.33.0 |
