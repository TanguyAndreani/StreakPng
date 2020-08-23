require 'chunky_png'
require 'csv'

require './lib/StreakPng'
include StreakPng

data = StreakData.new

CSV.foreach('sample_streak.csv') do |row|
  data.add Date.strptime(row[-1],"%Y.%m.%d"), row[0..-2]
end

StreakChart.new(4, 10, 10, streakdata: data).generate.save('filename.png')
