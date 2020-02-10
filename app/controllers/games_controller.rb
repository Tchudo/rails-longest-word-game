require 'open-uri'
require 'json'

# Top level documentation
class GamesController < ApplicationController
  def new
    @letters = (0..8).map { ('a'..'z').to_a[rand(26)] }
  end

  def score

    @attempt = params[:word]
    @grid = params[:letters]

    value = match(@attempt, @grid)

    result(value, @attempt)
  end


  private

  def match(attempt, grid)
    new_att = {}
    new_grid = {}
    value = true

    grid.split("\"").each { |letter| new_grid[letter].nil? ? new_grid[letter] = 1 : new_grid[letter] += 1 }
    attempt.downcase.split('').each { |letter| new_att[letter].nil? ? new_att[letter] = 1 : new_att[letter] += 1 }
    new_att.each_key do |key|
      if new_grid[key].nil? || new_grid[key] < new_att[key]
        value = false
        break
      end
    end
    return value
  end

  def result(value, attempt)
    if value
      result = "value true"
      url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
      url
      word_serialized = open(url).read
      api = JSON.parse(word_serialized)

      if api["found"]
        result = "Congratulations, #{attempt} is a good word"
      else
        result = "Sorry but '#{attempt}' is not an English word"
      end
    else
      result = "Your word '#{attempt}' does not match with given letters"
    end
    return @result = result
  end


end
