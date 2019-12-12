(RI-1) A zona da anomalia_tradução não se pode sobrepor à zona da anomalia correspondente

will use dis
&&	Overlaps?	box '((0,0),(1,1))' && box '((0,0),(2,2))'

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
language plpgsql
-----------------------------------------------------------------

(RI-4) email de utilizador tem de figurar em utilizador_qualificado ou utilizador_regular

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
language plpgsql
-----------------------------------------------------------------

(RI-5) email não pode figurar em utilizador_regular

create or replace function trigger_qualificadoNotRegular() returns trigger as $$
begin
if not exists(
        select * from (utilizador_regular) R where not (R.email = new.email)
)then           
        raise exception '[!] You can't be qualificado because you are regular';
endif;
return new;
end;
$$
language plpgsql
-----------------------------------------------------------------

(RI-6) email não pode figurar em utilizador_qualificado

create or replace function trigger_qualificadoNotRegular() returns trigger as>
begin
if not exists(
        select * from (utilizador_qualificado) R where not (R.email = new.email)
)then
        raise exception '[!] You can't be regular because you are qualificado>
endif;
return new;
end;
$$
language plpgsql

-----------------------------------------------------------------
