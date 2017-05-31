# language: es
Característica: Datos de España adicionales
  Cierta información geográfica de España de utilidad no está disponible tampoco en el INE
  por lo que se añade un proceso que carga esta información de otras fuentes o que se incorpora de forma estática

  Escenario: Datos de distritos de municipios grandes
    Cuando se ejecuta el programa
    Entonces se obtiene un listado con los distritos de los municipios más poblados de España (Madrid, Barcelona, Valencia, Sevilla y Bilbao)

  Escenario: Datos de códigos postales
    Cuando se ejecuta el programa
    Entonces se asocian los códigos postales a cada municipio de España

  Escenario: Datos legacy de Podemos
    Cuando se ejecuta el programa
    Entonces se asocian los códigos utilizados anteriormente por las aplicaciones de Podemos a las comunidades autónomas de España
