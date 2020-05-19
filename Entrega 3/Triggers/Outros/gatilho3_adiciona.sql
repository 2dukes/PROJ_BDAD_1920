CREATE TRIGGER Estatisticas_Clube_Golo
    AFTER INSERT ON Golo
    FOR EACH ROW
    BEGIN
        UPDATE EstatisticaClubeJogo
        SET numGolos = numGolos + 1
        WHERE idClube = (SELECT Clube.idClube
                        FROM Jogador
                        JOIN Clube
                        ON Jogador.idClube = Clube.idClube
                        WHERE Jogador.idPessoa = NEW.idJogador)
            AND idJogo = NEW.idJogo;
    END;    

CREATE TRIGGER Estatisticas_Clube_Amarelo
    AFTER INSERT ON Cartao
    FOR EACH ROW
    WHEN NEW.cor = 'amarelo'
    BEGIN
        UPDATE EstatisticaClubeJogo
        SET numCartoesAmarelos = numCartoesAmarelos + 1
        WHERE idClube = (SELECT Clube.idClube
                        FROM Jogador
                        JOIN Clube
                        ON Jogador.idClube = Clube.idClube
                        WHERE Jogador.idPessoa = NEW.idJogador)
            AND idJogo = NEW.idJogo;
    END;   

CREATE TRIGGER Estatisticas_Clube_Vermelho
    AFTER INSERT ON Cartao
    FOR EACH ROW
    WHEN NEW.cor = 'vermelho'
    BEGIN
        UPDATE EstatisticaClubeJogo
        SET numCartoesVermelhos = numCartoesVermelhos + 1
        WHERE idClube = (SELECT Clube.idClube
                        FROM Jogador
                        JOIN Clube
                        ON Jogador.idClube = Clube.idClube
                        WHERE Jogador.idPessoa = NEW.idJogador)
            AND idJogo = NEW.idJogo;
    END;   

CREATE TRIGGER Estatisticas_Clube_Falta
    AFTER INSERT ON Falta
    FOR EACH ROW
    BEGIN
        UPDATE EstatisticaClubeJogo
        SET numFaltas = numFaltas + 1
        WHERE idClube = (SELECT Clube.idClube
                        FROM Jogador
                        JOIN Clube
                        ON Jogador.idClube = Clube.idClube
                        WHERE Jogador.idPessoa = NEW.idJogador)
            AND idJogo = NEW.idJogo;
    END; 


CREATE TRIGGER Estatisticas_Clube_RemateBaliza
    AFTER INSERT ON Remate
    FOR EACH ROW
    WHEN NEW.naBaliza LIKE '1'
    BEGIN
        UPDATE EstatisticaClubeJogo
        SET numRematesBaliza = numRematesBaliza + 1
        WHERE idClube = (SELECT Clube.idClube
                        FROM Jogador
                        JOIN Clube
                        ON Jogador.idClube = Clube.idClube
                        WHERE Jogador.idPessoa = NEW.idJogador)
            AND idJogo = NEW.idJogo;
    END; 

CREATE TRIGGER Estatisticas_Clube_Remate
    AFTER INSERT ON Remate
    FOR EACH ROW
    BEGIN
        UPDATE EstatisticaClubeJogo
        SET numRemates = numRemates + 1
        WHERE idClube = (SELECT Clube.idClube
                        FROM Jogador
                        JOIN Clube
                        ON Jogador.idClube = Clube.idClube
                        WHERE Jogador.idPessoa = NEW.idJogador)
            AND idJogo = NEW.idJogo;
    END; 


CREATE TRIGGER Estatisticas_Clube_Canto
    AFTER INSERT ON Canto
    FOR EACH ROW
    BEGIN
        UPDATE EstatisticaClubeJogo
        SET numCantos = numCantos + 1
        WHERE idClube = (SELECT Clube.idClube
                        FROM Jogador
                        JOIN Clube
                        ON Jogador.idClube = Clube.idClube
                        WHERE Jogador.idPessoa = NEW.idJogador)
            AND idJogo = NEW.idJogo;
    END; 

CREATE TRIGGER Estatisticas_Clube_ForaDeJogo
    AFTER INSERT ON ForaDeJogo
    FOR EACH ROW
    BEGIN
        UPDATE EstatisticaClubeJogo
        SET numForasDeJogo = numForasDeJogo + 1
        WHERE idClube = (SELECT Clube.idClube
                        FROM Jogador
                        JOIN Clube
                        ON Jogador.idClube = Clube.idClube
                        WHERE Jogador.idPessoa = NEW.idJogador)
            AND idJogo = NEW.idJogo;
    END; 

CREATE TRIGGER Estatisticas_Clube_Assistencia
    AFTER INSERT ON Assistencia
    FOR EACH ROW
    BEGIN
        UPDATE EstatisticaClubeJogo
        SET numAssistencias = numAssistencias + 1
        WHERE idClube = (SELECT Clube.idClube
                        FROM Jogador
                        JOIN Clube
                        ON Jogador.idClube = Clube.idClube
                        WHERE Jogador.idPessoa = NEW.idJogador)
            AND idJogo = NEW.idJogo;
    END; 