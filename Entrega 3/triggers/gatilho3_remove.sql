.mode columns
.headers on
.nullvalue NULL

PRAGMA foreign_keys=ON;


DROP TRIGGER IF EXISTS classificacao_equipas;
DROP TRIGGER IF EXISTS Estatisticas_Clube_Golo;
DROP TRIGGER IF EXISTS Estatisticas_Clube_Amarelo;
DROP TRIGGER IF EXISTS Estatisticas_Clube_Vermelho;
DROP TRIGGER IF EXISTS Estatisticas_Clube_Falta;
DROP TRIGGER IF EXISTS Estatisticas_Clube_Remate;
DROP TRIGGER IF EXISTS Estatisticas_Clube_RemateBaliza;
DROP TRIGGER IF EXISTS Estatisticas_Clube_Canto;
DROP TRIGGER IF EXISTS Estatisticas_Clube_ForaDeJogo;
DROP TRIGGER IF EXISTS Estatisticas_Clube_Assistencia;
DROP TRIGGER IF EXISTS jogo_terminado;