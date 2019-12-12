drop table if exists d_utilizador cascade
drop table if exists d_tempo cascade
drop table if exists d_local cascade
drop table if exists d_lingua cascade

create table d_utilizador(
	id_utilizador serial not null,
	email varchar(20) not null,
	tipo varchar(20) not null,
	primary key(id_utilizador)
);

create table d_tempo(
	id_tempo serial not null,
	dia integer not null,
	dia_da_semana varchar(20) not null,
	semana varchar(20) not null,
	mes integer not null,
	trimestre integer not null,
	ano integer not null,
	primary key(id_tempo)
);

create table d_local(
	id_local serial not null,
	latitude DECIMAL(8,6) not null,
	longitude DECIMAL(9,6) not null,
	nome varchar(20) not null,
	primary key(id_local)
);

create table d_lingua(
	id_lingua serial not null,
	lingua varchar(20) not null,
	primary key(id_lingua)
);

create table f_anomalia(
	id_utilizador integer not null,
	id_tempo integer not null,
	id_local integer not null,
	id_lingua integer not null,
	primary key(id_utilizador, id_tempo, id_local, id_lingua),
	foreign key(id_utilizador) references d_utilizador(id_utilizador) on delete cascade on update cascade,
	foreign key(id_tempo) references d_tempo(id_tempo) on delete cascade on update cascade,
	foreign key(id_local) references d_local(id_local) on delete cascade on update cascade,
	foreign key(id_lingua) references d_lingua(id_lingua) on delete cascade on update cascade
);
