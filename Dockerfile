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

RUN yarn docs:build



EXPOSE 8080
CMD [ "node", "server.js" ]
