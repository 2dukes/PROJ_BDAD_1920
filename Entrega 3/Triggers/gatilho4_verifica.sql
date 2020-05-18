BEGIN TRANSACTION;

SELECT * FROM ClassificacaoDoClubeNaEpoca;
SELECT * FROM EstatisticaClubeJogo;

-- Equipa 1 ganha à Equipa 2 por 1 - 0
INSERT INTO Jogo VALUES ('20', strftime("%d/%m/%Y %H:%M", "2019-08-18 20:00"), '7', '2', '522', '1', '2', '0');

INSERT INTO EstatisticaClubeJogo(idEstatisticaClube, idClube, idJogo) VALUES (30, 1, 20);
INSERT INTO EstatisticaClubeJogo(idEstatisticaClube, idClube, idJogo) VALUES (31, 2, 20);

INSERT INTO Golo VALUES ('500', '20', '10', '20');

UPDATE Jogo SET terminadoPara = '1' WHERE idJogo = 20;

-- Equipa 5 ganha à Equipa 6 por 3 - 1
INSERT INTO Jogo VALUES ('21', strftime("%d/%m/%Y %H:%M", "2019-08-18 20:00"), '7', '2', '522', '6', '5', '0');

INSERT INTO EstatisticaClubeJogo(idEstatisticaClube, idClube, idJogo) VALUES (33, 5, 21);
INSERT INTO EstatisticaClubeJogo(idEstatisticaClube, idClube, idJogo) VALUES (34, 6, 21);

INSERT INTO Golo VALUES ('501', '80', '10', '21');
INSERT INTO Golo VALUES ('502', '80', '15', '21');
INSERT INTO Golo VALUES ('503', '80', '20', '21');

INSERT INTO Golo VALUES ('504', '98', '25', '21');

UPDATE Jogo SET terminadoPara = '1' WHERE idJogo = 21;

-- Equipa 9 empata com Equipa 10 por 0 - 0
INSERT INTO Jogo VALUES ('22', strftime("%d/%m/%Y %H:%M", "2019-08-18 20:00"), '7', '2', '522', '9', '10', '0');

INSERT INTO EstatisticaClubeJogo(idEstatisticaClube, idClube, idJogo) VALUES (35, 9, 22);
INSERT INTO EstatisticaClubeJogo(idEstatisticaClube, idClube, idJogo) VALUES (36, 10, 22);

UPDATE Jogo SET terminadoPara = '1' WHERE idJogo = 22;

SELECT * FROM Jogo;
SELECT * FROM ClassificacaoDoClubeNaEpoca;
SELECT * FROM EstatisticaClubeJogo;

ROLLBACK;