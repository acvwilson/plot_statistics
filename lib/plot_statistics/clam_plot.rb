class PlotStatistics
  class ClamPlot
    attr_accessor :clams, :stats

    AREA_OF_PLOT  = 10_000
    MAX_RADIUS    = 50
    PLOT_CORNERS = [[0,0], [0,100], [100,0], [100,100]]

    def initialize(clams)
      @clams = clams
      setup_clam_distances(@clams)
      @stats = OpenStruct.new(:k_ts => [], :l_ts => [])
      calculate_stats
    end

    def self.create_random(number_of_clams)
      clams = (1..number_of_clams).map { Clam.create_random }
      new(clams)
    end

    def self.create_regular(distance=5)
      clams = []
      (0..100).each do |x|
        (0..100).each do |y|
          mod_x = x % distance
          mod_y = x % distance
          clams << Clam.new(:x => x, :y => y) if mod_x == 0 && mod_y == 0
        end
      end
      new(clams)
    end

    def number_of_clams
      clams.size.to_f
    end

    def setup_clam_distances(clams)
      clams.each_with_index do |reference_clam, i|
        clams[(i + 1)..-1].each do |other_clam|
          distance = distance_between_clams(reference_clam, other_clam)
          reference_clam.distances << distance
          other_clam.distances << distance
        end
      end
    end

    def distance_between_clams(clam1, clam2)
      Math.sqrt((clam1.x - clam2.x) ** 2 + (clam1.y - clam2.y) ** 2)
    end

    def calculate_stats
      (1..MAX_RADIUS).each do |radius|

        sums = clams.inject(0.0) do |sum, clam|
          clams_inside_circle = clam.distances.select { |distance| distance <= radius }

          circle_proportion = Circle.new(:clam => clam, :radius => radius).proportion_inside_plot
          reciprocal_proportion = 1.0 / circle_proportion

          reciprocal_proportion * clams_inside_circle.size
        end

        k_t = AREA_OF_PLOT * sums / (number_of_clams ** 2)

        expected = number_of_clams * Math::PI * (radius ** 2) / AREA_OF_PLOT
        l_t = expected - Math.sqrt( k_t / Math::PI)

        stats.k_ts << k_t
        stats.l_ts << l_t
      end
    end
  end
end