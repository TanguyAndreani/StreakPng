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
      @imageClass = args[:imageClass] || ::StreakPng::ChunkyPNGBackend
      @streakData = args[:streakData] || (StreakData.new.tap {|d| d.add StreakChart.dateClass.today, "Sample task"})

      @conf = args
      defaultConf.each_key { |key|
        @conf[key] ||= defaultConf[key]
      }

      self
    end

    def draw **args, &block
      @conf.merge(args) { |key, _, _|
        @conf[key] = args[key] if args[key]
      }

      computeDateInterval

      image = @imageClass.new(
        (@conf[:width] + @conf[:margin]) * weeks() + @conf[:margin],
        (@conf[:height] + @conf[:margin]) * 7 + @conf[:margin]
      )

      drawChart image, block

      image
    end

    private

    def weeks
      if @conf[:fullYearWidth]
        52
      else
        ((@conf[:maxDate] - @conf[:minDate]).to_f / 7.0).ceil + ((@conf[:maxDate].cwday < 7) ? 1 : 0)
      end
    end

    def computeDateInterval
      @conf[:maxDate] ||= StreakChart.dateClass.today
      if @conf[:minDate].nil?
        @conf[:minDate] = @conf[:maxDate].prev_year(@conf[:yr]).prev_month(@conf[:m]).prev_day(@conf[:d])
        while @conf[:startOnMonday] && @conf[:minDate].cwday != 1
          @conf[:minDate] = @conf[:minDate].next_day
        end
      end
    end

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
        maxDate: nil,
        startOnMonday: true,
        fullYearWidth: false,
      }
    end

    def drawChart image, block
      x = @conf[:margin]

      @conf[:minDate].upto(@conf[:maxDate]) { |date|
        y = @conf[:margin]*date.cwday + @conf[:height]*(date.cwday-1)

        color = @conf[:levelColors].reduce({ treshold: -1, color: '#000' }) { |acc, lvl|
          if @conf[:streakData].fetch_count(date, &block) >= lvl[:treshold] && lvl[:treshold] >= acc[:treshold]
            lvl
          else
            acc
          end
        }[:color]

        image.drawSquare x, y, @conf[:width], @conf[:height], @conf[:border], color

        if date.cwday == 7
          x += @conf[:margin] + @conf[:width]
        end
      }
    end
  end
end
