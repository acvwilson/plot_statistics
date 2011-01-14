class PlotStatistics
  class Output
    attr_accessor :clam_plot, :monte_carlo

    def initialize(params={})
      @clam_plot = params[:clam_plot]
      @monte_carlo = params[:monte_carlo]
    end

    def to_univariate_file(filename)
      FasterCSV.open(filename, 'w') do |csv|
        csv << ['Radius', 'K(t)', 'L(t)', 'Mean K(t)', 'Mean L(t)', 'Upper K(t)', 'Lower K(t)', 'Upper L(t)', 'Lower L(t)']

        (0...ClamPlot::MAX_RADIUS).each do |position|
          radius = position + 1
          csv << [
            radius,
            clam_plot.stats.k_ts[position],               clam_plot.stats.l_ts[position],
            monte_carlo.stats.mean.k_ts[position],        monte_carlo.stats.mean.l_ts[position],
            monte_carlo.stats.upper_limit.k_ts[position], monte_carlo.stats.lower_limit.k_ts[position],
            monte_carlo.stats.upper_limit.l_ts[position], monte_carlo.stats.lower_limit.l_ts[position]
          ]
        end
      end
    end

    def to_bivariate_file(filename)
      FasterCSV.open(filename, 'w') do |csv|
        csv << [
          'Radius', 'Live K(t)', 'Dead K(t)', 'L(t)',
          'Mean Live K(t)', 'Mean Dead K(t)', 'Mean L(t)', 'Upper Live K(t)', 'Lower Live K(t)',
          'Upper Dead K(t)', 'Lower Dead K(t)', 'Upper L(t)', 'Lower L(t)'
        ]

        (0...ClamPlot::MAX_RADIUS).each do |position|
          radius = position + 1
          csv << [
            radius,
            clam_plot.stats.k_ts[position],                    clam_plot.stats.dead_k_ts[position],
            clam_plot.stats.l_ts[position],
            monte_carlo.stats.mean.k_ts[position],             monte_carlo.stats.mean.dead_k_ts[position],
            monte_carlo.stats.mean.l_ts[position],
            monte_carlo.stats.upper_limit.k_ts[position],      monte_carlo.stats.lower_limit.k_ts[position],
            monte_carlo.stats.upper_limit.dead_k_ts[position], monte_carlo.stats.lower_limit.dead_k_ts[position],
            monte_carlo.stats.upper_limit.l_ts[position],      monte_carlo.stats.lower_limit.l_ts[position]
          ]
        end
      end
    end
  end
end
