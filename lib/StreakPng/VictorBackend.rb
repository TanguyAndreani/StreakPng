require 'victor'

module StreakPng
  class VictorBackend < Victor::SVG
    def initialize width, height
      super width: width, height: height, style: {}
    end

    def drawSquare start_x, start_y, width, height, border, hex_color
      rect x: start_x, y: start_y, width: width, height: height, fill: hex_color
    end

    def save filename
      $stderr.puts "Saving to #{filename}"
      super filename
    end
  end
end
