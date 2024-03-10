 # :video_game: DockerGameApp :video_game:

- El repositorio ofrece el juego "Number guess" en donde la meta es sencilla: adivinar un numero al azar entre 1 y 1000, en la menor cantidad de intentos posibles.

- Al inicio de la partida debes ingresar un nombre con el que se reconocerá si el jugador tiene partidas anteriores.

- Si las tiene se le informará de su mejor marca, esto es, la partida en la que acertó con menos intentos.

- Cuando finalmente adivina el número se registra en la base de datos y se termina el juego.

### A nivel técnico:

Se levantan 3 contenedores de docker, cada uno con una de las siguientes imagenes:
1) **Ubuntu**:

   - Contiene el script del juego en la ruta `home/juego/number_guess.sh`.
   
   - Tambien instala postgres-client para hacer uso de comandos postgres dentro del juego.

   - Los detalles de este contenedor se encuentran en el Dockerfile.
3) **Postgres**:
   
   - Contiene a la base de datos, con las tablas de "jugadores" y "partidas"
5) **pgAdmin**:
   
   - Contiene al administrador de bases de datos y se puede hacer uso de este en la maquina local desde el navegador en el localhost(puerto 80) con un usuario y contraseña.

     **user**: `admin@gmail.com`
   
     **password**: `password`.
   

El cambio de cualquier parametro como puertos o las mismas credenciales se puede hacer desde el archivo docker-compose
   
## Modo de uso

1) Tener instalado docker
2) Descargar o clonar el repositorio en alguna carpeta
3) Ejecutar el comando `docker-compose up -d` en el directorio donde se encuentre el archivo docker-compose
4) Ejecutar el comando `docker exec -it app-juego-1 bash home/juego/number_guess.sh`
5) Jugar! :space_invader:
