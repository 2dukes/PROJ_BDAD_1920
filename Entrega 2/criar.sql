.mode column
.headers ON

PRAGMA foreign_keys=ON;
PRAGMA encoding="UTF-8";

DROP TABLE IF EXISTS TreinadorGuardaRedes;
DROP TABLE IF EXISTS TreinadorAdjunto;
DROP TABLE IF EXISTS TreinadorPrincipal;
DROP TABLE IF EXISTS EquipaTecnica;

DROP TABLE IF EXISTS Medico;
DROP TABLE IF EXISTS Massagista;
DROP TABLE IF EXISTS ResponsavelGuardaRoupa;
DROP TABLE IF EXISTS FuncionarioDeLimpeza;
DROP TABLE IF EXISTS Olheiro;
DROP TABLE IF EXISTS EquipaFuncionarios;

DROP TABLE IF EXISTS EstatisticaJogadorNumJogo;
DROP TABLE IF EXISTS EstatisticaJogadorEpoca;
DROP TABLE IF EXISTS Estadio;
DROP TABLE IF EXISTS EstadioCapacidadeVIP;
DROP TABLE IF EXISTS EstatisticaClubeJogo;

DROP TABLE IF EXISTS Golo;
DROP TABLE IF EXISTS Cartao;
DROP TABLE IF EXISTS Falta;
DROP TABLE IF EXISTS Canto;
DROP TABLE IF EXISTS Remate;
DROP TABLE IF EXISTS Canto;
DROP TABLE IF EXISTS ForaDeJogo;
DROP TABLE IF EXISTS Assistencia;

DROP TABLE IF EXISTS EventoJogo;
DROP TABLE IF EXISTS ArbitroJogo;
DROP TABLE IF EXISTS Arbitro;
DROP TABLE IF EXISTS Jogo;
DROP TABLE IF EXISTS Jornada;
DROP TABLE IF EXISTS PatrocinadorEpoca;
DROP TABLE IF EXISTS PatrocinadorClube;
DROP TABLE IF EXISTS Patrocinador;
DROP TABLE IF EXISTS Rank;
DROP TABLE IF EXISTS Embaixador;

DROP TABLE IF EXISTS Jogador;
DROP TABLE IF EXISTS Clube;
DROP TABLE IF EXISTS ClassificacaoDoClubeNaEpoca;
DROP TABLE IF EXISTS Epoca;
DROP TABLE IF EXISTS Liga;
DROP TABLE IF EXISTS Delegado;
DROP TABLE IF EXISTS Pessoa;


CREATE TABLE Pessoa (
    idPessoa INTEGER NOT NULL,
    nome TEXT NOT NULL,
    morada TEXT NOT NULL,
    nacionalidade TEXT NOT NULL,
    idade INTEGER NOT NULL,
    telefone INTEGER UNIQUE NOT NULL,
    CONSTRAINT Pessoa_PK PRIMARY KEY(idPessoa)
);

