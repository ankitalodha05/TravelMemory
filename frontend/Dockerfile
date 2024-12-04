FROM ubuntu

WORKDIR /app

COPY . /app

RUN apt-get update && apt-get install -y npm \
    && npm install

EXPOSE 3000

CMD ["npm","start"]
