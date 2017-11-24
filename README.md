# Gataloger
> A Geographical dATA gatherer and cataLOGER. 

Gataloger features the following:

* A generic system for geographical and statistical data gathering
* A simple and easy to use format to store, transfer and process geographical information
* Plugins based on World and Spain information that can be optionally used

It consist in a console application that gathers information from several sources and generates a standard and static database. Each layer of data is fetched with a plugin, usually associated to a source. This database could be used in any application through a loading process. It allows to regenerate data files to include source changes.
It current setup is created specifically to have Spanish extra details, but it can be adapted easily to be used in other territories.

# How to Use Gataloger
Install and run.

    bundle install
    bundle exec bin/gataloger --prepare
  
The ```--prepare``` downloads external files and generates additional input files, it must be used in the first run. Downloaded files are cached, use ```--no-cache``` to force the program to download them again.

After its execution, output files will be in the ```output``` folder:
* `territories.tsv` will contain a territory per line, with a unique identifier (UID), a name and a territory name.
* `territories.translations.tsv` will contain a translation per line, with a UID, locale and translation. Languages used can be set on command execution.
* `territories.mappings.tsv` will contain different a standard association per line, with a UID, a standard code and it associated value.
* `territories.metadata.tsv` will contain extra information per line, with a UID, and a key-value pair.

# Information sources evaluated / used

unlocode all iso 3166-2
- http://www.unece.org/cefact/codesfortrade/codes_index.html

carmen: iso-3166-2 + i18n
- https://github.com/jim/carmen

## Spain
INE:
- https://github.com/PopulateTools/ine-places

Towns:
- http://www.ine.es/dyngs/INEbase/es/operacion.htm?c=Estadistica_C&cid=1254736177031&menu=ultiDatos&idp=1254734710990
 - http://www.ine.es/daco/daco42/codmun/codmun17/17codmun.xlsx
- http://www.ine.es/dynt3/inebase/es/index.html?padre=517&dh=1

Towns and sublevels
- http://www.ine.es/nomen_files/nacional/Nacional_2016.zip

Postal codes
- https://github.com/luismiramirez/spain_zip_codes
- https://www.codigospostales.com/descarga.html

## Maps
- https://github.com/topojson/world-atlas
- https://github.com/martgnz/es-atlas
- http://www.tnoda.com/blog/2013-12-07
- http://www.naturalearthdata.com/downloads/10m-cultural-vectors/
