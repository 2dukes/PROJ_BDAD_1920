-- Jogos em que houve pelo menos um cartão vermelho

select Jogo.idJogo from 
    Jogo join Cartao on Jogo.idJogo=Cartao.idJogo
where
    Cartao.cor = 'vermelho'
group by Cartao.idEvento
HAVING COUNT(idEvento) >= 1;
