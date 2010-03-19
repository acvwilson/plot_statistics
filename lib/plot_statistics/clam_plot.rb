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
      clams = []
      while clams.size < 100 do
        new_clam = Clam.create_random
        next if clams.any? { |clam| clam == new_clam }
        clams << new_clam
      end
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

        k_t = calculate_k_t(radius)
        l_t = calculate_l_t(k_t, radius)

        stats.k_ts << k_t
        stats.l_ts << l_t
      end
    end

    def calculate_k_t(radius)
      sums = clams.inject(0.0) do |sum, clam|
        clams_inside_circle = clam.distances.select { |distance| distance <= radius }

        circle_proportion = Circle.new(:clam => clam, :radius => radius).proportion_inside_plot
        reciprocal_proportion = 1.0 / circle_proportion

        inner_sum = reciprocal_proportion * clams_inside_circle.size
        sum += inner_sum
      end

      AREA_OF_PLOT * sums / (number_of_clams ** 2)
    end

    def calculate_l_t(k_t, radius)
      radius - Math.sqrt( k_t / Math::PI)
    end
  end
end