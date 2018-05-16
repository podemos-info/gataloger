# frozen_string_literal: true

require 'carmen'
require File.dirname(__FILE__) + '/tree_carmen_i18n_backend'

module Gataloger
  module Plugins
    class WorldISO < Plugin
      def process(regions)
        # configure locales
        Carmen.i18n_backend.append_locale_path File.expand_path('locales/', File.dirname(__FILE__))
        Carmen.i18n_backend = TreeCarmenI18nBackend.new(@config[:locales], Carmen.i18n_backend.locale_paths.map(&:to_s))

        # browse countries
        Carmen::Country.all.each do |territory|
          code = territory.alpha_2_code
          region = Gataloger::Region.new code: code,
                                         type: territory.type,
                                         name: territory.name
          add_region regions, territory, region, region,
                     'ISO-3166-1-a2' => code,
                     'ISO-3166-1-a3' => territory.alpha_3_code,
                     'ISO-3166-1-n' => territory.numeric_code
        end
      end

      private

      def add_region(regions, territory, region, root, mappings)
        # add translations on every locales
        region.translations.merge!(territory.translations)

        # add region to results
        regions << region

        mappings.each do |encoding, code|
          regions.add_mapping region.uid, encoding, code
        end

        # browse subregions
        territory.subregions.each do |subterritory|
          subregion = Gataloger::Region.new code: subterritory.code,
                                            parent: region,
                                            type: subterritory.type,
                                            name: subterritory.name
          add_region regions, subterritory, subregion, root,
                     'ISO-3166-2' => "#{root.code}-#{subterritory.code}"
        end
      end
    end
  end
end
