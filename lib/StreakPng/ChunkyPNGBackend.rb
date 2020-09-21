require 'chunky_png'

module StreakPng
  class ChunkyPNGBackend < ChunkyPNG::Image
    def initialize width, height
      super(width, height, ChunkyPNG::Color::TRANSPARENT)
    end

    def drawSquare start_x, start_y, width, height, border, hex_color
      chunky_color = ChunkyPNG::Color.from_hex hex_color
      start_x.upto(start_x+width) { |x|
        start_y.upto(start_y+height) { |y|
          if x - start_x < border || x - start_x > width - border || y - start_y < border || y - start_y > height - border
            self[x,y] = chunky_color
          else
            self[x,y] = ChunkyPNG::Color.fade(chunky_color, 200)
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
