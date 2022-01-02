FROM node:16-alpine AS base

RUN npm install -g pnpm

RUN mkdir /api
WORKDIR /api

COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY . .

RUN pnpm prisma generate

FROM node:16-alpine

RUN npm install -g pnpm

COPY --from=base /api /api

WORKDIR /api

ENV NODE_ENV production
EXPOSE 4000

CMD ["pnpm", "start"]
