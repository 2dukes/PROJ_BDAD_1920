-- Jogadores com uma média de golos por jogo superior a 1 (de sempre)

drop view if exists num_golos_por_jogador;

create view num_golos_por_jogador as

    select Jogador.idPessoa as id_jogador, Jogador.nome, count(*) as totalGolos
    from Jogador join Golo on Jogador.idPessoa=Golo.idJogador
    group by Jogador.idPessoa;

--select * from num_golos_por_jogador;

drop view if exists num_jogos_por_jogador;

create view num_jogos_por_jogador as 
    select Jogador.idPessoa as id_jogador, Jogador.nome, count(*) as totalJogos
    from Jogador join EstatisticaJogadorNumJogo on Jogador.idPessoa=EstatisticaJogadorNumJogo.idJogador
    group by Jogador.idPessoa;

--select * from num_jogos_por_jogador;

select num_golos_por_jogador.id_jogador, num_golos_por_jogador.nome, avg(totalGolos / totalJogos) AS 'Media de Golos'
from 
    num_golos_por_jogador left join num_jogos_por_jogador on 
    num_golos_por_jogador.id_jogador=num_jogos_por_jogador.id_jogador
group by num_golos_por_jogador.id_jogador
having avg(totalGolos / totalJogos) > 1.0;




