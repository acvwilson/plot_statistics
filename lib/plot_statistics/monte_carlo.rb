class PlotStatistics
  class MonteCarlo
    attr_accessor :plots, :stats

    def initialize(params={})
      @plots = params[:plots]
    end

    def self.new_univariate(number_of_clams, number_of_plots=500.0)
      plots = (1..number_of_plots).map { ClamPlot.create_random(number_of_clams).univariate_analysis }
      new(:plots => plots)
    end

    def self.new_bivariate(actual_plot, number_of_plots=500.0)
      plots = (1..number_of_plots).map { ClamPlot.create_random_from(actual_plot).bivariate_analysis }
      new(:plots => plots)
    end

    def bivariate_analysis
      self.stats = OpenStruct.new(:mean        => OpenStruct.new(:k_ts => [], :dead_k_ts => [], :l_ts => []),
                                  :upper_limit => OpenStruct.new(:k_ts => [], :dead_k_ts => [], :l_ts => []),
                                  :lower_limit => OpenStruct.new(:k_ts => [], :dead_k_ts => [], :l_ts => []))
      calculate_means([:k_ts, :dead_k_ts, :l_ts])
      calculate_limits([:k_ts, :dead_k_ts, :l_ts])
      self
    end

    def univariate_analysis
      self.stats = OpenStruct.new(:mean        => OpenStruct.new(:k_ts => [], :l_ts => []),
                                  :upper_limit => OpenStruct.new(:k_ts => [], :l_ts => []),
                                  :lower_limit => OpenStruct.new(:k_ts => [], :l_ts => []))
      calculate_means([:k_ts, :l_ts])
      calculate_limits([:k_ts, :l_ts])
      self
    end

    def calculate_means(means_for)
      (0...ClamPlot::MAX_RADIUS).each do |radius|
        means_for.each do |stat|
          stats.mean.send(stat) << average_stat(radius, stat)
        end
      end
    end

    def calculate_limits(limits_for)
      (0...ClamPlot::MAX_RADIUS).each do |radius|
        limits_for.each do |stat|
          threshold = standard_deviation_stat(radius, stat) * 2.0

          stats.upper_limit.send(stat) << (stats.mean.send(stat)[radius] + threshold)
          stats.lower_limit.send(stat) << (stats.mean.send(stat)[radius] - threshold)
        end
      end
    end

    def standard_deviation_stat(radius, stat)
      sum = plots.inject(0.0) do |sum, plot|
        (plot.stats.send(stat)[radius] - stats.mean.send(stat)[radius]) ** 2
      end

      Math.sqrt(sum / number_of_plots)
    end

    def average_stat(radius, stat)
      sum = plots.inject(0.0) do |sum, plot|
        plot.stats.send(stat)[radius]
      end

      sum / number_of_plots
    end

    def number_of_plots
      plots.size
    end
  end
end