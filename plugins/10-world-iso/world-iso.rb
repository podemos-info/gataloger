require 'carmen'
module Gataloger::Plugins
  class WorldISO < Plugin
    def process regions
      # configure locales
      main_locale = @config[:main_locale]
      Carmen.i18n_backend.default_locale = main_locale
      Carmen.reset_i18n_backend
      Carmen.i18n_backend.append_locale_path File.expand_path("locale/", File.dirname(__FILE__))
      @locales = @config[:locales] & Carmen.i18n_backend.available_locales
      
      # browse countries
      Carmen::Country.all.each do |territory|
        code = territory.alpha_2_code
        region = Gataloger::Region.new code: code, type: territory.type, name: territory.name
        add_region regions, territory, region, region, { "ISO-3166-1-a2" => code, "ISO-3166-1-a3" => territory.alpha_3_code, "ISO-3166-1-n" => territory.numeric_code }
      end
    end

private
    def add_region regions, territory, region, root, mappings
      # add translations on every locales
      @locales.each do |locale|
        Carmen.i18n_backend.locale = locale.to_sym
        region.translations[locale] = territory.name
      end
      Carmen.i18n_backend.locale = Carmen.i18n_backend.default_locale

      # add region to results
      regions << region

      mappings.each do |encoding, code|
        regions.add_mapping region.uid, encoding, code
      end
      

      # browse subregions
      territory.subregions.each do |subterritory|
        subregion = Gataloger::Region.new code: subterritory.code, parent: region, type: subterritory.type, name: subterritory.name
        add_region regions, subterritory, subregion, root, { "ISO-3166-2" => "#{root.code}-#{subterritory.code}" }
      end
    end
  end
end

# allows to override default locale
module Carmen::I18n
  class Simple
    def default_locale
      @default_locale
    end
    def default_locale= value
      @default_locale = value
    end

    def DEFAULT_LOCALE
      @default_locale
    end
  end
end
