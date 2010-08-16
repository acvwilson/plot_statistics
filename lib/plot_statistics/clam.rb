class PlotStatistics
  class Clam
    attr_accessor :x, :y, :distances

    def initialize(params={})
      @x = params[:x].to_f
      @y = params[:y].to_f
      @distances = params[:distances] || []
    end

    def self.create_random
      new( :x => rand(100), :y => rand(100) )
    end

    def ==(other)
      return super(other) unless other.kind_of?(PlotStatistics::Clam)
      self.x == other.x && self.y == other.y
    end

    def reset_distances
      distances.clear
    end
  end
end