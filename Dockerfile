FROM node:18.17.0-bullseye

WORKDIR /root/

# Install pnpm
RUN npm i -g pnpm

# Change TZ
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Install BusyBox crond
RUN apt-get update && apt-get -y install busybox-static

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

COPY yamag-cron /var/spool/cron/crontabs/root

CMD ["busybox", "crond", "-f", "-L", "/dev/stderr"]
