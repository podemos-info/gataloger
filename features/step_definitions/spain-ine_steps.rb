
Entonces(/^se descarga el fichero de datos con municipios de la página del INE$/) do
  expect("cache/spain-ine/codmun.xlsx").to be_an_existing_file
end

Entonces(/^se descarga el fichero con el censo de los municipios de la página del INE$/) do
  expect("cache/spain-ine/pobmun.zip").to be_an_existing_file
end

Entonces(/^se obtiene un listado de todos los municipios de España$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Entonces(/^se obtienen los códigos INE asociados a los municipios$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Entonces(/^se obtienen los nombres de los municipios al menos en castellano$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Entonces(/^cada municipio es identificado de forma única$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Entonces(/^cada identificador generado es único$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Entonces(/^se obtienen las provincias a las que pertenecen los municipios$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Entonces(/^se obtienen las provincias a las que pertenecen las islas$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Entonces(/^se obtiene un listado de todas las islas de España$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Entonces(/^se obtienen los códigos INE asociados a las islas$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Entonces(/^se obtienen los nombres de las islas al menos en castellano$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Entonces(/^cada isla es identificada de forma única$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Entonces(/^se añaden los códigos INE asociados a las regiones de España presentes en el estándar ISO\-(\d+) \(comunidades y ciudades autónomas, provincias\)$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Entonces(/^se añade la población y superficie de todos los territorios de España$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
