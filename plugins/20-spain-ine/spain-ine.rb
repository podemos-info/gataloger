require 'open-uri'
require 'roo'
require 'roo-xls'

module Gataloger::Plugins
  class SpainINE < Plugin
    include Methadone::CLILogging

    def prepare
      # create cache folder
      path = File.join(@config[:paths][:cache], "spain-ine")
      FileUtils.mkdir_p path

      local_path = File.join(path, "codmun.xlsx")
      unless @config[:cache] && File.exists?(local_path)
        # find current list url
        download = nil
        year = Date.today.year%100
        year.downto(17).each do |i|
          url = "http://www.ine.es/daco/daco42/codmun/codmun#{i}/#{i}codmun.xlsx"
          download = open(url) rescue nil
          break unless download.nil?
        end

        if download.nil?
          warn "! Can't download municipalities list from INE."
        else
          # download list and convert to an usable format
          IO.copy_stream(download, local_path)
        end
      end

      if File.exists? local_path
        excel = Roo::Excelx.new(local_path)

        CSV.open(input_path("municipios.csv"), "wb", headers: [ :prov, :mun, :dc, :name]) do |csv|
          csv << ["INE-PROV", "INE-MUNI", "INE-MUNI-DC", "NOMBRE"]
          excel.sheet(0).parse(prov: "CPRO", mun: "CMUN", dc: "DC", name: "NOMBRE").each do |row|
            csv << row.values_at(:prov, :mun, :dc, :name)
          end
        end
      end

      local_path = File.join(path, "pobmun.zip")
      unless @config[:cache] && File.exists?(local_path)
        download = nil
        url = "http://www.ine.es/pob_xls/pobmun.zip"
        download = open(url) rescue nil
        
        if download.nil?
          warn "! Can't download municipalities population from INE."
        else
          # download list and convert to an usable format
          IO.copy_stream(download, local_path)
        end
      end

      if File.exists? local_path
        temp_folder = File.join path, "tmp"
        FileUtils.mkdir_p temp_folder
        FileUtils.rm_f Dir[File.join(temp_folder, "*")]

        CSV.open(input_path("municipios.poblacion.csv"), "wb", headers: [ :fecha, :prov, :mun, :hombres, :mujeres ]) do |csv|
          csv << ["AÑO", "INE-PROV", "INE-MUNI", "HOMBRES", "MUJERES" ]
          Zip::File.open(local_path) do |zipfile|
            zipfile.each do |file|

              year = file.name.scan(/[^\d]*(\d\d).*/).flatten.first.to_i
              next if year==96 # ignore year 1996 (invalid data)
              year += year<96 ? 2000 : 1900

              temp_file = File.join temp_folder, file.name
              file.extract(temp_file)
              excel = Roo::Spreadsheet.open(temp_file)
              excel.sheet(0).parse(prov: /CPRO|Código provincia/, mun: /CMUN|Código Municipio/, 
                                 hombres: /Hombres|Varones/i, mujeres: /Mujeres/i).each do |row|
                prov, mun, hombres, mujeres = row.values_at(:prov, :mun, :hombres, :mujeres)
                next if mun.nil?
                mun = mun.to_i/10 if year==1998 # year 1998 includes DC on municipality code
                csv << [ year, prov.to_s.rjust(2,"0"), mun.to_s.rjust(3,"0"), hombres.to_i, mujeres.to_i ]
              end
            end
          end
        end

        FileUtils.rm_rf temp_folder
      end
    end

    def process regions
      CSV.foreach(input_path("ccaa.csv"), headers: true) do |row|
        regions.add_mapping row["UID"], "INE-CCAA", row["INE-CCAA"]
      end

      CSV.foreach(input_path("provincias.csv"), headers: true) do |row|
        regions.add_mapping row["UID"], "INE-PROV", row["INE-PROV"]
      end

      CSV.foreach(input_path("islas.csv"), headers: true) do |row|
        island = Gataloger::ExtraRegion.new extra_type: "I", code: row["ID"], parent: regions[row["UID-PADRE"]], type: "island", name: row["NOMBRE"], mappings: { "INE-ISLA" => row["INE-ISLA"] }
        regions << island
      end

      municipalities_path = input_path("municipios.csv")
      if File.exists? municipalities_path

        CSV.foreach(municipalities_path, headers: true) do |row|
          name = row["NOMBRE"].split(", ").reverse.join(" ")
          province = regions.mapping("INE-PROV", row["INE-PROV"])

          municipality = Gataloger::Region.new code: row["INE-MUNI"], parent: province, type: "municipality", name: name
          municipality.translations["es"] = name
          regions << municipality

          regions.add_mapping municipality.uid, "INE-MUNI", row["INE-PROV"]+row["INE-MUNI"]
          regions.add_mapping municipality.uid, "INE-MUNI-DC", row["INE-PROV"]+row["INE-MUNI"]+row["INE-MUNI-DC"]
        end

        municipalities_census_path = input_path("municipios.poblacion.csv")
        CSV.foreach(municipalities_census_path, headers: true) do |row|
          year = row["AÑO"]
          municipality = regions.mapping("INE-MUNI", row["INE-PROV"]+row["INE-MUNI"])
          if municipality
            municipality.metadata["pob-#{year}-female"] = row["MUJERES"]
            municipality.metadata["pob-#{year}-male"] = row["HOMBRES"]
          end
        end
        
      else
        warn "! INE municipalities list not available. Run spain-ine plugin with --prepare flag to download it."
      end
    end

private
    def input_path name
      File.expand_path("input/#{name}", File.dirname(__FILE__))
    end
  end
end
