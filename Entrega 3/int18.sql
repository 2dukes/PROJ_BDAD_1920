-- Classificação das equipas (em caso de empate, ver a equipa com maior diferença golos marcados / 
-- golos sofridos em caso de novo empate ganha equipa com mais golos marcados)

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

-- Listar resultados dos jogos dos clubes na época de 2019

-- Tabela de clubes da casa e respetivos golos por jogo 

DROP VIEW IF EXISTS equipas_com_jogos_em_casa;
CREATE VIEW equipas_com_jogos_em_casa AS
    SELECT Jogador.idClube, Golo.idJogo, COUNT(*) AS 'numGolosCasa'
    FROM Golo
    JOIN Jogador
    ON Golo.idJogador = Jogador.idPessoa
    JOIN Clube 
    ON Jogador.idClube = Clube.idClube
    JOIN Jogo
    ON Jogo.idClubeCasa = Jogador.idClube 
    GROUP BY Jogador.idClube, Golo.idJogo;

DROP VIEW IF EXISTS golos_equipa_casa;
CREATE VIEW golos_equipa_casa AS
    SELECT Jogo.idJornada, coalesce(teamsHome.idClube, Jogo.idClubeCasa) AS 'idClubeCasa' , Jogo.idJogo, coalesce(teamsHome.numGolosCasa, 0) AS 'numGolosCasa'
    FROM Jogo
    LEFT JOIN equipas_com_jogos_em_casa AS teamsHome
    ON teamsHome.idClube = Jogo.idClubeCasa AND teamsHome.idJogo = Jogo.idJogo;

DROP VIEW IF EXISTS golos_casa;
CREATE VIEW golos_casa AS
    SELECT teamsHome.idJornada, Clube.idClube, Clube.nome, teamsHome.idClubeCasa, teamsHome.idJogo, teamsHome.numGolosCasa
    FROM golos_equipa_casa AS teamsHome
    JOIN Clube 
    ON teamsHome.idClubeCasa = Clube.idClube;

-- SELECT * FROM golos_casa;

-- Tabela de clubes de fora e respetivos golos por jogo 

DROP VIEW IF EXISTS equipas_com_jogos_em_fora;
CREATE VIEW equipas_com_jogos_em_fora AS
    SELECT Jogador.idClube, Golo.idJogo, COUNT(*) AS 'numGolosFora'
    FROM Golo
    JOIN Jogador
    ON Golo.idJogador = Jogador.idPessoa
    JOIN Clube 
    ON Jogador.idClube = Clube.idClube
    JOIN Jogo
    ON Jogo.idClubeFora = Jogador.idClube 
    GROUP BY Jogador.idClube, Golo.idJogo;

DROP VIEW IF EXISTS golos_equipa_fora;
CREATE VIEW golos_equipa_fora AS
    SELECT Jogo.idJornada, coalesce(teamsAway.idClube, Jogo.idClubeFora) AS 'idClubeFora' , Jogo.idJogo, coalesce(teamsAway.numGolosFora, 0) AS 'numGolosFora'
    FROM Jogo
    LEFT JOIN equipas_com_jogos_em_fora AS teamsAway
    ON teamsAway.idClube = Jogo.idClubeFora AND teamsAway.idJogo = Jogo.idJogo;

DROP VIEW IF EXISTS golos_fora;
CREATE VIEW golos_fora AS
    SELECT teamsAway.idJornada, Clube.idClube, Clube.nome, teamsAway.idClubeFora, teamsAway.idJogo, teamsAway.numGolosFora
    FROM golos_equipa_fora AS teamsAway 
    JOIN Clube 
    ON teamsAway.idClubeFora = Clube.idClube;

-- SELECT * FROM golos_fora;

DROP VIEW IF EXISTS Resultados;
CREATE VIEW Resultados AS
    SELECT golos_casa.idJornada, golos_casa.nome AS 'CASA', golos_casa.idClube AS 'idClubeCasa', golos_fora.nome AS 'FORA', golos_fora.idClube AS 'idClubeFora', golos_casa.numGolosCasa, golos_fora.numGolosFora                           
    FROM golos_casa
    JOIN golos_fora
    ON golos_casa.idJogo = golos_fora.idJogo
    JOIN Jornada
    ON golos_casa.idJornada = Jornada.idJornada
    WHERE Jornada.epoca = '2019';


DROP VIEW IF EXISTS num_pontos;
CREATE VIEW num_pontos AS
    SELECT Clube.idClube, Clube.nome, (
                                        SELECT COUNT(*)
                                        FROM Resultados R2
                                        WHERE R2.idClubeCasa = Clube.idClube AND R2.numGolosCasa > R2.numGolosFora
                                        ) * 3 AS 'PontosVitoriasCasa', (
                                                                    SELECT COUNT(*)
                                                                    FROM Resultados R2
                                                                    WHERE R2.idClubeCasa = Clube.idClube AND R2.numGolosCasa = R2.numGolosFora
                                                                ) AS 'PontosEmpatesCasa', (
                                                                                        SELECT COUNT(*)
                                                                                        FROM Resultados R2
                                                                                        WHERE R2.idClubeFora = Clube.idClube AND R2.numGolosCasa < R2.numGolosFora
                                                                                        ) * 3 AS 'PontosVitoriasFora', (
                                                                                                                            SELECT COUNT(*)
                                                                                                                            FROM Resultados R2
                                                                                                                            WHERE R2.idClubeFora = Clube.idClube AND R2.numGolosCasa = R2.numGolosFora
                                                                                                                        ) AS 'PontosEmpatesFora'
    FROM Clube;

-- SELECT * FROM num_pontos;

-- Classificação!

SELECT num_pontos.idClube, num_pontos.nome, PontosVitoriasCasa + PontosVitoriasFora + PontosEmpatesCasa + PontosEmpatesFora AS 'Pontos'
FROM num_pontos
JOIN golos_marcados_sofridos_clube GMSC
ON num_pontos.idClube = GMSC.idClube
ORDER BY (PontosVitoriasCasa + PontosVitoriasFora + PontosEmpatesCasa + PontosEmpatesFora) DESC, (GMSC.numGolosMarcados - GMSC.numGolosSofridos) DESC, GMSC.numGolosMarcados DESC; 

