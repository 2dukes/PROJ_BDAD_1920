BEGIN transaction;

SELECT * FROM Arbitro WHERE idPessoa = 488;

INSERT INTO ArbitroJogo -- SHOULD PASS! 
    VALUES(488, 8);

SELECT * FROM Arbitro WHERE idPessoa = 488;

--

INSERT INTO ArbitroJogo -- SHOULD NOT PASS! (2 jogos para a mesma jornada!)
    VALUES(444, 8);

SELECT * FROM ArbitroJogo WHERE idArbitro = 444;

rollback; -- Alterações revertidas no final. Alteração seria commit (fazia a inserção)