-- Top 3 Clubes com o maior número de golos marcados (em caso de empate vê o/os que tiverem menos golos sofridos)

.mode columns
.headers on
.nullvalue NULL

DROP VIEW IF EXISTS jogos_equipas;
CREATE VIEW jogos_equipas AS
    SELECT Jogo.idClubeCasa AS 'idClube', Jogo.idJogo FROM Jogo
    UNION 
    SELECT Jogo.idClubeFora AS 'idClube', Jogo.idJogo FROM Jogo; 

DROP VIEW IF EXISTS golos_sofridos_clube;
CREATE VIEW golos_sofridos_clube AS
    -- SELECT J1.idJogo, J1.idClube, J2.idClube, coalesce(golos_clubes.NumGolos, 0) AS 'numGolosSofridos'
    SELECT J1.idJogo, J1.idClube, coalesce(golos_clubes.NumGolos, 0) AS 'numGolosSofridos'
    FROM jogos_equipas J1 
    JOIN jogos_equipas J2
    ON J2.idJogo in (SELECT jogos_equipas.idJogo FROM jogos_equipas WHERE J1.idJogo = J2.idJogo AND J2.idClube <> J1.idClube)
    LEFT JOIN (SELECT Jogador.idClube, Jogo.idJogo, COUNT(*) AS 'NumGolos' 
            FROM Golo
            JOIN Jogador
            ON Golo.idJogador = Jogador.idPessoa
            JOIN Clube 
            ON Jogador.idClube = Clube.idClube
            JOIN Jogo
            ON Golo.idJogo = Jogo.idJogo
            GROUP BY Jogador.idClube
        ) golos_clubes
    ON J2.idClube = golos_clubes.idClube AND J1.idJogo = golos_clubes.idJogo;


-- SELECT * FROM golos_sofridos_clube;

DROP VIEW IF EXISTS golos_marcados_sofridos_clube;
CREATE VIEW golos_marcados_sofridos_clube AS
    SELECT Clube.idClube, Clube.nome, coalesce(NumGolos, 0) AS 'numGolosMarcados', golos_sofridos_clube.numGolosSofridos
    FROM Clube
    LEFT JOIN (
        SELECT Clube.idClube, Clube.nome, COUNT(*) AS 'NumGolos'
        FROM Golo
        JOIN Jogador
        ON Golo.idJogador = Jogador.idPessoa
        JOIN Clube
        ON Jogador.idClube = Clube.idClube
        GROUP BY Clube.idClube
        ) AS golos_por_clube
    ON Clube.idClube = golos_por_clube.idClube
    JOIN golos_sofridos_clube
    ON golos_sofridos_clube.idClube = Clube.idClube
    ORDER BY golos_por_clube.NumGolos DESC;

-- SELECT * FROM golos_marcados_sofridos_clube;

SELECT * 
FROM golos_marcados_sofridos_clube AS motherTable
WHERE numGolosMarcados >= (SELECT min(numGolosMarcados) 
                            FROM golos_marcados_sofridos_clube
                            WHERE numGolosMarcados IN (SELECT DISTINCT numGolosMarcados
                                                        FROM golos_marcados_sofridos_clube
                                                        ORDER BY numGolosMarcados DESC
                                                        LIMIT 3
                                                       )
                            )
AND numGolosSofridos = (SELECT min(numGolosSofridos) 
                        FROM golos_marcados_sofridos_clube GMSC 
                        WHERE GMSC.numGolosMarcados = motherTable.numGolosMarcados)
LIMIT 3;  
