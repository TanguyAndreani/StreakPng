require 'chunky_png'
require 'date'

module StreakPng
  DEFAULT_LEVEL_COLORS = [
    # credit @byliuyang <https://github.com/byliuyang/github-stats>
    { treshold: 0, color: '#ebedf0' },
    { treshold: 1, color: '#c6e48b' },
    { treshold: 9, color: '#7bc96f' },
    { treshold: 17, color: '#239a3b' },
    { treshold: 26, color: '#196127' }
  ]

  class StreakChart
    def initialize margin: 6, width: 13, height: 13, border: 1, levelColors: DEFAULT_LEVEL_COLORS, streakData: nil
      @levelColors = levelColors
      if streakData.nil?
        @streakData = streakData.new
        @streakData.add Date.today, "Today's task!"
      else
        @streakData = streakData
      end
      @margin = margin
      @width = width
      @height = height
      @border = border
      @png = nil
      self
    end

    def save filename
      if @png
        @png.save(filename, :interlace => true)
      end
      self
    end

    def draw yr: 0, m: 6, d: 0, minDate: nil, maxDate: nil, startOnMonday: true, fullYearWidth: false, &block
      maxDate ||= Date.today

      if minDate.nil?
        minDate = maxDate.prev_year(yr).prev_month(m).prev_day(d)
        while startOnMonday && minDate.cwday != 1
          minDate = minDate.next_day
        end
      end

      if fullYearWidth
        weeks = 52
      else
        weeks = ((maxDate - minDate).to_f / 7.0).ceil + ((maxDate.cwday < 7) ? 1 : 0)
      end
      @png = ChunkyPNG::Image.new((@width + @margin) * weeks + @margin, (@height + @margin) * 7 + @margin, ChunkyPNG::Color::TRANSPARENT)

      x = @margin

      minDate.upto(maxDate) { |date|
        y = @margin*date.cwday + @height*(date.cwday-1)

        drawSquare x, y, @levelColors.reduce({ treshold: -1, color: '#000' }) { |acc, lvl|
          if @streakData.fetch_count(date, &block) >= lvl[:treshold] && lvl[:treshold] >= acc[:treshold]
            lvl
          else
            acc
          end
        }[:color]

        if date.cwday == 7
          x += @margin + @width
        end
      }

      self
    end

    private

    def drawSquare(start_x, start_y, color)
      chunky_color = ChunkyPNG::Color.from_hex color
      start_x.upto(start_x+@width) { |x|
        start_y.upto(start_y+@height) { |y|
          if x - start_x < @border || x - start_x > @width - @border || y - start_y < @border || y - start_y > @height - @border
            @png[x,y] = chunky_color
          else
            @png[x,y] = ChunkyPNG::Color.fade(chunky_color, 200)
          end
        }
      }
    end
  end

  class StreakData
    def initialize
      @data = Hash.new { Array.new }
    end

    def add date, *tags
      if date.nil?
        date = Date.today
      end
      if date.class != Date
        STDERR.puts "The date should be an instance of the Date class!"
        return
      end
      @data[date.to_s] = @data[date.to_s] << tags
    end

    def fetch_count date, &block
      if !block_given?
        @data[date.to_s].length
      else
        @data[date.to_s].count &block
      end
    end
  end
end
