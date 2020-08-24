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
art,city landscape,2020.06.05
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

#<!--
File.open('examples/examples.markdown', 'w') do |aFile|
  aFile.puts File.read(__FILE__).gsub(/^#/, '')
end
#-->
