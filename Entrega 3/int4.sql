-- Prémio Melhor Marcador (TOP 3)

SELECT * 
FROM Golo
JOIN Jogador
ON Golo.idJogador = Jogador.idPessoa
GROUP BY Jogador.idPessoa
ORDER BY COUNT(*) DESC
LIMIT 3;

-- Need to insert more goals! :)