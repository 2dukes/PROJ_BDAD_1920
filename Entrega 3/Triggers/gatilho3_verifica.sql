.mode columns
.headers on
.nullvalue NULL

PRAGMA foreign_keys=ON;


.print 'ADIÇÃO DE EVENTOS DE JOGO...'
.print ''
.print ''
.print ''
.print ''
BEGIN TRANSACTION; -- ALL FOR THE SAME TEAM!

SELECT * FROM EstatisticaClubeJogo WHERE idJogo = 1;

-- 2 Golos no Jogo 1
INSERT INTO Golo VALUES ('9000', '97', '10', '1');
INSERT INTO Golo VALUES ('9001', '98', '10', '1');

-- 1 Cartão AMARELO no Jogo 1
INSERT INTO Cartao VALUES ('9002', '98','amarelo', '20', '1');

-- 1 Cartão VERMELHO no Jogo 1
INSERT INTO Cartao VALUES ('9003', '97','vermelho', '20', '1');

-- 1 Remate no Jogo 1

-- 2 Remates à Baliza no Jogo 1 num total de 4 Remates
INSERT INTO Remate VALUES ('9005', '97', '0', '5', '1');
INSERT INTO Remate VALUES ('9015', '99', '0', '5', '1');

INSERT INTO Remate VALUES ('9004', '98', '1', '5', '1');
INSERT INTO Remate VALUES ('9016', '100', '1', '5', '1');

-- 1 Falta no Jogo 1
INSERT INTO Falta VALUES ('9006', '98', '80', '1');

-- 1 Canto no Jogo 1
INSERT INTO Canto VALUES ('9007', '98', '3', '90', '1');

-- 2 Fora de Jogo no Jogo 1
INSERT INTO ForaDeJogo VALUES ('9008', '98', '3', '90', '1');
INSERT INTO ForaDeJogo VALUES ('9017', '98', '3', '90', '1');

-- 1 Assistencia no Jogo 1
INSERT INTO Assistencia VALUES ('9009', '98', '90', '1');

SELECT * FROM EstatisticaClubeJogo WHERE idJogo = 1;

ROLLBACK;

.print ''
.print ''
.print ''
.print ''
.print 'ADIÇÃO DE JOGOS - CLASSIFICAÇÃO'
.print ''
.print ''
.print ''
.print ''

BEGIN TRANSACTION;

SELECT * FROM ClassificacaoDoClubeNaEpoca;

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

SELECT * FROM ClassificacaoDoClubeNaEpoca;

ROLLBACK;