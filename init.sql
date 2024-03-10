-- Este es una especie de script sql que no solo crea tablas
-- Ademas antes de eso crea una database <number_guess> y luego se conecta a ella
-- configura algunos parametros, crea tablas y las llena con algunos datos

CREATE DATABASE number_guess WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';

\connect number_guess

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;


CREATE TABLE public.games (
    game_id integer NOT NULL,
    guesses integer NOT NULL,
    user_id integer
);



CREATE SEQUENCE public.games_game_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.games_game_id_seq OWNED BY public.games.game_id;


CREATE TABLE public.usuarios (
    user_id integer NOT NULL,
    username character varying(22) NOT NULL
);

CREATE SEQUENCE public.usuarios_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_user_id_seq OWNED BY public.usuarios.user_id;

ALTER TABLE ONLY public.games ALTER COLUMN game_id SET DEFAULT nextval('public.games_game_id_seq'::regclass);

ALTER TABLE ONLY public.usuarios ALTER COLUMN user_id SET DEFAULT nextval('public.usuarios_user_id_seq'::regclass);

-- SI quiero que mis id comiencen desde otr numero distinto de 1:
--SELECT pg_catalog.setval('public.games_game_id_seq', <numero>, true);
--SELECT pg_catalog.setval('public.usuarios_user_id_seq', <numero>, true);

ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_pkey PRIMARY KEY (game_id);


ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (user_id);


ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_username_key UNIQUE (username);


ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.usuarios(user_id);


--
-- PostgreSQL database dump complete
--

