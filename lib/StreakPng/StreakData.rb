require 'date'

module StreakPng
  class StreakData < StreakCommon
    def initialize
      @data = Hash.new { Array.new }
    end

    def add date, *tags
      @data[date.to_s] = @data[date.to_s] << tags
    end

    def fetch_count date, &block
      if !block_given?
        @data[date.to_s].length
      else
        @data[date.to_s].count &block
      end
    end
  end
end
