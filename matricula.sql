-- Diagrama de classe
-- SQL do banco

CREATE SCHEMA matriculas;

CREATE TABLE IF NOT EXISTS matriculas.campus(
	id BIGINT NOT NULL UNIQUE,
	nome VARCHAR(100) NOT NULL,
	endereco VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS matriculas.predios(
	id BIGINT NOT NULL UNIQUE,
	nome VARCHAR(100) NOT NULL,
	id_campus BIGINT NOT NULL,
	qtd_andares INT NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS matriculas.salas(
	id BIGINT NOT NULL UNIQUE,
	nome VARCHAR(100) NOT NULL,
	id_predio BIGINT NOT NULL,
	capacidade INT NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS matriculas.usuarios(
	id BIGINT NOT NULL UNIQUE,
	nome VARCHAR(100) NOT NULL,
	cpf VARCHAR(100) NOT NULL UNIQUE,
	ra VARCHAR(100) NOT NULL UNIQUE,
	email VARCHAR(100) NOT NULL UNIQUE,
	telefone VARCHAR(100) NOT NULL,
	endereco VARCHAR(255) NOT NULL,
	is_professor BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS matriculas.conteudos_curriculares(
	id BIGINT NOT NULL UNIQUE,
	titulo VARCHAR(100) NOT NULL,
	descricao TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS matriculas.planos_curriculares(
	id BIGINT NOT NULL UNIQUE,
	titulo VARCHAR(100) NOT NULL,
	descricao TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS matriculas.conteudo_plano_curricular(
	id_conteudo_curricular BIGINT NOT NULL,
	id_plano_curricular BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS matriculas.unidades_curriculares(
	id BIGINT NOT NULL UNIQUE,
	nome VARCHAR(100) NOT NULL,
	carga_horaria INT NOT NULL DEFAULT 0,
	id_plano_curricular BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS matriculas.turmas(
	id BIGINT NOT NULL UNIQUE,
	nome VARCHAR(100) NOT NULL,
	id_unidade_curricular BIGINT NOT NULL,
	id_professor BIGINT NOT NULL,
	dia_semana INT NOT NULL,
	hora_inicio INT NOT NULL,
	hora_fim INT NOT NULL
);

CREATE TABLE IF NOT EXISTS matriculas.sala_turma(
	id_sala BIGINT NOT NULL,
	id_turma BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS matriculas.matriculas(
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

CREATE SEQUENCE IF NOT EXISTS matriculas.campus_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

CREATE SEQUENCE IF NOT EXISTS matriculas.predios_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

CREATE SEQUENCE IF NOT EXISTS matriculas.salas_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

CREATE SEQUENCE IF NOT EXISTS matriculas.usuarios_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

CREATE SEQUENCE IF NOT EXISTS matriculas.conteudos_curriculares_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

CREATE SEQUENCE IF NOT EXISTS matriculas.planos_curriculares_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

CREATE SEQUENCE IF NOT EXISTS matriculas.unidades_curriculares_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

CREATE SEQUENCE IF NOT EXISTS matriculas.turmas_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

CREATE SEQUENCE IF NOT EXISTS matriculas.matriculas_seq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

ALTER TABLE matriculas.campus ALTER COLUMN id SET DEFAULT NEXTVAL('matriculas.campus_seq');
ALTER TABLE matriculas.predios ALTER COLUMN id SET DEFAULT NEXTVAL('matriculas.predios_seq');
ALTER TABLE matriculas.salas ALTER COLUMN id SET DEFAULT NEXTVAL('matriculas.salas_seq');
ALTER TABLE matriculas.usuarios ALTER COLUMN id SET DEFAULT NEXTVAL('matriculas.usuarios_seq');
ALTER TABLE matriculas.conteudos_curriculares ALTER COLUMN id SET DEFAULT NEXTVAL('matriculas.conteudos_curriculares_seq');
ALTER TABLE matriculas.planos_curriculares ALTER COLUMN id SET DEFAULT NEXTVAL('matriculas.planos_curriculares_seq');
ALTER TABLE matriculas.unidades_curriculares ALTER COLUMN id SET DEFAULT NEXTVAL('matriculas.unidades_curriculares_seq');
ALTER TABLE matriculas.turmas ALTER COLUMN id SET DEFAULT NEXTVAL('matriculas.turmas_seq');
ALTER TABLE matriculas.matriculas ALTER COLUMN id SET DEFAULT NEXTVAL('matriculas.matriculas_seq');

ALTER TABLE matriculas.predios ADD CONSTRAINT fk_campus FOREIGN KEY (id_campus) REFERENCES matriculas.campus(id);
ALTER TABLE matriculas.salas ADD CONSTRAINT fk_predios FOREIGN KEY (id_predio) REFERENCES matriculas.predios(id);
ALTER TABLE matriculas.conteudo_plano_curricular ADD CONSTRAINT fk_conteudo_curricular FOREIGN KEY (id_conteudo_curricular) REFERENCES matriculas.conteudos_curriculares(id);
ALTER TABLE matriculas.conteudo_plano_curricular ADD CONSTRAINT fk_plano_curricular FOREIGN KEY (id_plano_curricular) REFERENCES matriculas.planos_curriculares(id);
ALTER TABLE matriculas.unidades_curriculares ADD CONSTRAINT fk_plano_curricular FOREIGN KEY (id_plano_curricular) REFERENCES matriculas.planos_curriculares(id);
ALTER TABLE matriculas.turmas ADD CONSTRAINT fk_unidade_curricular FOREIGN KEY (id_unidade_curricular) REFERENCES matriculas.unidades_curriculares(id);
ALTER TABLE matriculas.turmas ADD CONSTRAINT fk_professor FOREIGN KEY (id_professor) REFERENCES matriculas.usuarios(id);
ALTER TABLE matriculas.sala_turma ADD CONSTRAINT fk_sala FOREIGN KEY (id_sala) REFERENCES matriculas.salas(id);
ALTER TABLE matriculas.sala_turma ADD CONSTRAINT fk_turma FOREIGN KEY (id_turma) REFERENCES matriculas.turmas(id);
ALTER TABLE matriculas.matriculas ADD CONSTRAINT fk_usuario FOREIGN KEY (id_usuario) REFERENCES matriculas.usuarios(id);
ALTER TABLE matriculas.matriculas ADD CONSTRAINT fk_turma FOREIGN KEY (id_turma) REFERENCES matriculas.turmas(id);

ALTER TABLE matriculas.campus ADD CONSTRAINT pk_campus PRIMARY KEY (id);
ALTER TABLE matriculas.predios ADD CONSTRAINT pk_predios PRIMARY KEY (id);
ALTER TABLE matriculas.salas ADD CONSTRAINT pk_salas PRIMARY KEY (id);
ALTER TABLE matriculas.usuarios ADD CONSTRAINT pk_usuarios PRIMARY KEY (id);
ALTER TABLE matriculas.conteudos_curriculares ADD CONSTRAINT pk_conteudos_curriculares PRIMARY KEY (id);
ALTER TABLE matriculas.planos_curriculares ADD CONSTRAINT pk_planos_curriculares PRIMARY KEY (id);
ALTER TABLE matriculas.unidades_curriculares ADD CONSTRAINT pk_unidades_curriculares PRIMARY KEY (id);
ALTER TABLE matriculas.turmas ADD CONSTRAINT pk_turmas PRIMARY KEY (id);
ALTER TABLE matriculas.sala_turma ADD CONSTRAINT pk_sala_turma PRIMARY KEY (id_sala, id_turma);
ALTER TABLE matriculas.matriculas ADD CONSTRAINT pk_matriculas PRIMARY KEY (id);

CREATE UNIQUE INDEX IF NOT EXISTS idx_conteudo_curricular_01 ON matriculas.conteudos_curriculares (titulo, descricao);

CREATE OR REPLACE FUNCTION matriculas.tf_valida_professor () RETURNS trigger AS
$$
	DECLARE
		professor RECORD;
	BEGIN
		SELECT * FROM usuarios WHERE id = NEW.id_professor AND is_professor = TRUE INTO professor;

		IF professor.id IS NULL THEN
			RAISE EXCEPTION 'Usuário informado não é um professor';
		END IF;

		RETURN NEW;
	END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER t_valida_professor
	BEFORE INSERT ON matriculas.turmas
	FOR EACH ROW EXECUTE PROCEDURE matriculas.tf_valida_professor();