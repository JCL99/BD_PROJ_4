drop trigger if exists trigger1 on anomalia_traducao;

create or replace function trigger_overllappingBoxes() returns trigger as $$
begin
if not exists(
	select * from (anomalia) R where R.id = new.id and not(R.zona && new.zona2)
) then
	raise exception '[!] Zones overlapping';
endif;
return new;
end;
$$
language plpgsql;

create trigger trigger1 before insert on anomalia_traducao
for each row execute procedure trigger_overllappingBoxes();


drop trigger if exists trigger2 on utilizador;

create or replace function trigger_emailExists() returns trigger as $$
begin
if not exists(
        select * from (utilizador_qualificado inner join utilizador_regular) R where R.email = new.email
)then
        raise exception '[!] Email is unexistent in required entyties';
endif;
return new;
end;
$$
language plpgsql;

create trigger trigger2 before insert on utilizador
for each row execute procedure trigger_emailExists();

drop trigger if exists trigger3 on utilizador_qualificado;

create or replace function trigger_qualificadoNotRegular() returns trigger as $$
begin
if not exists(
        select * from (utilizador_regular) R where not (R.email = new.email)
)then
        raise exception "[!] You can't be qualificado because you are regular"
endif;
return new;
end;
$$
language plpgsql;

create trigger trigger3 before insert on utilizador_qualificado
for each row execute procedure trigger_qualificadoNotRegular();

/*(RI-6) email não pode figurar em utilizador_qualificado*/

drop trigger if exists trigger4 on utilizador_regular;

create or replace function trigger_regularNotQualificado() returns trigger as>
begin
if not exists(
        select * from (utilizador_qualificado) R where not (R.email = new.email)
)then
        raise exception "[!] You can't be regular because you are qualificado"
endif;
return new;
end;
$$
language plpgsql;

create trigger trigger4 before insert on utilizador_regular
for each row execute procedure trigger_regularNotQualificado();
