-- Patrocinadores que patrocinam um clube e uma época ao mesmo tempo

.mode columns
.headers on
.nullvalue NULL

select Patrocinador.idPatrocinador, Patrocinador.nome
from (
    select idPatrocinador
    from PatrocinadorClube
    intersect
    select idPatrocinador 
    from PatrocinadorEpoca
) Patrocinadores
join Patrocinador on Patrocinadores.idPatrocinador=Patrocinador.idPatrocinador;
