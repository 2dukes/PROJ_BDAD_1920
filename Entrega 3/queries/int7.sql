-- menor intervalo de tempo (em dias) entre dois jogos da mesma equipa

.mode columns
.headers on
.nullvalue NULL

DROP VIEW IF EXISTS jogos_equipas;
CREATE VIEW jogos_equipas AS
    SELECT Jogo.idClubeCasa AS 'idClube', Jogo.idJogo, Jogo.data_e_hora FROM Jogo
    UNION
    SELECT Jogo.idClubeFora AS 'idClube', Jogo.idJogo, Jogo.data_e_hora FROM Jogo; 

SELECT J1.idClube, J1.data_e_hora, J2.data_e_hora , min(julianday(abs(J1.data_e_hora - J2.data_e_hora))) AS 'Minimo de Tempo Entre Dois Jogos (dias)'
FROM jogos_equipas J1
JOIN jogos_equipas J2
ON J1.idClube = J2.idClube
GROUP BY J1.idClube;

-- temos que adicionar outra jornada
