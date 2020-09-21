require 'chunky_png'

module StreakPng
  class ChunkyPNGBackend < ChunkyPNG::Image
    include ::StreakPng::ColorHelper

    def initialize width, height
      super(width, height, ChunkyPNG::Color::TRANSPARENT)
    end

    def drawSquare start_x, start_y, width, height, border, hex_color
      @defaultColor ||= Hash.new
      @fadedColor ||= Hash.new

      @defaultColor[hex_color] ||= ChunkyPNG::Color.from_hex hex_color
      @fadedColor[hex_color] ||= ChunkyPNG::Color.from_hex fade_hex(hex_color, -0.1)

      start_x.upto(start_x+width) { |x|
        start_y.upto(start_y+height) { |y|
          if x - start_x < border || x - start_x > width - border || y - start_y < border || y - start_y > height - border
            self[x,y] = @fadedColor[hex_color]
          else
            self[x,y] = @defaultColor[hex_color]
          end
        }
      }
    end

    def save filename
      $stderr.puts "Saving to #{filename}"
      super(filename, :interlace => true)
    end
  end
end
