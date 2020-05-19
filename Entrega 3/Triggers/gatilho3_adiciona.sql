.mode columns
.headers on
.nullvalue NULL

PRAGMA foreign_keys=ON;


-- Triggers necessários à construção da classificação das Equipas!
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

CREATE TRIGGER classificacao_equipas
    AFTER INSERT ON Golo
    FOR EACH ROW
    BEGIN
        -- Atualizar Golos Marcados
        UPDATE ClassificacaoDoClubeNaEpoca
        SET golosMarcados = golosMarcados + 1 
        WHERE idClassificacao = (SELECT idClassificacao
                                FROM Jogador
                                JOIN Clube
                                ON Jogador.idClube = Clube.idClube
                                WHERE Jogador.idPessoa = NEW.idJogador);
        
        -- Atualizar Golos Sofridos
        UPDATE ClassificacaoDoClubeNaEpoca
        SET golosSofridos = golosSofridos + 1
        WHERE idClassificacao = (CASE
                                    WHEN (SELECT idClubeCasa FROM Jogo WHERE idClubeCasa = (SELECT idClube FROM Jogador WHERE Jogador.idPessoa = NEW.idJogador)) 
                                        THEN (SELECT idClassificacao 
                                             FROM Jogo
                                             JOIN Clube 
                                             ON Jogo.idClubeFora = Clube.idClube
                                             WHERE Jogo.idJogo = NEW.idJogo) 
                                    WHEN (SELECT idClubeFora FROM Jogo WHERE idClubeFora = (SELECT idClube FROM Jogador WHERE Jogador.idPessoa = NEW.idJogador)) 
                                        THEN (SELECT idClassificacao 
                                             FROM Jogo
                                             JOIN Clube 
                                             ON Jogo.idClubeCasa = Clube.idClube
                                             WHERE Jogo.idJogo = NEW.idJogo)
                                END); 

        -- Atualizar Diferença de Golos
        UPDATE ClassificacaoDoClubeNaEpoca
        SET diferencaGolos = golosMarcados - golosSofridos;
    END;

CREATE TRIGGER jogo_terminado
    AFTER UPDATE ON Jogo
    FOR EACH ROW
    WHEN NEW.terminadoPara = '1'
    BEGIN
        -- Atualizar numVitorias | numDerrotas | numEmpates -> Equipa da Casa
        UPDATE ClassificacaoDoClubeNaEpoca
        SET numVitorias = (CASE
                            WHEN (SELECT numGolos 
                                FROM EstatisticaClubeJogo
                                WHERE idJogo = NEW.idJogo AND idClube = NEW.idClubeCasa) > (SELECT numGolos
                                                                                            FROM EstatisticaClubeJogo
                                                                                            WHERE idJogo = NEW.idJogo AND idClube = NEW.idClubeFora)
                                THEN
                                    numVitorias + 1
                                ELSE 
                                    numVitorias
                            END),
        numDerrotas = (CASE
                            WHEN (SELECT numGolos 
                                FROM EstatisticaClubeJogo
                                WHERE idJogo = NEW.idJogo AND idClube = NEW.idClubeCasa) < (SELECT numGolos
                                                                                            FROM EstatisticaClubeJogo
                                                                                            WHERE idJogo = NEW.idJogo AND idClube = NEW.idClubeFora)
                                THEN
                                    numDerrotas + 1
                                ELSE
                                    numDerrotas
                            END),
        numEmpates = (CASE
                            WHEN (SELECT numGolos 
                                FROM EstatisticaClubeJogo
                                WHERE idJogo = NEW.idJogo AND idClube = NEW.idClubeCasa) = (SELECT numGolos
                                                                                            FROM EstatisticaClubeJogo
                                                                                            WHERE idJogo = NEW.idJogo AND idClube = NEW.idClubeFora)
                                THEN
                                    numEmpates + 1
                                ELSE
                                    numEmpates
                            END)
        WHERE idClassificacao = (SELECT idClassificacao 
                                FROM Clube
                                WHERE Clube.idClube = NEW.idClubeCasa);

        -- Atualizar numVitorias | numDerrotas | numEmpates -> Equipa de Fora
        UPDATE ClassificacaoDoClubeNaEpoca
        SET numVitorias = (CASE
                            WHEN (SELECT numGolos 
                                FROM EstatisticaClubeJogo
                                WHERE idJogo = NEW.idJogo AND idClube = NEW.idClubeCasa) < (SELECT numGolos
                                                                                            FROM EstatisticaClubeJogo
                                                                                            WHERE idJogo = NEW.idJogo AND idClube = NEW.idClubeFora)
                                THEN
                                    numVitorias + 1
                                ELSE
                                    numVitorias
                            END),
        numDerrotas = (CASE
                            WHEN (SELECT numGolos 
                                FROM EstatisticaClubeJogo
                                WHERE idJogo = NEW.idJogo AND idClube = NEW.idClubeCasa) > (SELECT numGolos
                                                                                            FROM EstatisticaClubeJogo
                                                                                            WHERE idJogo = NEW.idJogo AND idClube = NEW.idClubeFora)
                                THEN
                                    numDerrotas + 1
                                ELSE
                                    numDerrotas
                            END),
        numEmpates = (CASE
                            WHEN (SELECT numGolos 
                                FROM EstatisticaClubeJogo
                                WHERE idJogo = NEW.idJogo AND idClube = NEW.idClubeCasa) = (SELECT numGolos
                                                                                            FROM EstatisticaClubeJogo
                                                                                            WHERE idJogo = NEW.idJogo AND idClube = NEW.idClubeFora)
                                THEN
                                    numEmpates + 1
                                ELSE
                                    numEmpates
                            END)
        WHERE idClassificacao = (SELECT idClassificacao 
                                FROM Clube
                                WHERE Clube.idClube = NEW.idClubeFora);

        UPDATE ClassificacaoDoClubeNaEpoca
        SET pontos = numVitorias * 3 + numEmpates;
        
    END;