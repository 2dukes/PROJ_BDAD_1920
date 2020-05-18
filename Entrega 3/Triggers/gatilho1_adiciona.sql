CREATE TRIGGER pontuacao_arbitro 
    AFTER INSERT ON ArbitroJogo
    FOR EACH ROW
    BEGIN
        SELECT CASE
        WHEN
            (SELECT COUNT(DISTINCT idJornada)
            FROM ArbitroJogo
            JOIN Jogo
            ON ArbitroJogo.idJogo = Jogo.idJogo
            WHERE idArbitro = NEW.idArbitro)
            <>
            (SELECT COUNT(idJornada)
            FROM ArbitroJogo
            JOIN Jogo
            ON ArbitroJogo.idJogo = Jogo.idJogo
            WHERE idArbitro = NEW.idArbitro)
        THEN
            RAISE(ABORT, 'O Arbitro esta a ser atribuido a outro jogo de uma mesma jornada!') -- Trabalho da FK... Defensive programming :)
        END;
        
        UPDATE Arbitro SET classificacao = classificacao + (SELECT classificacaoEquipaArbitragem
                                                            FROM Jogo
                                                            WHERE Jogo.idJogo = NEW.idJogo)
        WHERE Arbitro.idPessoa = NEW.idArbitro;
    END;
