############################################################################
############################################################################
####                                                                    ####
####  Instructions and build,                                           ####
####  deploy and use in the                                             ####
####  README.md file                                                    ####
####                                                                    ####
############################################################################
####################################################################################
####                                                                            ####
####   docker build --no-cache -f ./Deploy.Dockerfile -t kel/web:deploy .       ####
####                                                                            ####
####   docker run -it --rm -p 8080:8080 --name kel-web-deploy kel/web:deploy    ####
####                                                                            ####
####################################################################################
FROM node:12-alpine as build-stage

RUN yarn --version

WORKDIR /app

COPY package*.json yarn.lock* ./

RUN yarn install

COPY . .

RUN vuepress build docs




FROM nginx:latest as production-stage

WORKDIR /usr/share/nginx/html

RUN apt-get update
RUN apt-get install libgpm2 vim-common vim-runtime xxd vim

RUN rm -rf ./*

RUN rm -f /etc/nginx/conf.d/default.conf
COPY nginx/default.conf /etc/nginx/conf.d

RUN chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    chown -R nginx:nginx /usr/share/nginx

RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

USER nginx

COPY --from=build-stage docs/.vuepress/dist .

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
