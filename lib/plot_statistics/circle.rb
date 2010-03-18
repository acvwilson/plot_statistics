class PlotStatistics
  class Circle
    attr_accessor :clam, :radius, :distance_from_bound, :proportion_inside_plot

    def initialize(params={})
      @clam = params[:clam]
      @radius = params[:radius].to_f
      @distance_from_bound = find_distance_from_bounds
      @proportion_inside_plot = estimate_proportion_inside_plot
    end

    def estimate_proportion_inside_plot
      distance_from_bound.reject! {|distance| distance > radius}
      case distance_from_bound.size
      when 1
        proportion_for_one_side_out
      when 2
        proportion_for_two_sides_out
      else
        1.0
      end
    end

    def proportion_for_one_side_out
      1 - Math.acos( distance_from_bound.pop / radius ) / Math::PI
    end

    def proportion_for_two_sides_out
      if corners_outside_radius.size == 3
        1 - ( Math.acos( distance_from_bound.pop / radius ) + Math.acos( distance_from_bound.pop / radius ) + Math::PI / 2 ) / (Math::PI * 2)
      else
        1 - ( 2 * Math.acos( distance_from_bound.pop / radius ) + 2 * Math.acos( distance_from_bound.pop / radius ) ) / (Math::PI * 2)
      end
    end

    def find_distance_from_bounds
      [
        (clam.y - 100).abs, # distance from top
        (clam.x - 100).abs, # distance from right
        clam.x,             # distance from left
        clam.y              # distance from bottom
      ]
    end

    def corners_outside_radius
      ClamPlot::PLOT_CORNERS.map do |corner|
        distance = Math.sqrt((corner.first - clam.x) ** 2 + (corner.last - clam.y) ** 2)
        next if distance < radius
        distance
      end.compact
    end
  end
end