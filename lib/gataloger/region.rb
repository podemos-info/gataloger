module Gataloger
  class Regions
    def initialize
      @regions = {}
      @mappings = Hash.new { |hash, key| hash[key] = {} }
    end

    def << region
      raise "Duplicated Unique ID: #{region.uid} (#{region.type})" if @regions.member? region.uid
      @regions[region.uid] = region
    end

    def [] uid
      @regions[uid]
    end

    def each(&block)
      @regions.values.each(&block)
    end

    def add_mapping uid, encoding, code
      @mappings[encoding][code] = uid
    end

    def each_mapping &block
      @mappings.each do |encoding, mappings|
        mappings.each do |code, uid|
          yield [ uid, encoding, code]
        end
      end
      nil
    end

    def mapping encoding, code
      raise "Unknown encoding" if @mappings[encoding].nil?
      @regions[@mappings[encoding][code]]
    end
  end

  class Region
    attr_reader :parent, :uid, :code, :type, :name, :metadata, :relations, :translations, :subregions
    def initialize args = {}
      @separator = args[:separator] || "-"
      @parent = args[:parent]
      @uid = @code = args[:code]
      @type = args[:type]
      @name = args[:name]
      @metadata = args[:metadata] || {}
      @translations = args[:translations] || {}
      @subregions = {}
      if @parent 
        if @parent.code
          @uid = @parent.uid + @separator + @code
        end
        @parent << self
      end
    end

    def <<(subregion)
      @subregions[subregion.code] = subregion
    end
  end

  class ExtraRegion < Region
    def initialize args = {}
      args[:separator] = "+" + args.fetch(:extra_type, "")
      super args
    end
  end
end
