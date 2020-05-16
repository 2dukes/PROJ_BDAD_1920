-- Patrocinadores que patrocinam um clube e uma época ao mesmo tempo

select Patrocinador.idPatrocinador, Patrocinador.nome
from (
    select idPatrocinador
    from PatrocinadorClube
    intersect
    select idPatrocinador 
    from PatrocinadorEpoca
) Patrocinadores
join Patrocinador on Patrocinadores.idPatrocinador=Patrocinador.idPatrocinador;
