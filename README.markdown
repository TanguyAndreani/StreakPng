# StreakPng

![](filename.png)

## As a RubyGem

```ruby
gem "StreakPng", :git => "https://github.com/TanguyAndreani/StreakPng.git"
```

## Run the example

```shell
gem install specific_install
gem specific_install https://github.com/TanguyAndreani/StreakPng.git

cat > my_streak.csv <<EOF
sport,20 pushups,2020.08.12
sport,20 min running,2020.08.12
code,my super project,go,2020.08.01
EOF

streak_from_csv my_streak.csv my_streak.png

open my_streak.png
```

Or go read [generate_streak.rb](/generate_streak.rb) to see how you can generate charts with your own data.

If you're just going to use the `generate_streak.rb` script, just know that you can put whatever in your csvs as long as the last field is the date.

## Features

### Filters

You can pass a block to the StreakChart#generate method. Here the `tags` binding would hold every field of the csv except the date.

```ruby
StreakChart
.new(...)
.generate { |tags| tags[0] == 'cryptopals' }
.save(...)
```

### Interval

You can override today's date by passing a `maxdate: customdate` argument.

You can change the default interval, which is of a year, using three arguments. For example, here is how you generate a three month streak chart:

```ruby
StreakChart
.new(...)
.generate(y: 0, m: 3)
.save(...)
```

![](three_months.png)
