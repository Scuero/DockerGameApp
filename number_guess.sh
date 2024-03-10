#!/bin/bash

export PGPASSWORD=password
PSQL="psql -h app-postgres-1 --dbname=number_guess --username=admin -p 5432 --no-align --tuples-only -c"

MAIN(){
  echo "Ingresa tu nombre:"
  read USERNAME
  if [[ -z $USERNAME || ${#USERNAME} -gt 22 ]]
  then
    MAIN
  fi
  BIENVENIDA_DE_USUARIO
  OBTENER_ID_JUGADOR
  INICIALIZAR_JUEGO
  EMPEZAR_A_JUGAR
}

BIENVENIDA_DE_USUARIO(){
  ID_USUARIO=$($PSQL "SELECT user_id FROM usuarios WHERE '$USERNAME'=username")
  
  if [[ -z $ID_USUARIO ]]
  then
    AGREGAR_NUEVO_USUARIO
    MOSTRAR_NUEVO_USUARIO
  fi

  if [[ $ID_USUARIO ]]
  then
    MOSTRAR_METRICAS_DE_USUARIO_EXISTENTE
  fi
}

MOSTRAR_METRICAS_DE_USUARIO_EXISTENTE(){
  NOMBRE=$($PSQL "SELECT username FROM usuarios WHERE user_id=$ID_USUARIO")
  JUEGOS_JUGADOS=$($PSQL "SELECT COUNT(*) FROM games INNER JOIN usuarios USING(user_id) WHERE user_id=$ID_USUARIO")
  MINIMOS_INTENTOS=$($PSQL "SELECT MIN(guesses) FROM games INNER JOIN usuarios USING(user_id) WHERE user_id=$ID_USUARIO")
  echo "Bienvenido de vuelta, $NOMBRE! haz jugado $JUEGOS_JUGADOS partidas, y tu mejor juego tuvo $MINIMOS_INTENTOS intentos."
}

MOSTRAR_NUEVO_USUARIO(){
  echo "Bienvenido, $USERNAME parece que es tu primera vez aqui."
}

AGREGAR_NUEVO_USUARIO(){
  RES=$($PSQL "INSERT INTO usuarios(username) VALUES('$USERNAME')")
}

OBTENER_ID_JUGADOR(){
  ID_JUGADOR=$($PSQL "SELECT user_id FROM usuarios WHERE username='$USERNAME'")
}

INICIALIZAR_JUEGO(){
  CANTIDAD_INTENTOS=0
  DAR_RANDOM
  echo "Adivina el numero secreto entre 1 y 1000:"
}

DAR_RANDOM(){
  NUMERO_RANDOM=$((1 + RANDOM % 1000))
}

CHEQUEAR_NUMERO(){
  if [[ $NUMERO_INGRESADO == $NUMERO_RANDOM ]]
  then
    GRABAR_JUEGO_EN_BD
    echo "Adivinista en $CANTIDAD_INTENTOS intentos. El numero secreto era $NUMERO_RANDOM. Buen trabajo!"
    exit
  fi

  if [[ $NUMERO_INGRESADO > $NUMERO_RANDOM ]]
  then
    echo "Es menor que eso, adivina denuevo:"
    EMPEZAR_A_JUGAR
  fi

  if [[ $NUMERO_INGRESADO < $NUMERO_RANDOM ]]
  then
    echo "Es mayor que eso, adivina denuevo:"
    EMPEZAR_A_JUGAR
  fi
}

INCREMENTAR_NUMERO_INTENTOS(){
  CANTIDAD_INTENTOS=$((CANTIDAD_INTENTOS+1))
}

GRABAR_JUEGO_EN_BD(){
  RES=$($PSQL "INSERT INTO games(guesses, user_id) VALUES($CANTIDAD_INTENTOS, $ID_JUGADOR)")
}

EMPEZAR_A_JUGAR(){
  read NUMERO_INGRESADO
  if [[ ! $NUMERO_INGRESADO =~ ^[0-9]+$ ]]
  then
    echo "Eso no es un numero, intenta denuevo:"
    EMPEZAR_A_JUGAR
  else
    INCREMENTAR_NUMERO_INTENTOS
    CHEQUEAR_NUMERO
  fi
}

MAIN