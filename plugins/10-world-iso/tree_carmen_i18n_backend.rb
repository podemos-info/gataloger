# frozen_string_literal: true

require 'carmen'

module Gataloger
  module Plugins
    class TreeCarmenI18nBackend < Carmen::I18n::Simple
      def initialize(locales, paths)
        super(*paths)
        @locales = locales
      end

      def translations(key, branch = nil, default_value = nil, acumulator = {})
        (branch || @locales).each do |locale, children|
          if default_value && !(@cache.member?(locale) && read_from_hash(key, @cache[locale]))
            acumulator[locale] = default_value
          else
            self.locale = locale
            acumulator[locale] = translate(key)
          end
          translations(key, children, acumulator[locale], acumulator)
        end
        acumulator
      end
    end
  end
end

module Carmen
  class Region
    def translations
      Carmen.i18n_backend.translations path('name')
    end
  end
end
