class PlotStatistics
  class Output
    attr_accessor :clam_plot, :monte_carlo

    def initialize(params={})
      @clam_plot = params[:clam_plot]
      @monte_carlo = params[:monte_carlo]
    end

    def write_to_file(filename)
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
  end
end