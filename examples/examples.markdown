# Examples

<!--
require 'csv'

require 'StreakPng'
include StreakPng

StreakChart.instance_eval {
  @dateClass = Class.new(Date) do
    def self.today
      new 2020, 8, 24
    end
  end
}

text = <<~EOF
sport,20 pushups,2020.08.12
sport,20 min running,2020.08.12
code,my super project,go,2020.08.01
art,portrait of me,2020.06.05
art,portrait of my dog,2020.06.05
art,garden painting,2020.06.05
art,city landscape 1,2020.06.05
art,city landscape 2,2020.06.05
art,city landscape 3,2020.06.05
art,city landscape 4,2020.06.05
art,city landscape 5,2020.06.05
art,city landscape 6,2020.06.05
EOF

data = StreakData.new

CSV.new(text).each do |row|
  data.add Date.strptime(row[-1],"%Y.%m.%d"), *row[0..-2]
end

-->

## Basic example

![](example1.png)

```ruby
StreakChart
.new(streakData: data)
.draw
.save('examples/example1.png')
```

## Changing sizes and date interval

![](example2.png)

```ruby
StreakChart
# 8x8 squares with 2px borders
.new(streakData: data, width: 8, height: 8, border: 2, margin: 3)
# 1 month up to now
.draw(yr: 0, m: 1)
.save('examples/example2.png')
```

## Overriding dates

![](example3.png)

```ruby
StreakChart
.new(streakData: data)
# force full year
.draw(minDate: Date.new(2020, 1, 1), maxDate: Date.new(2020, 12, 31))
.save('examples/example3.png')
```

## Changing colors

![](example4.png)

```ruby
StreakChart
# custom colors
.new(streakData: data, levelColors: [
  { treshold: 0, color: '#ebedf0' },
  { treshold: 1, color: '#faccff' },
  { treshold: 9, color: '#dcb0ff' },
  { treshold: 17, color: '#be93fd' },
  { treshold: 26, color: '#a178df' }
])
.draw
.save('examples/example4.png')
```

## Filtering entries

![](example5.png)

```ruby
StreakChart
.new(streakData: data)
.draw { |tags|
  # p tags
  tags.include? 'art'
}
.save('examples/example5.png')
```

## Always 52-weeks wide

![](example6.png)

```ruby
StreakChart
.new(streakData: data)
.draw(fullYearWidth: true)
.save('examples/example6.png')
```

## Custom formats (ex: SVG)

![](example7.svg)

```ruby
StreakChart
.new(streakData: data, imageClass: VictorBackend)
.draw
.save('examples/example7.svg')
```

You can take a look at [VictorBackend.rb](/lib/StreakPng/VictorBackend.rb) for reference.
Your custom format is basically a class which responds to those three methods.

<!--
File.open('examples/examples.markdown', 'w') do |aFile|
  aFile.puts File.read(__FILE__).gsub(/^#/, '')
end
-->
