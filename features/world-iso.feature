# language: es
Característica: Datos de países de todo el mundo
  Para poder gestionar datos asociados a cualquier parte del mundo
  se requiere disponer de un listado de todos los países y de sus principales regiones
  que permita relacionarla con diversos estándares e incluya información estadística 
  
  Escenario: Datos de todos los países del mundo
    Cuando se ejecuta el programa
    Entonces se obtiene un listado de todos los países del mundo
    Y se obtienen los códigos asociados al estándar ISO 3166-1 de los países (alfanuméricos 2 y 3, y numéricos)
    Y se obtienen los nombres de los territorios al menos en castellano e inglés
    Y cada país es identificado de forma única

  Escenario: Datos de regiones de los países del mundo más relevantes
    Cuando se ejecuta el programa
    Entonces se obtiene un listado de las regiones de los países más importantes
    Y se obtienen los códigos asociados al estándar ISO 3166-2 de las regiones
    Y se obtienen los países a los que pertenecen
    Y se obtienen los nombres de los territorios al menos en castellano e inglés
    Y cada región es identificada de forma única
