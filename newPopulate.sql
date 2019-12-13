INSERT INTO d_utilizador(email, tipo)
	SELECT email, 'qualificado' FROM utilizador_qualificado natural join utilizador;

INSERT INTO d_utilizador(email, tipo)
	SELECT email, 'regular' FROM utilizador_regular natural join utilizador;

INSERT INTO d_tempo(dia, dia_da_semana, semana, mes, trimestre, ano)
	SELECT EXTRACT (day from ts) as dia,
			EXTRACT (D from ts) as dia_da_semana,
			EXTRACT (W from ts) as semana,
			EXTRACT (month from ts) as mes,
			EXTRACT (quarter from ts) as trimestre,
			EXTRACT (year from ts) as ano
	FROM anomalia
	ORDER BY dia, dia_da_semana, semana, mes, trimestre, ano;

INSERT INTO d_local(latitude, longitude, nome)
	SELECT latitude, longitude, nome FROM local_publico;

INSERT INTO d_lingua(lingua)
	SELECT lingua FROM anomalia;

INSERT INTO f_anomalia(id_utilizador, id_tempo, id_local, id_lingua)
	SELECT id_utilizador, id_tempo, id_local, id_lingua
	FROM d_utilizador
	natural join d_local
	natural join incidencia
	natural join d_lingua
	natural join anomalia X
	inner join d_tempo Y on
	(EXTRACT (day from X.ts) = Y.dia AND
	 cast(EXTRACT (D from X.ts) as varchar) like Y.dia_da_semana AND
	 cast(EXTRACT (W from X.ts) as varchar) like Y.semana AND
	 EXTRACT (month from X.ts) = Y.mes AND
	 EXTRACT (quarter from X.ts) = Y.trimestre AND
	 EXTRACT (year from X.ts) = Y.ano)
	ORDER BY id_utilizador, id_tempo, id_local, id_lingua;
