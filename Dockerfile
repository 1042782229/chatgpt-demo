FROM node:alpine as builder
WORKDIR /usr/src
RUN npm install -g pnpm
COPY package.json  ./
RUN pnpm install
COPY . .
RUN npm run build

FROM node:alpine
WORKDIR /usr/src
RUN npm install -g pnpm
COPY --from=builder /usr/src/dist ./dist
COPY --from=builder /usr/src/hack ./
COPY package.json  ./
RUN npm install
ENV HOST=0.0.0.0 PORT=3000 NODE_ENV=production
EXPOSE $PORT
CMD ["/bin/sh", "docker-entrypoint.sh"]
