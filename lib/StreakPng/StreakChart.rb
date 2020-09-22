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

    def initialize backend: ChunkyPNGBackend, streakData: nil, conf: nil
      @backend = backend
      @streakData = streakData

      # pull from defaultConf if the value wasn't provided
      @conf = conf || {}
      defaultConf.each_key { |key|
        @conf[key] ||= defaultConf[key]
      }

      self
    end

    def draw backend: nil, conf: nil, &block
      @backend = backend || @backend

      if conf
        # If a value was provided replace the old with conf[key]
        @conf.merge(conf) { |key, _, _|
          @conf[key] = conf[key] if conf[key]
        }
      end

      computeDateInterval

      image = @backend.new(
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

        level = @conf[:levelColors].reduce({ treshold: -1, color: '#000' }) { |acc, lvl|
          if @streakData.fetch_count(date, &block) >= lvl[:treshold] && lvl[:treshold] >= acc[:treshold]
            lvl
          else
            acc
          end
        }

        image.drawSquare x, y, @conf[:width], @conf[:height], @conf[:border], level[:color]

        if date.cwday == 7
          x += @conf[:margin] + @conf[:width]
        end
      }
    end
  end
end
