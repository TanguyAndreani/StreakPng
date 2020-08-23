# StreakPng

![](filename.png)

```shell
${EDITOR} sample_streak.csv
ruby generate_streak.rb sample_streak.csv chart.png
open chart.png
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
