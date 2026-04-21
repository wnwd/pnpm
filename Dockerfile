ARG NODE_VERSION
FROM node:${NODE_VERSION}-slim

ARG PNPM_VERSION
RUN npm install -g pnpm@${PNPM_VERSION} \
    && node --version \
    && pnpm --version
