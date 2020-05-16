-- Listar resultados dos jogos dos clubes na época de 2019

-- RUIZÃO ESTÁ FAZENDO :)

DROP VIEW IF EXISTS equipas_com_jogos_em_casa;

CREATE VIEW equipas_com_jogos_em_casa AS
    SELECT *
    FROM EventoJogo
    JOIN Jogo
    ON EventoJogo.idJogo = Jogo.idJogo
    JOIN Golo
    ON EventoJogo.idEvento = Golo.idEvento
    GROUP BY Jogo.idClubeCasa;

SELECT * FROM equipas_com_jogos_em_casa;