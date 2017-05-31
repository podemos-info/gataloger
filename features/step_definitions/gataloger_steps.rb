Cuando(/^se ejecuta el programa(?: sin parámetros)?$/) do
  run_with_options
end

Cuando(/^se ejecuta la aplicación con el parámetro --([^ ]*)$/) do |param|
  enable = !param.start_with?("no-")
  param = param[3..-1] unless enable
  run_with_options param.to_sym => enable
end

Cuando(/^se ejecuta el plugin ([^ ]*) con el parámetro --([^ ]*)$/) do |plugin, param|
  enable = !param.start_with?("no-")
  param = param[3..-1] unless enable
  run_with_options param.to_sym => enable, plugins: { plugin => true }
end

Cuando(/^se ejecuta el plugin ([^ ]*)$/) do |plugin|
  run_with_options plugins: { plugin => true }
end

Entonces(/^se descargan todos los ficheros necesarios para el programa$/) do
  all_plugins.each do |plugin|
    step %{the output should contain " * #{plugin} prepared successfully\n"}
  end
end

Entonces(/^se realizan todos los pasos$/) do
  step %{se realizan los pasos indicados por los parámetros}
end

Entonces(/^se obtienen los ficheros de salida$/) do
  expect("output/territories.tsv").to be_an_existing_file
  expect("output/territories.mappings.tsv").to be_an_existing_file
  expect("output/territories.metadata.tsv").to be_an_existing_file
  expect("output/territories.translations.tsv").to be_an_existing_file
end

Entonces(/^se realizan todos los pasos menos los indicados por los parámetros$/) do
  step %{se realizan los pasos indicados por los parámetros}
end

Entonces(/^se obtienen los ficheros de salida, que no incluyen los pasos ignorados$/) do
  step %{se obtienen los ficheros de salida}
  pending "comprobar que no se ha ejecutado el plugin indicado"
end

Entonces(/^se realizan los pasos indicados por los parámetros$/) do
  all_plugins.each do |plugin|
    if @config[:plugins][plugin]
      step %{the output should contain " * #{plugin} processed successfully\n"}
    else
      step %{the output should not contain " * #{plugin} processed successfully\n"}
    end
  end
end

Entonces(/^no se realizan el resto de pasos$/) do
  expect("output/territories.tsv").not_to be_an_existing_file
  expect("output/territories.mappings.tsv").not_to be_an_existing_file
  expect("output/territories.metadata.tsv").not_to be_an_existing_file
  expect("output/territories.translations.tsv").not_to be_an_existing_file
end
