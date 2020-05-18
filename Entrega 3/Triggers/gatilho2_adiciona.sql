-- Verifica se equipa da casa não joga duas vezes no mesmo local com a mesma equipa (verifica se equipa não se defronta mais que 2x - ERRADO)
CREATE TRIGGER verifica_jogo_repetido
    AFTER INSERT ON Jogo
    FOR EACH ROW
    BEGIN
        SELECT CASE
            WHEN
                (SELECT COUNT(*) 
                FROM Jogo
                WHERE ((Jogo.idClubeCasa = NEW.idClubeCasa AND Jogo.idClubeFora = NEW.idClubeFora)
                OR  (Jogo.idClubeCasa = NEW.idClubeFora AND Jogo.idClubeFora= NEW.idClubeCasa))) > 2
            THEN 
                RAISE(ABORT, 'Duas Equipas nao se podem defrontar mais do que 2 vezes na mesma Epoca')
            WHEN (SELECT COUNT(*)
                 FROM JOGO
                 WHERE idClubeCasa = NEW.idClubeCasa
                 AND idClubeFora = NEW.idClubeFora) > 1
                 OR
                 (SELECT COUNT(*)
                 FROM JOGO
                 WHERE idClubeCasa = NEW.idClubeFora
                 AND idClubeFora = NEW.idClubeCasa) > 1
            THEN
                RAISE(ABORT, 'Uma equipa não pode defrontar a outra 2x em casa ou fora')
            END;
    END;