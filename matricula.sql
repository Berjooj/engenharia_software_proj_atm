-- Diagrama de classe
-- SQL do banco

CREATE TABLE IF NOT EXISTS campus(
	id BIGINT NOT NULL UNIQUE,
	nome VARCHAR(100) NOT NULL,
	endereco VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS predios(
	id BIGINT NOT NULL UNIQUE,
	nome VARCHAR(100) NOT NULL,
	id_campus BIGINT NOT NULL,
	qtd_andares INT NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS salas(
	id BIGINT NOT NULL UNIQUE,
	nome VARCHAR(100) NOT NULL,
	id_predio BIGINT NOT NULL,
	capacidade INT NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS usuario(
	id BIGINT NOT NULL UNIQUE,
	nome VARCHAR(100) NOT NULL,
	cpf VARCHAR(100) NOT NULL UNIQUE,
	ra VARCHAR(100) NOT NULL UNIQUE,
	email VARCHAR(100) NOT NULL UNIQUE,
	telefone VARCHAR(100) NOT NULL,
	endereco VARCHAR(255) NOT NULL,
	is_professor BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS conteudo_curricular(
	id BIGINT NOT NULL UNIQUE,
	titulo VARCHAR(100) NOT NULL,
	descricao TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS planos_curriculares(
	id BIGINT NOT NULL UNIQUE,
	titulo VARCHAR(100) NOT NULL,
	descricao TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS conteudo_plano_curricular(
	id_conteudo_curricular BIGINT NOT NULL,
	id_plano_curricular BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS unidade_curricular(
	id BIGINT NOT NULL UNIQUE,
	nome VARCHAR(100) NOT NULL,
	carga_horaria INT NOT NULL DEFAULT 0,
	id_plano_curricular BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS turmas(
	id BIGINT NOT NULL UNIQUE,
	nome VARCHAR(100) NOT NULL,
	id_unidade_curricular BIGINT NOT NULL,
	id_professor BIGINT NOT NULL,
	dia_semana INT NOT NULL,
	hora_inicio INT NOT NULL,
	hora_fim INT NOT NULL
);

CREATE TABLE IF NOT EXISTS sala_turma(
	id_sala BIGINT NOT NULL,
	id_turma BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS matriculas(
	id BIGINT NOT NULL UNIQUE,
	id_usuario BIGINT NOT NULL,
	id_turma BIGINT NOT NULL,
	nota_n1 NUMERIC(10,2) NOT NULL DEFAULT 0,
	nota_n2 NUMERIC(10,2) NOT NULL DEFAULT 0,
	nota_subst NUMERIC(10,2) NOT NULL DEFAULT 0,
	media NUMERIC(10,2) NOT NULL DEFAULT 0,
	faltas INT NOT NULL DEFAULT 0,
	dt_matricula TIMESTAMP NOT NULL DEFAULT NOW(),
	dt_cancelamento TIMESTAMP NULL,
	ano INT NOT NULL,
	semestre INT NOT NULL
);

CREATE SEQUENCE IF NOT EXISTS campus_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

CREATE SEQUENCE IF NOT EXISTS predios_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

CREATE SEQUENCE IF NOT EXISTS salas_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

CREATE SEQUENCE IF NOT EXISTS usuario_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

CREATE SEQUENCE IF NOT EXISTS conteudo_curricular_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

CREATE SEQUENCE IF NOT EXISTS planos_curriculares_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

CREATE SEQUENCE IF NOT EXISTS unidade_curricular_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

CREATE SEQUENCE IF NOT EXISTS turmas_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

CREATE SEQUENCE IF NOT EXISTS matriculas_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

ALTER TABLE campus ALTER COLUMN id SET DEFAULT NEXTVAL('campus_seq');
ALTER TABLE predios ALTER COLUMN id SET DEFAULT NEXTVAL('predios_seq');
ALTER TABLE salas ALTER COLUMN id SET DEFAULT NEXTVAL('salas_seq');
ALTER TABLE usuario ALTER COLUMN id SET DEFAULT NEXTVAL('usuario_seq');
ALTER TABLE conteudo_curricular ALTER COLUMN id SET DEFAULT NEXTVAL('conteudo_curricular_seq');
ALTER TABLE planos_curriculares ALTER COLUMN id SET DEFAULT NEXTVAL('planos_curriculares_seq');
ALTER TABLE unidade_curricular ALTER COLUMN id SET DEFAULT NEXTVAL('unidade_curricular_seq');
ALTER TABLE turmas ALTER COLUMN id SET DEFAULT NEXTVAL('turmas_seq');
ALTER TABLE matriculas ALTER COLUMN id SET DEFAULT NEXTVAL('matriculas_seq');

ALTER TABLE predios ADD CONSTRAINT fk_campus FOREIGN KEY (id_campus) REFERENCES campus(id);
ALTER TABLE salas ADD CONSTRAINT fk_predios FOREIGN KEY (id_predio) REFERENCES predios(id);
ALTER TABLE conteudo_plano_curricular ADD CONSTRAINT fk_conteudo_curricular FOREIGN KEY (id_conteudo_curricular) REFERENCES conteudo_curricular(id);
ALTER TABLE conteudo_plano_curricular ADD CONSTRAINT fk_plano_curricular FOREIGN KEY (id_plano_curricular) REFERENCES planos_curriculares(id);
ALTER TABLE unidade_curricular ADD CONSTRAINT fk_plano_curricular FOREIGN KEY (id_plano_curricular) REFERENCES planos_curriculares(id);
ALTER TABLE turmas ADD CONSTRAINT fk_unidade_curricular FOREIGN KEY (id_unidade_curricular) REFERENCES unidade_curricular(id);
ALTER TABLE turmas ADD CONSTRAINT fk_professor FOREIGN KEY (id_professor) REFERENCES usuario(id);
ALTER TABLE sala_turma ADD CONSTRAINT fk_sala FOREIGN KEY (id_sala) REFERENCES salas(id);
ALTER TABLE sala_turma ADD CONSTRAINT fk_turma FOREIGN KEY (id_turma) REFERENCES turmas(id);
ALTER TABLE matriculas ADD CONSTRAINT fk_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id);
ALTER TABLE matriculas ADD CONSTRAINT fk_turma FOREIGN KEY (id_turma) REFERENCES turmas(id);

CREATE UNIQUE INDEX IF NOT EXISTS idx_conteudo_curricular_01 ON conteudo_curricular (titulo, descricao);

CREATE OR REPLACE FUNCTION tf_valida_professor () RETURNS trigger AS
$$
	DECLARE
		professor RECORD;
	BEGIN
		SELECT * FROM usuario WHERE id = NEW.id_professor AND is_professor = TRUE INTO professor;

		IF professor.id IS NULL THEN
			RAISE EXCEPTION 'Usuário informado não é um professor';
		END IF;

		RETURN NEW;
	END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER t_valida_professor
	BEFORE INSERT ON turmas
	FOR EACH ROW EXECUTE PROCEDURE tf_valida_professor();