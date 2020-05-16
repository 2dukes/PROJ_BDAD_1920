-- Média do número de remates na baliza por jogo ao longo da época, para cada clube.

drop view if exists num_remates_por_jogo;

create view num_remates_por_jogo as
    select *
    from EventoJogo
    join Remate on EventoJogo.idEvento=Remate.idEvento
    where Remate.naBaliza='1';

select * from num_remates_por_jogo;