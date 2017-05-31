Entonces(/^se obtiene un listado de todos los países del mundo$/) do
  countries = 0
  read_output("output/territories.tsv") do |row|
    countries += 1 if row["Type"]=="country"
  end
  expect(countries).to be >= 248
end

Entonces(/^se obtienen los códigos asociados al estándar ISO 3166-1 de los países \(alfanuméricos 2 y 3, y numéricos\)$/) do
  expect("output/territories.mappings.tsv").to output_include ["ES", "ISO-3166-1-a2", "ES" ],
                                                   ["ES", "ISO-3166-1-a3", "ESP" ],
                                                   ["ES", "ISO-3166-1-n", "724" ],
                                                   ["AR", "ISO-3166-1-a2", "AR" ],
                                                   ["AR", "ISO-3166-1-a3", "ARG" ],
                                                   ["AR", "ISO-3166-1-n", "032" ]
end

Entonces(/^se obtienen los nombres de los territorios al menos en castellano e inglés$/) do
  expect("output/territories.translations.tsv").to output_include ["ES", "es", "España" ],
                                                       ["ES", "en", "Spain" ],
                                                       ["BR", "es", "Brasil" ],
                                                       ["BR", "en", "Brazil" ]
end

Entonces(/^cada país es identificado de forma única$/) do
  ids = []
  read_output("output/territories.tsv") do |row|
    ids << row["UID"] if row["Type"]=="country"
  end

  expect(ids.count).to eq(ids.uniq.count)
end

Entonces(/^se obtiene un listado de las regiones de los países más importantes$/) do
  subregions = 0
  read_output("output/territories.tsv") do |row|
    subregions += 1 if row["Type"]!="country"
  end
  expect(subregions).to be >= 4000
end

Entonces(/^se obtienen los códigos asociados al estándar ISO 3166-2 de las regiones$/) do
  expect("output/territories.mappings.tsv").to output_include ["ES-AN", "ISO-3166-2", "ES-AN" ],
                                                   ["ES-CM-AB", "ISO-3166-2", "ES-AB" ],
                                                   ["AR-A", "ISO-3166-2", "AR-A" ],
                                                   ["AR-B", "ISO-3166-2", "AR-B" ]
end

Entonces(/^se obtienen los países a los que pertenecen$/) do
  countries = []
  subregions = []
  read_output("output/territories.tsv") do |row|
    if row["Type"]=="country"
      countries << row["UID"]
    else
      subregions << row["UID"][0..1]
    end
  end

  non_countries = subregions - countries
  expect(non_countries).to be_empty
end

Entonces(/^cada región es identificada de forma única$/) do
  ids = []
  read_output("output/territories.tsv") do |row|
    ids << row["UID"] if row["Type"]!="country"
  end

  expect(ids.count).to eq(ids.uniq.count)
end