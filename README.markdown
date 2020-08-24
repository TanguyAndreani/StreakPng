# StreakPng

![](default_chart.png)

## As a RubyGem

```ruby
gem "StreakPng", :git => "https://github.com/TanguyAndreani/StreakPng.git"
```

## Run the example

```shell
gem install specific_install
gem specific_install https://github.com/TanguyAndreani/StreakPng.git

streak_from_csv -- output.png <<EOF
sport,20 pushups,2020.08.12
sport,20 min running,2020.08.12
code,my super project,go,2020.08.01
EOF

open output.png
```

Or go read [streak_from_csv](/bin/streak_from_csv) to see how you can generate charts with your own data.

If you're just going to use the executable, just know that you can put whatever in your csvs as long as the last field is the date.

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
.generate(yr: 0, m: 3)
.save(...)
```

![](three_months.png)
