class PlotStatistics
  class ClamPlot
    attr_accessor :clams, :dead_clams, :stats

    AREA_OF_PLOT  = 10_000
    MAX_RADIUS    = 50
    PLOT_CORNERS = [[0,0], [0,100], [100,0], [100,100]]

    def initialize(clams, dead_clams=[])
      @clams = clams
      @dead_clams = dead_clams
    end

    def univariate_analysis
      self.stats = OpenStruct.new(:k_ts => [], :l_ts => [])
      setup_clam_distances
      calculate_univariate_stats
      self
    end

    def bivariate_analysis
      self.stats = OpenStruct.new(:k_ts => [], :dead_k_ts => [], :l_ts => [])
      setup_clam_distances
      setup_clam_distances(:dead_clams)
      calculate_bivariate_stats
      self
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
          mod_y = y % distance
          clams << Clam.new(:x => x, :y => y) if mod_x == 0 && mod_y == 0
        end
      end
      new(clams)
    end

    def self.create_random_from(clam_plot)
      number_dead = clam_plot.dead_clams.size
      all_clams = clam_plot.dead_clams | clam_plot.clams
      dead_clams = all_clams.shuffle.slice(0...number_dead)
      live_clams = all_clams - dead_clams
      new(live_clams, dead_clams)
    end

    def number_of_clams
      clams.size.to_f
    end

    def setup_clam_distances(clam_type='clams')
      reset_clam_distances
      send(clam_type).each_with_index do |reference_clam, i|
        send(clam_type)[(i + 1)..-1].each do |other_clam|
          distance = distance_between_clams(reference_clam, other_clam)
          reference_clam.distances << distance
          other_clam.distances << distance
        end
      end
    end

    def distance_between_clams(clam1, clam2)
      Math.sqrt((clam1.x - clam2.x) ** 2 + (clam1.y - clam2.y) ** 2)
    end

    def calculate_bivariate_stats
      (1..MAX_RADIUS).each do |radius|

        live_k_t = calculate_k_t(radius)
        dead_k_t = calculate_k_t(radius, :dead_clams)
        l_t      = calculate_bivariate_l_t(live_k_t, dead_k_t, radius)

        stats.k_ts << live_k_t
        stats.dead_k_ts << dead_k_t
        stats.l_ts << l_t
      end
    end

    def calculate_univariate_stats
      (1..MAX_RADIUS).each do |radius|

        k_t = calculate_k_t(radius)
        l_t = calculate_univariate_l_t(k_t, radius)

        stats.k_ts << k_t
        stats.l_ts << l_t
      end
    end

    def calculate_k_t(radius, clam_type='clams')
      sums = send(clam_type).inject(0.0) do |sum, clam|
        clams_inside_circle = clam.distances.select { |distance| distance <= radius }

        circle_proportion = Circle.new(:clam => clam, :radius => radius).proportion_inside_plot
        reciprocal_proportion = 1.0 / circle_proportion

        inner_sum = reciprocal_proportion * clams_inside_circle.size
        sum += inner_sum
      end

      AREA_OF_PLOT * sums / (number_of_clams ** 2)
    end

    def calculate_univariate_l_t(k_t, radius)
      radius - Math.sqrt( k_t / Math::PI)
    end

    def calculate_bivariate_l_t(live_k_t, dead_k_t, radius)
      radius - Math.sqrt( (live_k_t - dead_k_t).abs / Math::PI)
    end

    def reset_clam_distances
      (clams | dead_clams).each { |clam| clam.reset_distances }
    end
  end
end