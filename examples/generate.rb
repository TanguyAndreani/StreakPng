## Examples

#<!--
require 'csv'

require 'StreakPng'
include StreakPng

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

add_data = proc do |row|
  data.add Date.strptime(row[-1],"%Y.%m.%d"), *row[0..-2]
end

CSV.new(text).each &add_data
#-->

#```ruby
StreakChart
.new(streakdata: data)
.generate
.save('examples/example1.png')
#```

#![](example1.png)

#```ruby
StreakChart
## 8x8 squares with 2px borders
.new(streakdata: data, width: 8, height: 8, border: 2, margin: 3)
## 1 month up to now
.generate(yr: 0, m: 1)
.save('examples/example2.png')
#```

#![](example2.png)

#```ruby
StreakChart
.new(streakdata: data)
## force full year
.generate(mindate: Date.new(2020, 1, 1), maxdate: Date.new(2020, 12, 31))
.save('examples/example3.png')
#```

#![](example3.png)

#```ruby
StreakChart
## custom colors
.new(streakdata: data, levelcolors: [
  { minCommits: 0, color: '#ebedf0' },
  { minCommits: 1, color: '#faccff' },
  { minCommits: 9, color: '#dcb0ff' },
  { minCommits: 17, color: '#be93fd' },
  { minCommits: 26, color: '#a178df' }
])
.generate
.save('examples/example4.png')
#```

#![](example4.png)

#<!--
File.open('examples/examples.markdown', 'w') do |aFile|
  aFile.puts File.read(__FILE__).gsub(/^#/, '')
end
#-->
