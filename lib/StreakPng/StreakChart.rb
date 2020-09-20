require 'chunky_png'

module StreakPng
  class StreakChart
    DEFAULT_LEVEL_COLORS = [
      # credit @byliuyang <https://github.com/byliuyang/github-stats>
      { treshold: 0, color: '#ebedf0' },
      { treshold: 1, color: '#c6e48b' },
      { treshold: 9, color: '#7bc96f' },
      { treshold: 17, color: '#239a3b' },
      { treshold: 26, color: '#196127' }
    ]

    def self.dateClass
      @dateClass || Date
    end

    def initialize **args
      @png = nil

      @conf = args
      defaultConf.each_key { |key|
        @conf[key] ||= defaultConf[key]
      }

      self
    end

    def save filename
      @png.save(filename, :interlace => true) if @png
      self
    end

    def draw **args, &block
      @conf.merge(args) { |key, _, _| @conf[key] = args[key] if args[key] }

      if @conf[:minDate].nil?
        @conf[:minDate] = @conf[:maxDate].prev_year(@conf[:yr]).prev_month(@conf[:m]).prev_day(@conf[:d])
        while @conf[:startOnMonday] && @conf[:minDate].cwday != 1
          @conf[:minDate] = @conf[:minDate].next_day
        end
      end

      if @conf[:fullYearWidth]
        weeks = 52
      else
        weeks = ((@conf[:maxDate] - @conf[:minDate]).to_f / 7.0).ceil + ((@conf[:maxDate].cwday < 7) ? 1 : 0)
      end
      @png = ChunkyPNG::Image.new((@conf[:width] + @conf[:margin]) * weeks + @conf[:margin], (@conf[:height] + @conf[:margin]) * 7 + @conf[:margin], ChunkyPNG::Color::TRANSPARENT)

      x = @conf[:margin]

      @conf[:minDate].upto(@conf[:maxDate]) { |date|
        y = @conf[:margin]*date.cwday + @conf[:height]*(date.cwday-1)

        drawSquare x, y, @conf[:levelColors].reduce({ treshold: -1, color: '#000' }) { |acc, lvl|
          if @conf[:streakData].fetch_count(date, &block) >= lvl[:treshold] && lvl[:treshold] >= acc[:treshold]
            lvl
          else
            acc
          end
        }[:color]

        if date.cwday == 7
          x += @conf[:margin] + @conf[:width]
        end
      }

      self
    end

    private

    def defaultConf
      {
        margin: 6,
        width: 13,
        height: 13,
        border: 1,
        levelColors: DEFAULT_LEVEL_COLORS,
        yr: 0,
        m: 6,
        d: 0,
        minDate: nil,
        maxDate: StreakChart.dateClass.today,
        startOnMonday: true,
        fullYearWidth: false,
        streakData: StreakData.new.tap { |d|
          d.add StreakChart.dateClass.today, "Sample task"
        }
      }
    end

    def drawSquare(start_x, start_y, color)
      chunky_color = ChunkyPNG::Color.from_hex color
      start_x.upto(start_x+@conf[:width]) { |x|
        start_y.upto(start_y+@conf[:height]) { |y|
          if x - start_x < @conf[:border] || x - start_x > @conf[:width] - @conf[:border] || y - start_y < @conf[:border] || y - start_y > @conf[:height] - @conf[:border]
            @png[x,y] = chunky_color
          else
            @png[x,y] = ChunkyPNG::Color.fade(chunky_color, 200)
          end
        }
      }
    end
  end
end
