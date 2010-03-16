class PlotStatistics
  class Circle
    attr_accessor :clam, :radius, :sample_points, :proportion_inside_plot

    DEGREES = [15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180, 195, 210, 225, 240, 255, 270, 285, 300, 315, 330, 345, 360]
    RADIANS_TO_DEGREES = 360.0 / (2.0 * Math::PI)

    def initialize(params={})
      @clam = params[:clam]
      @radius = params[:radius]
      @sample_points = { :out_of_bounds => 0.0, :in_bounds => 0.0 }
      @proportion_inside_plot = out_of_bounds? ? estimate_proportion_inside_plot : 1.0
    end

    def create_samples
      sample_circles = radius * 2
      sample_radius = 0.5
      sample_circles.times do
        DEGREES.each do |degrees|
          x = clam.x + sample_radius * Math.cos(degrees / RADIANS_TO_DEGREES)
          y = clam.y + sample_radius * Math.sin(degrees / RADIANS_TO_DEGREES)

          if point_out_of_bounds?(x, y)
            sample_points[:out_of_bounds] += 1
          else
            sample_points[:in_bounds] += 1
          end
        end

        sample_radius += 0.5
      end
    end

    def estimate_proportion_inside_plot
      create_samples
      sample_points[:in_bounds] / (sample_points[:in_bounds] + sample_points[:out_of_bounds])
    end

    def point_out_of_bounds?(x, y)
      [x, y].each do |coordinate|
        return true unless coordinate > 0 && coordinate < 100
      end
      false
    end

    def out_of_bounds?
      right_out_of_bounds?  ||
      left_out_of_bounds?   ||
      top_out_of_bounds?    ||
      bottom_out_of_bounds?
    end

    def right_out_of_bounds?
      clam.x + radius > 100
    end

    def left_out_of_bounds?
      clam.x - radius < 0
    end

    def top_out_of_bounds?
      clam.y + radius > 100
    end

    def bottom_out_of_bounds?
      clam.y - radius < 0
    end


  end
end