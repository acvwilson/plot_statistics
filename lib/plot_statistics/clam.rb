class PlotStatistics
  class Clam
    attr_accessor :x, :y, :distances

    def initialize(params={})
      @x = params[:x]
      @y = params[:y]
      @distances = params[:distances] || []
    end

    def self.create_random
      new( :x => rand(100), :y => rand(100) )
    end
  end
end