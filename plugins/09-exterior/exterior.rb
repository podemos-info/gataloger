# frozen_string_literal: true

require 'carmen'

module Gataloger
  module Plugins
    class Exterior < Plugin
      def process(regions)
        # add Exterior special zone
        exterior = Gataloger::Region.new code: 'XX',
                                         type: 'zone',
                                         name: 'Exterior'
        exterior.translations.merge!(
          'es' => 'Exterior',
          'ca' => 'Exterior',
          'eu' => 'Atzerria',
          'ga' => 'Estranxeiro',
          'en' => 'Abroad'
        )
        regions << exterior
      end
    end
  end
end
