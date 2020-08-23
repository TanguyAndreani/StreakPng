require 'chunky_png'
require 'csv'

levelcolors = [
    {
        minCommits: 0,
        color: '#ebedf0',
    },
    {
        minCommits: 1,
        color: '#c6e48b',
    },
    {
        minCommits: 9,
        color: '#7bc96f',
    },
    {
        minCommits: 17,
        color: '#239a3b',
    },
    {
        minCommits: 26,
        color: '#196127',
    },
]

bydate = Hash.new { Array.new }

maxdate = Date.today

mindate = maxdate.prev_year
while mindate.cwday != 1
  mindate = mindate.prev_day
end

CSV.foreach('sample_streak.csv') do |row|
  date = Date.strptime(row[-1],"%Y.%m.%d").to_s

  bydate[date] = bydate[date] << row[0..-2]
end

def draw_square(png, x, y, w, h, color)
  x.upto(x+w) { |x|
    y.upto(y+h) { |y|
      png[x,y] = ChunkyPNG::Color.from_hex(color)
    }
  }
end

margin = 4
x = margin
y = margin
w = 10
h = 10

png = ChunkyPNG::Image.new((w + margin) * 60, (h + margin) * 8, ChunkyPNG::Color::TRANSPARENT)

mindate.upto(maxdate) { |date|
  key = date.to_s

  daycount = bydate[key].length
  p bydate[key], key, date, mindate, maxdate

  color = nil

  levelcolors.sort{|a,b|a[:minCommits] <=> b[:minCommits]}.reverse.each { |min|
    if daycount >= min[:minCommits]
      color = min[:color]
      break
    end
  }

  p daycount

  draw_square png, x, y, w, h, color

  y += margin + h

  if date.cwday == 7
    y = margin
    x += margin + w
  end
}

png.save('filename.png', :interlace => true)
