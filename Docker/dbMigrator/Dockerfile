FROM node:16-alpine

WORKDIR /usr/src/app/

COPY package*.json ./
# COPY .env .

RUN npm install glob rimraf
RUN npm install
RUN npx prisma generate
COPY prisma prisma

CMD ["npm", "run", "migrate"]
