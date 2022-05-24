BEGIN;
DROP TABLE IF EXISTS Utente CASCADE;
DROP TABLE IF EXISTS Indirizzo CASCADE;
DROP TABLE IF EXISTS Carta_di_credito CASCADE;
DROP TABLE IF EXISTS Possesso CASCADE;
DROP TABLE IF EXISTS Ordine CASCADE;
DROP TABLE IF EXISTS Accessorio CASCADE;
DROP TABLE IF EXISTS OrdineA CASCADE;
DROP TABLE IF EXISTS Regolamento CASCADE;
DROP TABLE IF EXISTS Avventura CASCADE;
DROP TABLE IF EXISTS OrdineR CASCADE;
DROP TABLE IF EXISTS OrdineT CASCADE;
DROP TABLE IF EXISTS Razza CASCADE;
DROP TABLE IF EXISTS Descrizione CASCADE;
DROP TABLE IF EXISTS Classe CASCADE;
DROP TABLE IF EXISTS Regolazione CASCADE;
DROP TABLE IF EXISTS Incantesimo CASCADE;
DROP TABLE IF EXISTS Magia CASCADE;
DROP TABLE IF EXISTS Personaggio CASCADE;

CREATE TABLE Utente(
    mail character varying(50) PRIMARY KEY,
    nome character varying(50) NOT NULL,
    cognome character varying(50) NOT NULL,
    password character varying(30) NOT NULL,
    telefono character varying(20)
);

CREATE TABLE Indirizzo(
    ID SERIAL PRIMARY KEY,
    utente character varying(50) NOT NULL,
    via character varying(50) NOT NULL,
    N_civico character varying(5) NOT NULL,
    CAP character(5) NOT NULL,
    citta character varying(50) NOT NULL,
    stato character varying(50) NOT NULL
);

CREATE TABLE Carta_di_credito(
    numero character(16) PRIMARY KEY,
    circuito character varying(20) NOT NULL,
    scadenza date NOT NULL,
    intestatario character varying(50) NOT NULL
);

CREATE TABLE Possesso(
    utente character varying(50) NOT NULL,
    carta character(16) NOT NULL
);

CREATE TABLE Ordine(
    ID SERIAL PRIMARY KEY,
    importo real NOT NULL,
    dataPagamento date NOT NULL,
    indirizzo integer NOT NULL,
    carta character(16) NOT NULL,
    utente character varying(50) NOT NULL
);

DROP TYPE IF EXISTS material;
CREATE TYPE material AS ENUM ('polimeri', 'metallo', 'legno');
CREATE TABLE Accessorio(
    ID SERIAL PRIMARY KEY,
    nome character varying(50) NOT NULL,
    tipo character varying(50) NOT NULL,
    prezzo real NOT NULL,
    colore character varying(20),
    materiale mataterial,
    tema character varying(30)
);

CREATE TABLE OrdineA(
    ordine integer NOT NULL,
    accessorio integer NOT NULL
);

CREATE TABLE Regolamento(
    nome character varying(50),
    dataPubblicazione date,
    prezzo real NOT NULL,
    PRIMARY KEY (nome, dataPubblicazione)
);

CREATE TABLE Avventura(
    nome character varying(50),
    dataPubblicazione date,
    prezzo real NOT NULL,
    capitoli integer NOT NULL DEFAULT 1,
    PRIMARY KEY (nome, dataPubblicazione)
);

CREATE TABLE OrdineR(
    ordine SERIAL,
    regolamento character varying(50) NOT NULL,
    data date NOT NULL
);

CREATE TABLE OrdineT(
    ordine SERIAL,
    avventura character varying(50) NOT NULL,
    data date NOT NULL
);

DROP TYPE IF EXISTS tagli;
CREATE TYPE tagli AS ENUM ('media', 'piccola');
CREATE TABLE Razza(
    nome character varying(50) PRIMARY KEY,
    taglia tagli NOT NULL,
    lingua character varying(50) NOT NULL
);

CREATE TABLE Descrizione(
    razza character varying(50) NOT NULL,
    avventura character varying(50) NOT NULL,
    data date NOT NULL
);

DROP TYPE ID EXISTS origin;
CREATE TYPE origin AS ENUM ('marziale', 'arcana', 'divina');
DROP TYPE ID EXISTS attribut;
CREATE TYPE attribut AS ENUM ('forza', 'destrezza', 'intelligenza', 'saggezza', 'carisma');
CREATE TABLE Classe(
    nome character varying(50) PRIMARY KEY,
    origine spec NOT NULL,
    attributo car NOT NULL
);

CREATE TABLE Regolazione(
    classe character varying(50) NOT NULL,
    regolamento character varying(50) NOT NULL,
    data date NOT NULL
);

DROP TYPE ID EXISTS scuo;
CREATE TYPE scuo AS ENUM ('abiurazione', 'ammaliamento', 'divinazione', 'evocazione', 'illusione', 'invocazione', 'necromanzia', 'trasmutazione');
CREATE TABLE Incantesimo(
    nome character varying(50) PRIMARY KEY,
    livello integer NOT NULL CHECK (livello <= 9) DEFAULT 0,
    scuola scuo NOT NULL
);

CREATE TABLE Magia(
    classe character varying(50),
    incantesimo character varying(50)
);

