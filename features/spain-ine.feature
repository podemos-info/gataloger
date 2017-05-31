# language: es
Característica: Datos de España basados en información de INE
  Para aumentar el nivel de detalle de la información de España
  se utilizará los datos oficiales publicados por el INE
  que además permiten conectar las aplicaciones con otras que trabajen en el ambito estatal

  Escenario: Descarga de datos actualizados de los municipios
    Cuando se ejecuta la aplicación con el parámetro --prepare
    Entonces se descarga el fichero de datos con municipios de la página del INE
    Y se descarga el fichero con el censo de los municipios de la página del INE

  Escenario: Datos de los municipios de España
    Cuando se ejecuta el programa
    Entonces se obtiene un listado de todos los municipios de España
    Y se obtienen los códigos INE asociados a los municipios
    Y se obtienen los nombres de los municipios al menos en castellano
    Y se obtienen las provincias a las que pertenecen los municipios
    Y cada municipio es identificado de forma única  

  Escenario: Datos de las islas de España
    Cuando se ejecuta el programa
    Entonces se obtiene un listado de todas las islas de España
    Y se obtienen los códigos INE asociados a las islas
    Y se obtienen los nombres de las islas al menos en castellano
    Y se obtienen las provincias a las que pertenecen las islas
    Y cada isla es identificada de forma única  

  Escenario: Datos adicionales de los territorios
    Cuando se ejecuta el programa
    Entonces se añaden los códigos INE asociados a las regiones de España presentes en el estándar ISO-3166 (comunidades y ciudades autónomas, provincias)
      Y se añade la población y superficie de todos los territorios de España

