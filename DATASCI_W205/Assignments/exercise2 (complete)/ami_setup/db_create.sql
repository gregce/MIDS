DROP DATABASE IF EXISTS tcount;

CREATE DATABASE tcount
   WITH OWNER postgres 
   TEMPLATE template0
   ENCODING 'UTF8'
   TABLESPACE  pg_default
   LC_COLLATE  'en_US.UTF-8'
   LC_CTYPE  'en_US.UTF-8'
   CONNECTION LIMIT  -1;

\connect tcount

CREATE TABLE Tweetwordcount
       (word TEXT NOT NULL,
       count INT NOT NULL);
