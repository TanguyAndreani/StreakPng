require 'chunky_png'

module StreakPng
  class ChunkyPNGBackend < ChunkyPNG::Image
    include ::StreakPng::ColorHelper

    def initialize width, height
      super(width, height, ChunkyPNG::Color::TRANSPARENT)
    end

    def drawSquare start_x, start_y, width, height, border, hex_color
      @defaultColor ||= ChunkyPNG::Color.from_hex hex_color
      @fadedColor ||= ChunkyPNG::Color.from_hex fade_hex(hex_color, -0.2)
      start_x.upto(start_x+width) { |x|
        start_y.upto(start_y+height) { |y|
          if x - start_x < border || x - start_x > width - border || y - start_y < border || y - start_y > height - border
            self[x,y] = @defaultColor
          else
            self[x,y] = @fadedColor
          end
        }
      }
    end

    def save filename
      $stderr.puts "Saving to #{filename}"
      @image.save(filename, :interlace => true) if @image
    end
  end
end
