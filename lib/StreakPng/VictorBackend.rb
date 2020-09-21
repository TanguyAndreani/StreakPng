require 'victor'

module StreakPng
  class VictorBackend < Victor::SVG
    include ::StreakPng::ColorHelper

    def initialize width, height
      super width: width, height: height, style: {}
    end

    def drawSquare start_x, start_y, width, height, border, hex_color
      @fadedColor ||= Hash.new
      @fadedColor[hex_color] ||= fade_hex hex_color, -0.1

      rect(
        x: start_x,
        y: start_y,
        width: width,
        height: height,
        fill: hex_color,
        stroke_width: border,
        stroke: @fadedColor[hex_color]
      )
    end

    def save filename
      $stderr.puts "Saving to #{filename}"
      super filename
    end
  end
end
