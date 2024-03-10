FROM ubuntu:latest

RUN apt-get update && apt-get install -y bash

RUN mkdir /home/juego

COPY *.sh /home/juego

RUN chmod +x /home/juego/*.sh

RUN apt update && apt install -y postgresql-client