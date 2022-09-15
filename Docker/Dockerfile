FROM node:16-alpine AS base
ARG NODE_ENV
ENV NODE_ENV ${NODE_ENV}
ENV HOME /app
WORKDIR ${HOME}
COPY package.json ${HOME}/
COPY yarn.lock ${HOME}/
COPY prisma ${HOME}/prisma

FROM base AS dependencies
COPY yarn.lock tsconfig.json nest-cli.json tsconfig.build.json ${HOME}/
COPY src/ ${HOME}/src
RUN npx prisma generate
RUN yarn install --production=false

FROM dependencies AS development
COPY .eslintrc.js ${HOME}

FROM dependencies AS builder
RUN yarn build
RUN yarn install --production
RUN cp -R node_modules prod_node_modules

FROM base AS production
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prod_node_modules ./node_modules

EXPOSE 80
CMD ["node", "dist/main"]
