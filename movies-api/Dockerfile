#ARG NODE_IMAGE=node:16.13.1-alpine
#
#FROM $NODE_IMAGE AS base
#RUN apk --no-cache add dumb-init
#RUN mkdir -p /home/node/app && chown node:node /home/node/app
#WORKDIR /home/node/app
#USER node
#RUN mkdir tmp
#
#FROM base AS dependencies
#COPY --chown=node:node ./package*.json ./
#RUN npm ci
#COPY --chown=node:node . .
#
#FROM dependencies AS build
#RUN node ace build --production
#
#FROM base AS production
#ENV NODE_ENV=production
#ENV PORT=3333
#ENV HOST=0.0.0.0
#COPY --chown=node:node ./package*.json ./
#RUN npm ci --production
#COPY --chown=node:node --from=build /home/node/app/build .
#EXPOSE 3333
#CMD [ "dumb-init", "node", "server.js" ]


FROM node:14.17.0-alpine AS base

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
ENV HOST=0.0.0.0
ENV PORT=3333

FROM base AS dev
ENV CHOKIDAR_USEPOLLING=true
ENV NODE_ENV=development
CMD ["node", "ace", "serve", "--watch"]
