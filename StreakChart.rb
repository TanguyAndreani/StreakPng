require 'chunky_png'
require 'date'
require 'csv'

module Streak
  DEFAULT_LEVEL_COLORS = [
    # credit @byliuyang <https://github.com/byliuyang/github-stats>
    { minCommits: 0, color: '#ebedf0' },
    { minCommits: 1, color: '#c6e48b' },
    { minCommits: 9, color: '#7bc96f' },
    { minCommits: 17, color: '#239a3b' },
    { minCommits: 26, color: '#196127' }
  ]

  class StreakChart
    def initialize margin, width, height, levelcolors: DEFAULT_LEVEL_COLORS, streakdata: nil
      @levelcolors = levelcolors
      if streakdata.nil?
        @streakdata = StreakData.new
        @streakdata.add Date.today, "Today's task!"
      else
        @streakdata = streakdata
      end
      @margin = margin
      @width = width
      @height = height
      @png = ChunkyPNG::Image.new((@width + @margin) * 53 + @margin, (@height + @margin) * 7 + @margin, ChunkyPNG::Color::TRANSPARENT)
      self
    end

    def save filename
      @png.save(filename, :interlace => true)
      self
    end

    def generate
      maxdate = Date.today

      mindate = maxdate.prev_year
      while mindate.cwday != 1
        mindate = mindate.prev_day
      end

      x, y = @margin, @margin

      mindate.upto(maxdate) { |date|
        draw_square x, y, @levelcolors.reduce({ minCommits: -1, color: '#000' }) { |acc, lvl|
          if @streakdata.fetch_count(date) >= lvl[:minCommits] && lvl[:minCommits] >= acc[:minCommits]
            lvl
          else
            acc
          end
        }[:color]

        y += @margin + @height

        if date.cwday == 7
          y = @margin
          x += @margin + @width
        end
      }

      self
    end

    private

    def draw_square(x, y, color)
      x.upto(x+@width) { |x|
        y.upto(y+@height) { |y|
          @png[x,y] = ChunkyPNG::Color.from_hex color
        }
      }
    end
  end

  class StreakData
    def initialize
      @bydate = Hash.new { Array.new }
    end

    def add date, *tags
      if date.class != Date
        STDERR.puts "The date should be an instance of the Date class!"
        return
      end
      @bydate[date.to_s] = @bydate[date.to_s] << tags
    end

    def fetch_count date
      @bydate[date.to_s].length
    end
  end
end
