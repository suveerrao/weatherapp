FROM node:10.15.3-alpine
MAINTAINER Suveer <raoo.suveer@gmail.com>
RUN apk update && \
    apk add bash curl coreutils
COPY package.json /tmp/package.json
RUN npm install -g @angular/cli@1.7.2 && \
    cd /tmp && \
    npm install && \
    mkdir -p /code && mv /tmp/node_modules /code/node_modules
COPY . /code/
WORKDIR /code
RUN npm run build


FROM alpine:latest
RUN apk --no-cache add nginx bash curl && \
    rm -f /etc/nginx/nginx.conf && mkdir -p /opt/app/ 
WORKDIR /code/
COPY --from=0 /code/dist /opt/app/dist
COPY --from=0 /code/nginx.conf /etc/nginx/nginx.conf
ENTRYPOINT nginx

