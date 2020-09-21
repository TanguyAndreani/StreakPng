Gem::Specification.new do |s|
  s.name        = 'StreakPng'
  s.version     = '0.1.0'
  s.date        = '2020-08-23'
  s.summary     = "Visualizing streaks"
  s.description = "Generate streaks charts as PNG from custom data. Like on a Github profile."
  s.authors     = ["Tanguy Andreani"]
  s.email       = 'tanguy.andreani@tuta.io'
  s.files       = ["lib/StreakPng.rb", "lib/StreakPng/StreakPng.rb"]
  s.executables = ['streak_from_csv']
  s.homepage    = 'https://github.com/TanguyAndreani/StreakPng'
  s.license       = 'MIT'
  s.add_dependency "chunky_png", "~> 1.3"
  s.add_dependency "victor", "~> 0.3.2"
end
