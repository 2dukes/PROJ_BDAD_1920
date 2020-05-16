-- Jogos em que houve pelo menos um cartão vermelho
/*
select *
from (
    select Jogo.idJogo as numJog, Cartao.idEvento as numCartao from
        Jogo join Cartao on Jogo.idJogo=Cartao.idEvento
    where
        Cartao.cor = 'vermelho'

    --group by Cartao.idEvento
    
) Games
where
    COUNT(Games.numCartao) > 1
--group by Games.numCartao;
*/

select Jogo.idJogo, COUNT(idEvento) from 
    Jogo join Cartao on Jogo.idJogo=Cartao.idJogo
where
    Cartao.cor = 'vermelho' and COUNT(idEvento) > 0
group by Cartao.idEvento

