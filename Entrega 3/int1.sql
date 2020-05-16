-- Árbitros que arbitraram o primeiro jogo do F.C.Porto (idClube = 7) na época de 2019.

select Arbitros.idArbitro, Arbitros.nome
from (
    select ArbitroJogo.idArbitro, Arbitro.nome, Jogo.idJornada as numJornada, 
        Jornada.epoca as anoEpoca, Jogo.idClubeCasa as equipaCasa, Jogo.idClubeFora as equipaFora
    from ArbitroJogo 
        join Jogo on ArbitroJogo.idJogo = Jogo.idJogo
        join Jornada on Jogo.idJornada = Jornada.idJornada
        join Epoca on Jornada.epoca = Epoca.anoInicio
        join Clube clubeEmCasa on Jogo.idClubeCasa = clubeEmCasa.idClube
        join Clube clubeFora on Jogo.idClubeFora = clubeFora.idClube
        join Arbitro on ArbitroJogo.idArbitro = Arbitro.idPessoa
) Arbitros
where 
    Arbitros.anoEpoca = 2019 and
    Arbitros.numJornada = (
        SELECT min(idJornada) 
        from Jornada 
        JOIN Epoca on Jornada.epoca = Epoca.anoInicio 
        WHERE Epoca.anoInicio = 2019
    )
    and (
        Arbitros.equipaCasa = 7
        or Arbitros.equipaFora = 7 
    );



-- mudar relatório (pág. 6), arbitro tem que herdar atributos de pessoa