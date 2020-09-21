require 'chunky_png'

module StreakPng
  module ColorHelper
    private def from_hex color
      string = (color.class == String) ? color.gsub(/^#/, '') : "%.6x" % color.gsub(/^#/, '')
      {
        r: string[0..1].hex,
        g: string[2..3].hex,
        b: string[4..5].hex
      }
    end

    private def to_hex rgb
      "#%.2x%.2x%.2x" % rgb.values
    end

    private def max a, b
      a > b ? a : b
    end

    private def min a, b
      a < b ? a : b
    end

    public def fade_hex s, n
      rgb = from_hex s
      rgb.each_key { |k|
        v = rgb[k]
        rgb[k] = min(max(0, v + v * n), 255).round
      }
      to_hex rgb
    end
  end
end
