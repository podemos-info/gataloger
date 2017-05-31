module Gataloger::Plugins
  class SpainExtra < Plugin

    def prepare
      #añadir distritos
      #codigos postales
    end

    def process regions
      CSV.foreach(input_path("distritos.csv"), headers: true) do |row|
        name = row["NOMBRE"]
        municipality = regions.mapping("INE-MUNI", row["INE-PROV"]+row["INE-MUNI"])
        district = Gataloger::Region.new code: row["ID"], parent: municipality, type: "district", name: name
        district.translations["es"] = name
        regions << district
      end
    end

private
    def input_path name
      File.expand_path("input/#{name}", File.dirname(__FILE__))
    end
  end
end
