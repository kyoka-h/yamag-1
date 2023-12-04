FROM node:18.17.0-bullseye

WORKDIR /

# Install pnpm
RUN npm i -g pnpm

# Install cron
RUN apt-get update && apt-get -y install cron

# Install vi
RUN apt-get update && apt-get -y install vim

# Files required by pnpm install
COPY package.json pnpm-lock.yaml ./

# COPY prisma files before install dependencies
COPY prisma ./prisma/

RUN pnpm install --frozen-lockfile

# Bundle app source
COPY . .

RUN pnpm build

CMD [ "pnpm", "run", "mentions" ]