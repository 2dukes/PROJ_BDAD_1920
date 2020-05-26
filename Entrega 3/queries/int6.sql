-- Clube com a melhor eficácia de golos (número de golos / número de remates), pode haver clubes
-- com a mesma eficácia.

.mode columns
.headers on
.nullvalue NULL

DROP VIEW IF EXISTS golos_marcados_clube;
CREATE VIEW golos_marcados_clube AS
    SELECT Clube.idClube, Clube.nome, NumGolos
    FROM Clube
    LEFT JOIN (
        SELECT Clube.idClube, Clube.nome, COUNT(*) AS NumGolos
        FROM Golo
        JOIN Jogador
        ON Golo.idJogador = Jogador.idPessoa
        JOIN Clube
        ON Jogador.idClube = Clube.idClube
        GROUP BY Clube.idClube
        ) AS golos_por_clube
    ON Clube.idClube = golos_por_clube.idClube
    ORDER BY golos_por_clube.NumGolos DESC;

--SELECT * FROM golos_marcados_clube;



DROP VIEW IF EXISTS remates_clube;
CREATE VIEW remates_clube AS
    SELECT Clube.idClube, Clube.nome, NumRemates
    FROM Clube
    LEFT JOIN (
        SELECT Clube.idClube, Clube.nome, COUNT(*) AS NumRemates
        FROM Remate
        JOIN Jogador
        ON Remate.idJogador = Jogador.idPessoa
        JOIN Clube
        ON Jogador.idClube = Clube.idClube
        GROUP BY Clube.idClube
        ) AS remates_por_clube
    ON Clube.idClube = remates_por_clube.idClube
    ORDER BY remates_por_clube.NumRemates DESC;
    

--SELECT * FROM remates_clube;

DROP VIEW IF EXISTS eficacia_clube;
CREATE VIEW eficacia_clube AS
    select 
        golos_marcados_clube.idClube, 
        golos_marcados_clube.nome, (NumGolos/NumRemates)*100 as Eficacia
    from 
        golos_marcados_clube join remates_clube on golos_marcados_clube.idClube = remates_clube.idClube
    ORDER BY Eficacia DESC;

--select * from eficacia_clube;

select
    idClube, 
    nome,
    Eficacia
from eficacia_clube
where Eficacia = (select max(Eficacia) from eficacia_clube);