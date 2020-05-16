-- Top 3 clubes com a melhor eficácia de golos (número de golos / número de remates)

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