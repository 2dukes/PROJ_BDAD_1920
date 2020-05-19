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