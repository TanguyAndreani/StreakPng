require 'chunky_png'
require 'date'

module StreakPng
  DEFAULT_LEVEL_COLORS = [
    # credit @byliuyang <https://github.com/byliuyang/github-stats>
    { minCommits: 0, color: '#ebedf0' },
    { minCommits: 1, color: '#c6e48b' },
    { minCommits: 9, color: '#7bc96f' },
    { minCommits: 17, color: '#239a3b' },
    { minCommits: 26, color: '#196127' }
  ]

  class StreakChart
    def initialize margin, width, height, border, levelcolors: DEFAULT_LEVEL_COLORS, streakdata: nil
      @levelcolors = levelcolors
      if streakdata.nil?
        @streakdata = StreakData.new
        @streakdata.add Date.today, "Today's task!"
      else
        if streakdata.class != StreakData
          STDERR.puts "streakdata should be an instance of StreakData or nil!"
          return
        end
        @streakdata = streakdata
      end
      @margin = margin
      @width = width
      @height = height
      @border = border
      @png = nil
      @yr, @m, @d = -1, 0, 0
      self
    end

    def save filename
      @png.save(filename, :interlace => true)
      self
    end

    def generate yr: 0, m: 6, d: 0, maxdate: nil, start_on_monday: true, &block
      maxdate ||= Date.today

      mindate = maxdate.prev_year(yr).prev_month(m).prev_day(d)
      while start_on_monday && mindate.cwday != 1
        mindate = mindate.next_day
      end

      # we change the PNG's size only if we changed the interval
      if yr != @y || m != @m || d != @d
        @yr, @m, @d = yr, m, d
        weeks = ((maxdate - mindate).to_f / 7.0).ceil + ((maxdate.cwday < 7) ? 1 : 0)
        @png = ChunkyPNG::Image.new((@width + @margin) * weeks + @margin, (@height + @margin) * 7 + @margin, ChunkyPNG::Color::TRANSPARENT)
      end

      x = @margin

      mindate.upto(maxdate) { |date|
        y = @margin*date.cwday + @height*(date.cwday-1)

        draw_square x, y, @levelcolors.reduce({ minCommits: -1, color: '#000' }) { |acc, lvl|
          if @streakdata.fetch_count(date, &block) >= lvl[:minCommits] && lvl[:minCommits] >= acc[:minCommits]
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

    def draw_square(start_x, start_y, color)
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
      @bydate = Hash.new { Array.new }
    end

    def add date, *tags
      if date.nil?
        date = Date.today
      end
      if date.class != Date
        STDERR.puts "The date should be an instance of the Date class!"
        return
      end
      @bydate[date.to_s] = @bydate[date.to_s] << tags
    end

    def fetch_count date, &block
      if !block_given?
        @bydate[date.to_s].length
      else
        @bydate[date.to_s].count &block
      end
    end
  end
end
