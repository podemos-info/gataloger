# language: es
Característica: Exportación de datos
  Para unificar y potenciar el manejo de datos geográficos
  se realizará un proceso único de generación de ficheros con datos normalizados y combinados
  que luego deberán ser incorporados por las aplicaciones que los necesiten.

  Escenario: Ejecución normal del programa
    Cuando se ejecuta el programa sin parámetros
    Entonces se realizan todos los pasos
    Y se obtienen los ficheros de salida

  Escenario: Obtención de datos externos
    Cuando se ejecuta la aplicación con el parámetro --prepare
    Entonces se descargan todos los ficheros necesarios para el programa
    Y no se realizan el resto de pasos

  Escenario: Se ignora uno o varios pasos del programa
    Cuando se ejecuta la aplicación con el parámetro --no-spain-extra
    Entonces se realizan todos los pasos menos los indicados por los parámetros
    Y se obtienen los ficheros de salida

  Escenario: Se ejecuta uno o varios pasos del programa
    Cuando se ejecuta la aplicación con el parámetro --world-iso
    Entonces se realizan los pasos indicados por los parámetros
    Y se obtienen los ficheros de salida
