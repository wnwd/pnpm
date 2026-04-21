# CLAUDE.md

## Project

Auto-updating Docker image with latest Node.js LTS + pnpm, published to ghcr.io and Docker Hub via GitHub Actions.

## File layout

| File | Purpose |
|------|---------|
| `Dockerfile` | `node:XX-slim` base, `ARG NODE_VERSION` / `ARG PNPM_VERSION` |
| `versions.env` | Single source of truth: `NODE_VERSION` and `PNPM_VERSION` |
| `.github/workflows/check-versions.yml` | Daily cron — detect updates, commit + push tag |
| `.github/workflows/build-push.yml` | Build + push on `node*-pnpm*` tag |

## CI/CD flow

1. `check-versions.yml` runs daily, fetches Node LTS from `nodejs.org/dist/index.json` and pnpm from `registry.npmjs.org/pnpm/latest`.
2. If either version changed, updates `versions.env`, commits, and pushes a tag like `node24.15.0-pnpm10.33.0`.
3. `build-push.yml` triggers on that tag, reads `versions.env`, builds the image, and pushes three tag variants (`latest`, exact, major) to both registries.

## Required secrets

- `DOCKERHUB_USERNAME` — Docker Hub username
- `DOCKERHUB_TOKEN` — Docker Hub access token
- `GITHUB_TOKEN` — auto-provided, used for ghcr.io

## Rules

- `versions.env` is the single source of truth; never hardcode versions elsewhere.
- Do not add extra layers to the Dockerfile — keep the image minimal.
- Tag format must stay `node<semver>-pnpm<semver>` — the build workflow pattern-matches on it.
