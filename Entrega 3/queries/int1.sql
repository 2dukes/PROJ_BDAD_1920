-- Jogos em que houve pelo menos um cartão vermelho

.mode columns
.headers on
.nullvalue NULL

select
    Jogo.idJogo, 
    ClubeCasa.nome as 'Clube da Casa',
    ClubeFora.nome as 'Clube de Fora',
    Jogo.data_e_hora as 'Data e Hora',
    COUNT(idEvento) as 'Num Cartoes Vermelhos no Jogo'
from 
    Jogo join Cartao on Jogo.idJogo=Cartao.idJogo
    join Clube ClubeCasa on Jogo.idClubeCasa=ClubeCasa.idClube
    join Clube ClubeFora on Jogo.idClubeFora=ClubeFora.idClube
where
    Cartao.cor = 'vermelho'
group by Jogo.idJogo
HAVING COUNT(idEvento) >= 1;
