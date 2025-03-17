FROM node:23.6.0-alpine AS base

FROM base AS prune
RUN apk update
RUN apk add --no-cache libc6-compat

WORKDIR /app
RUN npm i -g turbo
COPY . .
RUN turbo prune ws-server --docker

# -----------------installer stage--------------------------------------------------------------------------
FROM base AS installer
RUN apk update
RUN apk add --no-cache libc6-compat
RUN npm i -g pnpm
WORKDIR /ws-server

COPY --from=prune /app/out/json/ .

RUN pnpm install


# -----------------prod installer stage--------------------------------------------------------------------------
    FROM base AS installer-production
    RUN apk update
    RUN apk add --no-cache libc6-compat
    RUN npm i -g pnpm
    WORKDIR /app
    
    COPY --from=prune /app/out/json/ .
    
    RUN pnpm install --only=production



# -----------------builder stage--------------------------------------------------------------------------
FROM base AS builder
RUN npm i -g pnpm
WORKDIR /app
COPY --from=prune /app/out/full/ .
RUN pnpm install
RUN pnpm dlx turbo build --filter=ws-server
# COPY --from=installer /ws-server/node_modules /ws-server/node_modules
# COPY --from=installer /ws-server/apps/ws-server/node_modules /ws-server/apps/ws-server/node_modules
# COPY --from=installer /ws-server/packages /ws-server/packages
# ------------------runner stage-------------------------------------------------------------------------
FROM base AS runner

ENV DATABASE_URL=${DATABASE_URL}
ENV PORT=${PORT}
WORKDIR /app

COPY --from=installer-production   /app/node_modules /app/node_modules
COPY --from=installer-production   /app/apps/ws-server/node_modules /app/apps/ws-server/node_modules
COPY --from=prune                  /app/out/full/packages/ /app/packages/
# copies prod build dependencies i.e nodemodules with prod dependencies
COPY --from=installer-production   /app/packages/db/node_modules /app/packages/db/node_modules  
COPY --from=builder                /app/apps/ws-server/dist /app/apps/ws-server/dist
 
RUN cd packages/db && DATABASE_URL=${DATABASE_URL} npx prisma generate


WORKDIR /app/apps/ws-server

EXPOSE 8080

CMD [ "node", "./dist/index.js" ]