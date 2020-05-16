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
    SELECT teamsHome.idJornada, Clube.nome, teamsHome.idClubeCasa, teamsHome.idJogo, teamsHome.numGolosCasa
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
    SELECT teamsAway.idJornada, Clube.nome, teamsAway.idClubeFora, teamsAway.idJogo, teamsAway.numGolosFora
    FROM golos_equipa_fora AS teamsAway 
    JOIN Clube 
    ON teamsAway.idClubeFora = Clube.idClube;

-- SELECT * FROM golos_fora;

SELECT golos_casa.idJornada, golos_casa.nome AS 'CASA', golos_fora.nome AS 'FORA', golos_casa.numGolosCasa, golos_fora.numGolosFora,
    (CASE 
        WHEN golos_casa.numGolosCasa > golos_fora.numGolosFora THEN 'CASA VENCEU' 
        WHEN  golos_casa.numGolosCasa < golos_fora.numGolosFora THEN 'FORA VENCEU'
        ELSE 'EMPATE'
    END) AS 'RESULTADO'                               
FROM golos_casa
JOIN golos_fora
ON golos_casa.idJogo = golos_fora.idJogo
JOIN Jornada
ON golos_casa.idJornada = Jornada.idJornada
WHERE Jornada.epoca = '2019';

-- This document is protected with CopyRight ©. For further info, contact Rui Pinto :) @2dukes