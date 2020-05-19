.mode columns
.headers on
.nullvalue NULL

PRAGMA foreign_keys=ON;


BEGIN transaction;

SELECT * FROM Jogo;
-- Deve Funcionar!
INSERT INTO Jogo VALUES ('13', strftime("%d/%m/%Y %H:%M", "2019-08-11 20:00"), '5', '2', '520', '0', '11'); 

-- Não deve Funcionar pois a equipa 2 está a jogar 2x em casa contra a equipa 6.
INSERT INTO Jogo VALUES ('14', strftime("%d/%m/%Y %H:%M", "2019-08-11 20:00"), '5', '2', '520', '2', '6');

-- Não Deve Funcionar pois duas equipas não se podem defrontar mais do que 2x numa época (Primeiro erro - Mais específico que o segundo, que é geral)
INSERT INTO Jogo VALUES ('15', strftime("%d/%m/%Y %H:%M", "2019-08-11 20:00"), '5', '2', '520', '11', '0'); 


SELECT * FROM Jogo;

ROLLBACK;