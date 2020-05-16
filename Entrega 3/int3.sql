-- Equipa com menos cartões na época 2019
select Clube.idClube, COUNT(Cartao.idEvento) from (
    Cartao join Jogador on Cartao.idJogador = Jogador.idJogador
)

-- not done yet