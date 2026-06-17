FROM node:7.8.0
WORKDIR /opt
ADD . /opt
RUN npm install
ENV HOST=0.0.0.0
EXPOSE 3000
ENTRYPOINT npm run start