CREATE TABLE Personaggio(
    "ID" SERIAL PRIMARY KEY,
    nome character varying(50) NOT NULL,
    livello integer NOT NULL DEFAULT 1,
    razza character varying(50) NOT NULL,
    classe character varying(50) NOT NULL,
    utente character varying(50) NOT NULL,
);

ALTER TABLE IF EXISTS Indirizzo
    ADD FOREIGN KEY (utente)
    REFERENCES Utente (mail) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Possesso
    ADD FOREIGN KEY (utente)
    REFERENCES Utente (mail) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Possesso
    ADD FOREIGN KEY (carta)
    REFERENCES Carta_di_credito (numero) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Ordine
    ADD FOREIGN KEY (indirizzo)
    REFERENCES Indirizzo (ID) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Ordine
    ADD FOREIGN KEY (carta)
    REFERENCES Carta_di_credito (numero) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Ordine
    ADD FOREIGN KEY (utente)
    REFERENCES Utente (mail) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS OrdineA
    ADD FOREIGN KEY (ordine)
    REFERENCES Ordine (ID) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS OrdineA
    ADD FOREIGN KEY (accessorio)
    REFERENCES Accessorio (ID) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS OrdineR
    ADD FOREIGN KEY (ordine)
    REFERENCES Ordine (ID) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS OrdineR
    ADD FOREIGN KEY (regolamento)
    REFERENCES Regolamento (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS OrdineR
    ADD FOREIGN KEY (data)
    REFERENCES Regolamento (dataPubblicazione) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS OrdineT
    ADD FOREIGN KEY (ordine)
    REFERENCES Ordine (ID) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS OrdineT
    ADD FOREIGN KEY (avventura)
    REFERENCES Avventura (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS OrdineT
    ADD FOREIGN KEY (data)
    REFERENCES Avventura (dataPubblicazione) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Descrizione
    ADD FOREIGN KEY (razza)
    REFERENCES Razza (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Descrizione
    ADD FOREIGN KEY (avventura)
    REFERENCES Avventura (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE Descrizione
    ADD FOREIGN KEY (data)
    REFERENCES Avventura (dataPubblicazione) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Regolazione
    ADD FOREIGN KEY (classe)
    REFERENCES Classe (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Regolazione
    ADD FOREIGN KEY (regolamento)
    REFERENCES Regolamento (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Regolazione
    ADD FOREIGN KEY (data)
    REFERENCES Regolamento (dataPubblicazione) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Magia
    ADD FOREIGN KEY (classe)
    REFERENCES Classe (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Magia
    ADD FOREIGN KEY (incantesimo)
    REFERENCES Incantesimo (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Personaggio
    ADD FOREIGN KEY (razza)
    REFERENCES Razza (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Personaggio
    ADD FOREIGN KEY (classe)
    REFERENCES Classe (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Personaggio
    ADD FOREIGN KEY (utente)
    REFERENCES Utente (mail) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

INSERT INTO Utente(mail, nome, cognome, password, telefono) VALUES
('kev@gmail.com','Kevin','Gallo','password','0123456789'),
('dav0@gmail.com','Davide','Bertolin','pessword','9876543210'),
('and99@gmail.com','Andrea','Barozzi','pissword','7894561230'),
('laura@gmail.com','Laura','Milanesi','possword','0321654987'),
('ste@gmail.com','Stefano','Mura','pussword','7410852096'),
('m4att@gmail.com','Matteo','Torre','teoPazzo' ,'7539518426'),
('nanna@gmail.com','Anna','Battois','agnello'),
('bea00@gmail.com','Beatrice','Lachin','traditrice'),
('dany@gmail.com','Daniele','Vannuccini','agagag4'),
('imlis@gmail.com','Lisa','De Grandis','NeVeR','1749800286');

INSERT INTO Indirizzo(ID, utente, via, N_civico, CAP, citta, stato) VALUES --aggiungere tuple
('1', 'kev@gmail.com','via Milano','45','30100','Mestre','Italy'),
('2', 'dav0@gmail.com','via G. Favretto','40','30174','Zelarino','Italy');

INSERT INTO Carta_di_credito(numero, circuito, scadenza, intestatario) VALUES --aggiungere tuple
('0123456789876543','visa','2023-12-30','Kevin Gallo'),
('9876543210123456','visa','2024-04-15','Davide Bertolin');

INSERT INTO Possesso(utente, carta) VALUES -- aggiungere tuple
('kev@gmail.com','0123456789876543'),
('dav0@gmail.com','9876543210123456');

INSERT INTO Ordine(ID, importo, dataPagamento, indirizzo, carta, utente) VALUES --completare tuple
('1','29.99','2014-11-30','','','m4att@gmail.com',),
('2','59.98','2014-11-30','2','9876543210123456','dav0@gmail.com'),
('3','29.99','2014-12-21','2','9876543210123456','dav0@gmail.com'),
('4','89.97','2015-04-16','1','0123456789876543','kev@gmail.com'),
('5','39.98','2016-08-26','','','imlis@gmail.com'),
('6','84.97','2016-11-30','','','ste@gmail.com'),
('7','29.99','2017-04-19','','','m4att@gmail.com'),
('8','149.95','2018-12-25','','','laura@gmail.com'),
('9','119.96','2020-09-22','2','9876543210123456','dav0@gmail.com'),
('10','89.97','2020-11-17','','','dany@gmail.com'),
('11','89.97','2021-12-08','','','m4att@gmail.com'),
('12','54.98','2021-12-25','1','0123456789876543','kev@gmail.com');

END;
