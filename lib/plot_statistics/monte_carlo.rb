class PlotStatistics
  class MonteCarlo
    attr_accessor :plots, :stats

    def initialize(number_of_clams, number_of_plots=100)
      @plots = (1..number_of_plots).map { ClamPlot.create_random number_of_clams }
      @stats = OpenStruct.new(:mean        => OpenStruct.new(:k_ts => [], :l_ts => []),
                              :upper_limit => OpenStruct.new(:k_ts => [], :l_ts => []),
                              :lower_limit => OpenStruct.new(:k_ts => [], :l_ts => []))
      calculate_means
      calculate_limits
    end

    def calculate_means
      (0...ClamPlot::MAX_RADIUS).each do |radius|
        stats.mean.k_ts << average_k(radius)
        stats.mean.l_ts << average_l(radius)
      end
    end

    def calculate_limits
      (0...ClamPlot::MAX_RADIUS).each do |radius|
        threshold_k = standard_deviation_k(radius) * 2
        threshold_l = standard_deviation_l(radius) * 2

        stats.upper_limit.k_ts << (stats.mean.k_ts[radius] + threshold_k)
        stats.upper_limit.l_ts << (stats.mean.l_ts[radius] + threshold_l)
        stats.lower_limit.k_ts << (stats.mean.k_ts[radius] - threshold_k)
        stats.lower_limit.l_ts << (stats.mean.l_ts[radius] - threshold_l)
      end
    end

    def standard_deviation_k(radius)
      sum = plots.inject(0) do |sum, plot|
        (plot.stats.k_ts[radius] - stats.mean.k_ts[radius]) ** 2
      end

      Math.sqrt(sum / number_of_plots)
    end

    def standard_deviation_l(radius)
      sum = plots.inject(0) do |sum, plot|
        (plot.stats.l_ts[radius] - stats.mean.l_ts[radius]) ** 2
      end

      Math.sqrt(sum / number_of_plots)
    end

    def number_of_plots
      plots.size
    end

    def average_k(radius)
      sum = plots.inject(0) do |sum, plot|
        plot.stats.k_ts[radius]
      end

      sum / number_of_plots
    end

    def average_l(radius)
      sum = plots.inject(0) do |sum, plot|
        plot.stats.l_ts[radius]
      end

      sum / number_of_plots
    end
  end
end