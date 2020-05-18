-- Prémio melhor árbitro(s) da época 2019

.mode columns
.headers on
.nullvalue NULL

drop view if exists classificacoes_arbitros_epoca_2019;

create view classificacoes_arbitros_epoca_2019 as 
    select Arbitro.idPessoa, Arbitro.nome, sum(Jogo.classificacaoEquipaArbitragem) as 'classificacaoArbitro'
    from ArbitroJogo 
        join Jogo on ArbitroJogo.idJogo=Jogo.idJogo
        join Jornada on Jogo.idJornada=Jornada.idJornada
        join Epoca on Jornada.epoca=Epoca.anoInicio
        join Arbitro on ArbitroJogo.idArbitro=Arbitro.idPessoa
    where Epoca.anoInicio='2019'
    GROUP BY Arbitro.idPessoa;

--SELECT * FROM classificacoes_arbitros_epoca_2019;

SELECT *
FROM classificacoes_arbitros_epoca_2019
WHERE classificacaoArbitro = (
    select max(classificacaoArbitro) as MaxClassificacaoArbitro
    from classificacoes_arbitros_epoca_2019
);