CREATE TABLE Delegado (
    idPessoa INTEGER NOT NULL,
    nome TEXT NOT NULL,
    morada TEXT NOT NULL,
    nacionalidade TEXT NOT NULL,
    idade INTEGER NOT NULL,
    telefone INTEGER UNIQUE NOT NULL,

    CONSTRAINT Delegado_PK PRIMARY KEY (idPessoa),
    CONSTRAINT Delegado_FK FOREIGN KEY (idPessoa) REFERENCES Pessoa(idPessoa) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Clube (
    idClube INTEGER NOT NULL,
    nome TEXT NOT NULL,
    anoFundacao INTEGER NOT NULL,
    idClassificacao INTEGER NOT NULL,

    CONSTRAINT Clube_PK PRIMARY KEY (idClube),
    CONSTRAINT Clube_FK FOREIGN KEY (idClassificacao) REFERENCES ClassificacaoDoClubeNaEpoca ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Jogador (
    idPessoa INTEGER NOT NULL,
    idClube REFERENCES Clube,
    nome TEXT NOT NULL,
    morada TEXT NOT NULL,
    nacionalidade TEXT NOT NULL,
    idade INTEGER NOT NULL,
    telefone INTEGER UNIQUE NOT NULL,
    
    CONSTRAINT Jogador_PK PRIMARY KEY (idPessoa),
    CONSTRAINT Jogador_FK_Pessoa FOREIGN KEY (idPessoa) REFERENCES Pessoa ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Jogador_FK_Clube FOREIGN KEY (idClube) REFERENCES Clube ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Liga (
    nome TEXT NOT NULL,
    pais TEXT NOT NULL,
    
    CONSTRAINT LIGA_PK PRIMARY KEY (nome, pais)
);

CREATE TABLE Epoca (
    anoInicio INTEGER NOT NULL,
    anoFim INTEGER NOT NULL,
    nomeLiga TEXT NOT NULL,
    paisLiga TEXT NOT NULL,

    CONSTRAINT AnoInicio_AnoFim CHECK(anoFim = (anoInicio + 1))
    CONSTRAINT Epoca_PK PRIMARY KEY (anoInicio),
    CONSTRAINT Epoca_FK1 FOREIGN KEY (nomeLiga, paisLiga) REFERENCES Liga(nome, pais) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ClassificacaoDoClubeNaEpoca (
    idClassificacao INTEGER NOT NULL,
    golosMarcados INTEGER DEFAULT 0 CHECK (golosMarcados >= 0),
    golosSofridos INTEGER DEFAULT 0 CHECK (golosSofridos >= 0),
    diferencaGolos INTEGER DEFAULT 0 CHECK (diferencaGolos = (golosMarcados - golosSofridos)),
    pontos INTEGER DEFAULT 0 CHECK ((pontos >= 0) AND (pontos = (3 * numVitorias + numEmpates))),
    numVitorias DEFAULT 0 CHECK (numVitorias >= 0),
    numDerrotas DEFAULT 0 CHECK (numDerrotas >= 0),
    numEmpates DEFAULT 0 CHECK (numEmpates >= 0),
    epoca NOT NULL,

    CONSTRAINT ClassificacaoDoClubeNaEpoca_PK PRIMARY KEY (idClassificacao),
    CONSTRAINT ClassificacaoDoClubeNaEpoca_FK FOREIGN KEY (epoca) REFERENCES Epoca ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Rank (
    rank TEXT NOT NULL,
    valorInvestido INTEGER NOT NULL,

    CONSTRAINT Rank_PK PRIMARY KEY(rank),
    CONSTRAINT rank_CHECK CHECK (rank LIKE 'bronze' OR rank LIKE 'prata' OR rank LIKE 'ouro'),
    CONSTRAINT valorInvestido_CHECK  CHECK ((rank LIKE  'bronze' AND valorInvestido = 250000) OR
                                            (rank LIKE 'prata' AND valorInvestido = 500000) OR 
                                            (rank LIKE 'ouro' AND valorInvestido = 1000000))

);

CREATE TABLE Patrocinador (
    idPatrocinador INTEGER NOT NULL,
    nome TEXT NOT NULL,
    rank TEXT NOT NULL,

    CONSTRAINT Patrocinador PRIMARY KEY (idPatrocinador),
    CONSTRAINT Patrocinador_Rank FOREIGN KEY (rank) REFERENCES Rank(rank) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE PatrocinadorEpoca (
    idPatrocinador INTEGER NOT NULL,
    epoca INTEGER NOT NULL,
    
    CONSTRAINT PatrocinadorEpoca_FK1 FOREIGN KEY (idPatrocinador) REFERENCES Patrocinador(idPatrocinador) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PatrocinadorEpoca_FK2 FOREIGN KEY (epoca) REFERENCES Epoca(anoInicio) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PatrocinadorEpoca_PK PRIMARY KEY (idPatrocinador, epoca) 
);

CREATE TABLE PatrocinadorClube (
    idPatrocinador INTEGER NOT NULL,
    idClube INTEGER NOT NULL,

    CONSTRAINT PatrocinadorClube_PK PRIMARY KEY (idPatrocinador, idClube),
    CONSTRAINT PatrocinadorClube_FK1 FOREIGN KEY (idPatrocinador) REFERENCES Patrocinador(idPatrocinador) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PatrocinadorClube_FK2 FOREIGN KEY (idClube) REFERENCES Clube(idClube) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Jornada (
    idJornada INTEGER NOT NULL,
    epoca INTEGER NOT NULL,
    
    CONSTRAINT Jornada_PK PRIMARY KEY (idJornada),
    CONSTRAINT Jornada_FK FOREIGN KEY (epoca) REFERENCES Epoca(anoInicio) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Jogo (
    idJogo INTEGER NOT NULL,
    data_e_hora DATE NOT NULL,
    classificacaoEquipaArbitragem INTEGER NOT NULL CHECK (classificacaoEquipaArbitragem >= 0 AND classificacaoEquipaArbitragem <= 10),
    idJornada INTEGER NOT NULL,
    idDelegado INTEGER NOT NULL,
    idClubeCasa INTEGER NOT NULL,
    idClubeFora INTEGER NOT NULL,

    CONSTRAINT Jogo_PK PRIMARY KEY (idJogo),
    CONSTRAINT Jogo_FK1 FOREIGN KEY (idJornada) REFERENCES Jornada(idJornada) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Jogo_PK2 FOREIGN KEY (idDelegado) REFERENCES Delegado(idPessoa) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT Jogo_FK3 FOREIGN KEY (idClubeCasa) REFERENCES Clube(idClube) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Jogo_FK4 FOREIGN KEY (idClubeFora) REFERENCES Clube(idClube) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Arbitro (
    idPessoa INTEGER NOT NULL,
    classificacao INTEGER DEFAULT 0 CHECK (classificacao >= 0),
    numPremiosGanhos INTEGER DEFAULT 0 CHECK (numPremiosGanhos >= 0),
    nome TEXT NOT NULL,
    morada TEXT NOT NULL,
    nacionalidade TEXT NOT NULL,
    idade INTEGER NOT NULL,
    telefone INTEGER UNIQUE NOT NULL,
    
    CONSTRAINT Arbitro_PK PRIMARY KEY (idPessoa),
    CONSTRAINT Arbitro_FK FOREIGN KEY (idPessoa) REFERENCES Pessoa (idPessoa) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ArbitroJogo (
    idArbitro INTEGER NOT NULL,
    idJogo INTEGER NOT NULL,

    CONSTRAINT ArbitroJogo_PK PRIMARY KEY (idArbitro),
    CONSTRAINT ArbitroJogoJogo_FK_Pessoa FOREIGN KEY (idArbitro) REFERENCES Pessoa(idPessoa) ON DELETE CASCADE ON UPDATE CASCADE
    CONSTRAINT ArbitroJogoJogo_FK_Jogo FOREIGN KEY (idJogo) REFERENCES Jogo(idJogo) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE EventoJogo (
    idEvento INTEGER NOT NULL,
    minuto INTEGER NOT NULL CHECK (minuto >= 0),
    idJogo INTEGER NOT NULL,
    
    CONSTRAINT EventoJogo_PK PRIMARY KEY (idEvento),
    CONSTRAINT EventoJogo_FK FOREIGN KEY (idJogo) REFERENCES Jogo(idJogo) ON DELETE CASCADE ON UPDATE CASCADE
); 

CREATE TABLE Golo (
    idEvento INTEGER NOT NULL,
    idJogador INTEGER NOT NULL,
    minuto INTEGER NOT NULL CHECK (minuto >= 0),
    idJogo INTEGER NOT NULL,
    
    CONSTRAINT GoloJogo_FK FOREIGN KEY (idJogo) REFERENCES Jogo(idJogo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Golo_PK PRIMARY KEY(idEvento),
    CONSTRAINT Golo_FK_Jogador FOREIGN KEY (idJogador) REFERENCES Jogador ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Cartao (
    idEvento INTEGER NOT NULL,
    idJogador INTEGER NOT NULL,
    cor TEXT NOT NULL CHECK (cor LIKE 'amarelo' OR cor LIKE 'vermelho'),
    minuto INTEGER NOT NULL CHECK (minuto >= 0),
    idJogo INTEGER NOT NULL,
    
    CONSTRAINT CartaoJogo_FK FOREIGN KEY (idJogo) REFERENCES Jogo(idJogo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Cartao_PK PRIMARY KEY (idEvento),
    CONSTRAINT Cartao_FK FOREIGN KEY (idJogador) REFERENCES Jogador ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Falta (
    idEvento INTEGER NOT NULL,
    idJogador INTEGER NOT NULL,
    minuto INTEGER NOT NULL CHECK (minuto >= 0),
    idJogo INTEGER NOT NULL,
    
    CONSTRAINT FaltaJogo_FK FOREIGN KEY (idJogo) REFERENCES Jogo(idJogo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Falta_PK PRIMARY KEY(idEvento),
    CONSTRAINT Falta_FK_Jogador FOREIGN KEY (idJogador) REFERENCES Jogador ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE ForaDeJogo (
    idEvento INTEGER NOT NULL,
    idJogador INTEGER NOT NULL,
    idClube INTEGER NOT NULL,
    minuto INTEGER NOT NULL CHECK (minuto >= 0),
    idJogo INTEGER NOT NULL,


    CONSTRAINT ForaDeJogoJogo_FK FOREIGN KEY (idJogo) REFERENCES Jogo(idJogo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ForaDeJogo_PK PRIMARY KEY(idEvento),
    CONSTRAINT ForaDeJogo_FK_Jogador FOREIGN KEY (idJogador) REFERENCES Jogador ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT ForaDeJogo_FK_Clube FOREIGN KEY (idClube) REFERENCES Clube ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Canto (
    idEvento INTEGER NOT NULL,
    idJogador INTEGER NOT NULL,
    idClube INTEGER NOT NULL,
    minuto INTEGER NOT NULL CHECK (minuto >= 0),
    idJogo INTEGER NOT NULL,

    CONSTRAINT CantoJogo_FK FOREIGN KEY (idJogo) REFERENCES Jogo(idJogo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Canto_PK PRIMARY KEY(idEvento),
    CONSTRAINT Canto_FK_Jogador FOREIGN KEY (idJogador) REFERENCES Jogador ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT Canto_FK_Clube FOREIGN KEY (idClube) REFERENCES Clube ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Assistencia (
    idEvento INTEGER NOT NULL,
    idJogador INTEGER NOT NULL,
    minuto INTEGER NOT NULL CHECK (minuto >= 0),
    idJogo INTEGER NOT NULL,
    
    CONSTRAINT AssistenciaJogo_FK FOREIGN KEY (idJogo) REFERENCES Jogo(idJogo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Assistencia_PK PRIMARY KEY(idEvento), 
    CONSTRAINT Assistencia_FK_Jogador FOREIGN KEY (idJogador) REFERENCES Jogador ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Remate (
    idEvento INTEGER NOT NULL,
    idJogador INTEGER NOT NULL,
    naBaliza CHAR(1) NOT NULL CHECK (naBaliza LIKE '0' OR naBaliza LIKE '1'),
    minuto INTEGER NOT NULL CHECK (minuto >= 0),
    idJogo INTEGER NOT NULL,
    
    
    CONSTRAINT RemateJogo_FK FOREIGN KEY (idJogo) REFERENCES Jogo(idJogo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Remate_PK PRIMARY KEY(idEvento),
    CONSTRAINT Remate_FK_Jogador FOREIGN KEY (idJogador) REFERENCES Jogador ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE EstatisticaClubeJogo (
    idEstatisticaClube INTEGER NOT NULL,
    idClube INTEGER NOT NULL,
    idJogo INTEGER NOT NULL,
    numGolos INTEGER DEFAULT 0 CHECK (numGolos >= 0),
    numCartoesAmarelos INTEGER DEFAULT 0 CHECK (numCartoesAmarelos >= 0),
    numCartoesVermelhos INTEGER DEFAULT 0 CHECK (numCartoesVermelhos >= 0 AND numCartoesVermelhos <= 5),
    numFaltas INTEGER DEFAULT 0 CHECK (numFaltas >= 0),
    numRemates INTEGER DEFAULT 0 CHECK (numRemates >= 0),
    numRematesBaliza INTEGER DEFAULT 0 CHECK (numRematesBaliza >= 0 AND numRematesBaliza <= numRemates),
    numCantos INTEGER DEFAULT 0 CHECK (numCantos >= 0),
    numForasDeJogo INTEGER DEFAULT 0 CHECK (numForasDeJogo >= 0),
    numAssistencias INTEGER DEFAULT 0 CHECK (numAssistencias >= 0 AND numAssistencias <= numGolos),

    CONSTRAINT EstatisticaClubeJogo_PK PRIMARY KEY (idEstatisticaClube),
    CONSTRAINT EstatisticaClubeJogo_FK1 FOREIGN KEY (idJogo) REFERENCES Jogo(idJogo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT EstatisticaClubeJogo_FK2 FOREIGN KEY (idClube) REFERENCES Clube(idClube) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE EstadioCapacidadeVIP (
    capacidade INTEGER NOT NULL CHECK (capacidade >= 0),
    numLugaresVIP INTEGER NOT NULL CHECK (numLugaresVIP = capacidade / 100),

    CONSTRAINT EstadioCapacidadeVIP_PK PRIMARY KEY (capacidade)
);

CREATE TABLE Estadio (
    morada TEXT NOT NULL,
    capacidade INTEGER NOT NULL,
    idClube INTEGER NOT NULL,

    CONSTRAINT Estadio_PK PRIMARY KEY (morada),
    CONSTRAINT Estadio_FK_Clube FOREIGN KEY (idClube) REFERENCES Clube ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT capacityCheck CHECK (capacidade >= 0),
    CONSTRAINT EstadioCapacidadeVIP_FK FOREIGN KEY (capacidade) REFERENCES EstadioCapacidadeVIP(capacidade) ON DELETE CASCADE ON UPDATE CASCADE
); 


CREATE TABLE EstatisticaJogadorEpoca (
    idEstatisticaJogadorEpoca INTEGER NOT NULL,
    numJogos INTEGER DEFAULT 0,
    numAssistencias INTEGER DEFAULT 0,
    numGolos INTEGER DEFAULT 0,
    ganhouPremioMelhorMarcador CHAR(1) DEFAULT '0',
    ganhouPremioMelhorAssistencia CHAR(1) DEFAULT '0',
    cartoesVermelhosResetable CHAR(1) DEFAULT '0',
    epoca INTEGER NOT NULL,
    idJogador INTEGER NOT NULL,
    
    CONSTRAINT EstatisticaJogadorEpoca_PK PRIMARY KEY (idEstatisticaJogadorEpoca),
    CONSTRAINT EstatisticaJogadorEpoca_FK_Epoca FOREIGN KEY (epoca) REFERENCES Epoca ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT EstatisticaJogadorEpoca_FK_Jogador FOREIGN KEY (idJogador) REFERENCES Jogador ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT EstatisticaJogarEpocaCheck CHECK ((numAssistencias >= 0) AND 
                                                (numGolos >= 0) AND 
                                                (ganhouPremioMelhorMarcador LIKE '0' OR ganhouPremioMelhorMarcador LIKE '1') AND
                                                (ganhouPremioMelhorAssistencia LIKE '0' OR ganhouPremioMelhorAssistencia LIKE '1') AND
                                                (cartoesVermelhosResetable LIKE '0' OR cartoesVermelhosResetable LIKE '1'))
);

CREATE TABLE EstatisticaJogadorNumJogo (
    idJogador INTEGER NOT NULL,
    idJogo INTEGER NOT NULL,
    numMinutosJogados INTEGER NOT NULL,
    
    CONSTRAINT EstatisticaJogadorNumJogo_PK PRIMARY KEY (idJogador, idJogo),
    CONSTRAINT EstatisticaJogadorNumJogo_FK_PESSOA FOREIGN KEY (idJogador) REFERENCES Pessoa ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT EstatisticaJogadorNumJogo_FK_Jogo FOREIGN KEY (idJogo) REFERENCES Jogo ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE EquipaFuncionarios (
    idEquipaFuncionarios INTEGER NOT NULL,
    idClube INTEGER NOT NULL,

    CONSTRAINT EquipaFuncionarios_PK PRIMARY KEY(idEquipaFuncionarios),
    CONSTRAINT EquipaFuncionarios_FK FOREIGN KEY (idClube) REFERENCES Clube ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Medico (
    idPessoa INTEGER NOT NULL,
    idEquipaFuncionarios NOT NULL,
    nome TEXT NOT NULL,
    morada TEXT NOT NULL,
    nacionalidade TEXT NOT NULL,
    idade INTEGER NOT NULL,
    telefone INTEGER UNIQUE NOT NULL,

    CONSTRAINT Medico_PK PRIMARY KEY(idPessoa),
    CONSTRAINT Medico_FK_Pessoa FOREIGN KEY (idPessoa) REFERENCES Pessoa ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Medico_FK_EquipaFuncionarios FOREIGN KEY (idEquipaFuncionarios) REFERENCES EquipaFuncionarios ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Massagista (
    idPessoa INTEGER NOT NULL,
    idEquipaFuncionarios NOT NULL,
    nome TEXT NOT NULL,
    morada TEXT NOT NULL,
    nacionalidade TEXT NOT NULL,
    idade INTEGER NOT NULL,
    telefone INTEGER UNIQUE NOT NULL,

    CONSTRAINT Massagista_PK PRIMARY KEY(idPessoa),
    CONSTRAINT Massagista_FK_Pessoa FOREIGN KEY (idPessoa) REFERENCES Pessoa ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Massagista_FK_EquipaFuncionarios FOREIGN KEY (idEquipaFuncionarios) REFERENCES EquipaFuncionarios ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ResponsavelGuardaRoupa (
    idPessoa INTEGER NOT NULL,
    idEquipaFuncionarios NOT NULL,
    nome TEXT NOT NULL,
    morada TEXT NOT NULL,
    nacionalidade TEXT NOT NULL,
    idade INTEGER NOT NULL,
    telefone INTEGER UNIQUE NOT NULL,

    CONSTRAINT ResponsavelGuardaRoupa_FK_EquipaFuncionarios_PK PRIMARY KEY(idPessoa) ,
    CONSTRAINT ResponsavelGuardaRoupa_FK_EquipaFuncionarios_FK_Pessoa FOREIGN KEY (idPessoa) REFERENCES Pessoa ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ResponsavelGuardaRoupa_FK_EquipaFuncionarios FOREIGN KEY (idEquipaFuncionarios) REFERENCES EquipaFuncionarios ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE FuncionarioDeLimpeza (
    idPessoa INTEGER NOT NULL,
    idEquipaFuncionarios NOT NULL,
    nome TEXT NOT NULL,
    morada TEXT NOT NULL,
    nacionalidade TEXT NOT NULL,
    idade INTEGER NOT NULL,
    telefone INTEGER UNIQUE NOT NULL,

    CONSTRAINT FuncionariosDeLimpeza_PK PRIMARY KEY(idPessoa),
    CONSTRAINT FuncionariosDeLimpeza_FK_Pessoa FOREIGN KEY (idPessoa) REFERENCES Pessoa ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FuncionariosDeLimpeza_FK_EquipaFuncionarios FOREIGN KEY (idEquipaFuncionarios) REFERENCES EquipaFuncionarios ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Olheiro (
    idPessoa INTEGER NOT NULL,
    idEquipaFuncionarios NOT NULL,
    nome TEXT NOT NULL,
    morada TEXT NOT NULL,
    nacionalidade TEXT NOT NULL,
    idade INTEGER NOT NULL,
    telefone INTEGER UNIQUE NOT NULL,

    CONSTRAINT Olheiro_PK PRIMARY KEY(idPessoa),
    CONSTRAINT Olheiro_FK_Pessoa FOREIGN KEY (idPessoa) REFERENCES Pessoa ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Olheiro_FK_EquipaFuncionarios FOREIGN KEY (idEquipaFuncionarios) REFERENCES EquipaFuncionarios ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE EquipaTecnica (
    idEquipaTecnica INTEGER NOT NULL,
    idClube INTEGER NOT NULL,
    
    CONSTRAINT EquipaTecnica_PK PRIMARY KEY(idEquipaTecnica),
    CONSTRAINT EquipaTecnica_FK FOREIGN KEY (idClube) REFERENCES Clube ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE TreinadorGuardaRedes (
    idPessoa INTEGER NOT NULL,
    idEquipaTecnica NOT NULL,
    nome TEXT NOT NULL,
    morada TEXT NOT NULL,
    nacionalidade TEXT NOT NULL,
    idade INTEGER NOT NULL,
    telefone INTEGER UNIQUE NOT NULL,

    CONSTRAINT TreinadorGuardaRedes_PK PRIMARY KEY(idPessoa),
    CONSTRAINT TreinadorGuardaRedes_FK FOREIGN KEY (idPessoa) REFERENCES Pessoa ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT TreinadorGuardaRedes_FK_EquipaTecnica FOREIGN KEY (idEquipaTecnica) REFERENCES EquipaTecnica ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE TreinadorAdjunto (
    idPessoa INTEGER NOT NULL,
    idEquipaTecnica NOT NULL,
    nome TEXT NOT NULL,
    morada TEXT NOT NULL,
    nacionalidade TEXT NOT NULL,
    idade INTEGER NOT NULL,
    telefone INTEGER UNIQUE NOT NULL,
    
    CONSTRAINT TreinadorAdjunto_PK PRIMARY KEY(idPessoa),
    CONSTRAINT TreinadorAdjunto_FK FOREIGN KEY (idPessoa) REFERENCES Pessoa ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT TreinadorAdjunto_FK_EquipaTecnica FOREIGN KEY (idEquipaTecnica) REFERENCES EquipaTecnica ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE TreinadorPrincipal (
    idPessoa INTEGER NOT NULL,
    idEquipaTecnica NOT NULL,
    nome TEXT NOT NULL,
    morada TEXT NOT NULL,
    nacionalidade TEXT NOT NULL,
    idade INTEGER NOT NULL,
    telefone INTEGER UNIQUE NOT NULL,
    
    CONSTRAINT TreinadorPrincipal_PK PRIMARY KEY(idPessoa),
    CONSTRAINT TreinadorPrincipal_FK FOREIGN KEY (idPessoa) REFERENCES Pessoa ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT TreinadorPrincipal_FK_EquipaTecnica FOREIGN KEY (idEquipaTecnica) REFERENCES EquipaTecnica ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Embaixador (
    idPessoa INTEGER NOT NULL,
    nomeLiga TEXT NOT NULL,
    paisLiga TEXT NOT NULL,
    nome TEXT NOT NULL,
    morada TEXT NOT NULL,
    nacionalidade TEXT NOT NULL,
    idade INTEGER NOT NULL,
    telefone INTEGER UNIQUE NOT NULL,

    CONSTRAINT Embaixador_PK PRIMARY KEY(idPessoa),
    CONSTRAINT Embaixador_FK_Liga FOREIGN KEY (nomeLiga, paisLiga) REFERENCES Liga(nome, pais) ON DELETE RESTRICT ON UPDATE CASCADE
);

  




