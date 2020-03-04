ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS';
SELECT SESSIONTIMEZONE, CURRENT_TIMESTAMP FROM DUAL;

--  Tabela Origem do Exemplar
DROP TABLE  origem_exemplar CASCADE CONSTRAINTS;
CREATE TABLE origem_exemplar
(
  cod_origem    CHAR(1)   PRIMARY KEY,
  tipo_origem   CHAR(10)  NOT NULL CHECK (tipo_origem IN('doacao','compra')) --não há necessidade do not null.
);
DESC origem_exemplar;

-- Tabela categoria do livro
DROP TABLE categoria_livro CASCADE CONSTRAINTS;
CREATE TABLE categoria_livro
(
  cd_categ    INTEGER       PRIMARY KEY,
  descr_categ VARCHAR2(30)  NOT NULL
);  

--Tabela Autor
DROP TABLE autor CASCADE CONSTRAINTS;
CREATE TABLE autor
(
  cod_autor           INTEGER       PRIMARY KEY,
  nome_autor          VARCHAR2(50)  NOT NULL,
  nacionalidade_autor CHAR(20)      
);

--Tabela Usuário
DROP TABLE usuario cascade constraints;
CREATE TABLE usuario
(
  cod_usuario           INTEGER       PRIMARY KEY,
  nome_usuario          VARCHAR2(2)    NOT NULL,
  end_usuario           VARCHAR2(100)  NOT NULL,
  fone_usuario          CHAR(11),
  sexo_usuario          CHAR(1)       CHECK(sexo_usuario IN('M','F')),
  dt_nascto_usuario     DATE,
  cpf_usuario           CHAR(11)      NOT NULL,
  rg_usuario            CHAR(9)       NOT NULL,
  tipo_usuario          CHAR(1)       CHECK(tipo_usuario  IN('A','P','F')),
  tipo_identificador    CHAR(9)       CHECK(tipo_identificador IN('RA','Funcional')),
  numero_identificador  CHAR(15)      NOT NULL,
  area_vinculacao       CHAR(20),
  cargo                 CHAR(15),
  situacao_usuario      CHAR(15)      NOT NULL
);  

--Tabela editora
DROP TABLE  editora CASCADE CONSTRAINTS;
CREATE TABLE  editora
(
  cod_editora             CHAR(5)     PRIMARY KEY,
  nome_editora            VARCHAR2(50) NOT NULL,
  nacionalidade_editora   CHAR(20)    NOT NULL,
  end_ediotra             VARCHAR2(100) ,
  contato_editora         VARCHAR2(30)
  
);

--Tabela livro
DROP TABLE livro CASCADE CONSTRAINTS;
CREATE TABLE livro
(
  cod_livro       CHAR(10)      PRIMARY KEY,
  titulo_livro    VARCHAR2(50)   NOT NULL,
  titulo_original VARCHAR2(50),
  idioma_original CHAR(20)      NOT NULL,
  situacao_livro  CHAR(15)      NOT NULL,
  cod_editora     CHAR(5)       NOT NULL,
  cod_categ       INTEGER       NOT NULL,
  FOREIGN KEY     (cod_editora) REFERENCES editora,
  FOREIGN KEY     (cod_categ)   REFERENCES categoria_livro
);

--Tabela exemplar
DROP TABLE exemplar CASCADE CONSTRAINTS;
CREATE TABLE exemplar
(
  ISBN              NUMBER(14)    NOT NULL,
  num_exemplar      NUMBER(2)     NOT NULL,
  num_edicao        INTEGER       NOT NULL,
  qtde_paginas      INTEGER,
  ano_publicacao    INTEGER       NOT NULL,
  idioma_exemplar   CHAR(20)      NOT NULL,
  valor_exemplar    NUMBER(12,2)  NOT NULL,
  localizacao       CHAR(11)      CHECK(localizacao IN('Acervo','Circulante')),
  cod_origem        CHAR(1)       NOT NULL REFERENCES origem_exemplar, --Já é criado a chave estrangeira, sem a necessidade do comando FOREIGN KEY.
  cod_livro         CHAR(10)      NOT NULL REFERENCES livro,
  obs_exemplar      VARCHAR(100),
  situacao_exemplar CHAR(15)      NOT NULL,
  PRIMARY KEY (ISBN, num_exemplar) --criado a chave primária COMPOSTA
);

--Tabela autoria
DROP TABLE autoria CASCADE CONSTRAINTS
CREATE TABLE autoria
(
  cod_livro     CHAR(10)    REFERENCES  livro,
  cod_autor     INTEGER     REFERENCES  autor,
  tipo_autoria  CHAR(8)     CHECK(tipo_autoria IN ('Principal','Co-autor')),
  PRIMARY KEY (cod_livro, cod_autor)
);

--Tabela reserva
DROP TABLE reserva CASCADE CONSTRAINTS;
CREATE TABLE reserva
(
  num_reserva       INTEGER     PRIMARY KEY,
  dt_hora_reserva   TIMESTAMP   NOT NULL,
  prazo_reserva     TIMESTAMP,
  situacao_reserva  CHAR(15),
  cod_usuario_prof  INTEGER   NOT NULL  REFERENCES  usuario

);
  
--Tabela itens reserva
DROP TABLE itens_reserva  CASCADE CONSTRAINTS
CREATE TABLE itens_reserva
(
  num_reserva   INTEGER   NOT NULL  REFERENCES reserva,
  cod_livro     CHAR(10)  NOT NULL  REFERENCES livro,
  PRIMARY KEY (num_reserva, cod_livro)
);

--Tabela Empréstimo
DROP TABLE emprestimo CASCADE CONSTRAINTS;
CREATE TABLE emprestimo
(
  num_emprestimo    INTEGER   PRIMARY KEY,
  dt_hora_empret    TIMESTAMP NOT NULL,
  dt_hora_devolucao TIMESTAMP,
  valor_multa       NUMBER(12,2),
  situacao_empret   CHAR(15)  NOT NULL,
  cod_usuario       INTEGER   NOT NULL REFERENCES usuario,
  num_reserva       INTEGEr            REFERENCES reserva
  );
  
--Table itens de emprestimo
DROP TABLE itens_emprestimo;
CREATE TABLE itens_emprestimo
(  
  num_emprestimo            INTEGER     NOT NULL  REFERENCES emprestimo,
  ISBN                      NUMBER(14)  NOT NULL,
  num_exemplar              NUMBER(2)   NOT NULL,
  dt_hora_devolucao         TIMESTAMP,
  situacao_itens_emprestimo CHAR(15)    NOT NULL,
  PRIMARY KEY( num_emprestimo, ISBN, num_exemplar), --Neste caso especificar chave primaria juntos, pois são compostas.
  FOREIGN KEY(ISBN, num_exemplar)
  REFERENCES exemplar
);
