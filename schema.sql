--Projeto de BD - entrega 3
--Criacao do esquema de base de dados

DROP TABLE IF EXISTS local_publico CASCADE;
DROP TABLE IF EXISTS item CASCADE;
DROP TABLE IF EXISTS anomalia CASCADE;
DROP TABLE IF EXISTS anomalia_traducao CASCADE;
DROP TABLE IF EXISTS duplicado CASCADE;
DROP TABLE IF EXISTS utilizador CASCADE;
DROP TABLE IF EXISTS utilizador_qualificado CASCADE;
DROP TABLE IF EXISTS utilizador_regular CASCADE;
DROP TABLE IF EXISTS incidencia CASCADE;
DROP TABLE IF EXISTS proposta_de_correcao CASCADE;
DROP TABLE IF EXISTS correcao CASCADE;

/**/
CREATE TABLE local_publico(
    latitude DECIMAL(8,6),
    longitude DECIMAL(9,6),
    nome VARCHAR(30),
    PRIMARY KEY(latitude, longitude)
);

/**/
CREATE TABLE item (
    id INT,
    descricao VARCHAR(50),
    localizacao VARCHAR(80),
    latitude DECIMAL(8,6),
    longitude DECIMAL(9,6),
    PRIMARY KEY (id),
    FOREIGN KEY (latitude, longitude) REFERENCES local_publico
    ON DELETE CASCADE ON UPDATE CASCADE
);
/**/
CREATE TABLE anomalia(
    id INT,
    zona BOX,
    imagem VARCHAR(100),
    lingua VARCHAR(20),
    ts TIMESTAMP,
    descricao VARCHAR(50),
    tem_anomalia_redacao BOOLEAN,
    PRIMARY KEY (id)
);
/**/
CREATE TABLE anomalia_traducao(
    id INT,
    zona2 BOX,
    lingua2 VARCHAR(20),
    PRIMARY KEY(id),
    FOREIGN KEY (id) REFERENCES anomalia
    ON DELETE CASCADE ON UPDATE CASCADE
);
/**/
CREATE TABLE utilizador(
    email VARCHAR(20),
    pass VARCHAR(20),
    PRIMARY KEY (email)
);
/**/
CREATE TABLE incidencia(
    anomalia_id INT,
    item_id INT,
    email VARCHAR(20),
    PRIMARY KEY (anomalia_id),
    FOREIGN KEY (anomalia_id) REFERENCES anomalia,
    FOREIGN KEY (item_id) REFERENCES item
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (email) REFERENCES utilizador
    ON DELETE CASCADE ON UPDATE CASCADE
);
/**/
CREATE TABLE duplicado(
    item1 INT,
    item2 INT,
    PRIMARY KEY(item1, item2),
    FOREIGN KEY (item1) REFERENCES item
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (item2) REFERENCES item
    ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK(item1 < item2)
);
/**/
CREATE TABLE utilizador_qualificado(
    email VARCHAR(20),
    PRIMARY KEY (email),
    FOREIGN KEY (email) REFERENCES utilizador
    ON DELETE CASCADE ON UPDATE CASCADE
);
/**/
CREATE TABLE utilizador_regular(
    email VARCHAR(20),
    PRIMARY KEY (email),
    FOREIGN KEY (email) REFERENCES utilizador
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE proposta_de_correcao(
    email VARCHAR(20),
    nro INT,
    data_hora TIMESTAMP,
    texto VARCHAR(80),
    PRIMARY KEY(email, nro),
    FOREIGN KEY(email) REFERENCES utilizador_qualificado
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE correcao(
    email VARCHAR(20),
    nro INT,
    anomalia_id INT,
    PRIMARY KEY (email, nro, anomalia_id),
    FOREIGN KEY (email, nro) REFERENCES proposta_de_correcao
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (anomalia_id) REFERENCES incidencia
    ON DELETE CASCADE ON UPDATE CASCADE
);
