FROM ubuntu:latest

RUN apt-get update && apt-get install -y bash ttyd postgresql-client

RUN mkdir -p /home/juego

COPY *.sh /home/juego
RUN chmod +x /home/juego/*.sh

COPY start.sh /home/juego/start.sh
RUN chmod +x /home/juego/start.sh

WORKDIR /home/juego

CMD ["sh", "-c", "ttyd --writable -p ${JUEGO_CONTAINER_PORT} bash -i /home/juego/start.sh"]