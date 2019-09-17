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

      CSV.foreach(input_path("extra.csv"), headers: true) do |row|
        autonomous_community = regions.mapping("INE-CCAA", row["INE-CCAA"])
        regions.add_mapping autonomous_community.uid, "PARTICIPA1-CCAA", row["PARTICIPA1-CCAA"]
        regions.add_mapping autonomous_community.uid, "PARTICIPA1-SLUG", row["SLUG"]
      end
    end

    private

    def input_path name
      File.expand_path("input/#{name}", File.dirname(__FILE__))
    end
  end
end
