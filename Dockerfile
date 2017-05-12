FROM alpine
RUN apk update && apk upgrade && apk add nodejs git && npm install gulp coffee-script -g

WORKDIR /app
COPY . /app
RUN npm install && gulp build

EXPOSE 3000

CMD [ "npm", "start" ]