-- Prémio Melhor Marcador (TOP 3)

.mode columns
.headers on
.nullvalue NULL

SELECT idJogador, nome, COUNT(*) as numGolos
FROM Golo
JOIN Jogador
ON Golo.idJogador = Jogador.idPessoa
GROUP BY Jogador.idPessoa
ORDER BY numGolos DESC
LIMIT 3;

-- Need to insert more goals! :)