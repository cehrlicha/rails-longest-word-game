require 'open-uri'
require 'json'

def generate_grid(grid_size)
  # TODO: generate random grid of letters
  arr = ('A'..'Z').to_a.sample(grid_size)
  Array.new(grid_size) { arr.sample }
end

def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  result = { time: end_time - start_time, translation: "", score: 0, message: "not in the grid" }
  if english_word?(attempt)
    if word_in_grid?(attempt, grid)
      result[:score] = score_calc(attempt, result[:time])
      result[:message] = "well done"
      result[:translation] = translation(attempt)
    else
      result[:message] = "not in the grid"
    end
  else
    result[:message] = "not an english word"
    result[:translation] = nil
  end
  return result
end

def english_word?(attempt)
  words = File.read('/usr/share/dict/words').upcase.split("\n")
  words.include?(attempt.upcase)
end

def word_in_grid?(attempt, grid)
  attempt = attempt.upcase.split("")
  overlap = (attempt & grid).flat_map { |n| [n] * [attempt.count(n), grid.count(n)].min }
  overlap == attempt
end

def score_calc(attempt, time) # attempt, time needed, correct word true or false
  time > 60.0 ? 0 : attempt.split("").count * (1.0 - time / 60.0)
end

def translation(attempt)
  api = "72d6cd5e-0ecd-4546-b692-0a8980eefa74"
  url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{api}&input=#{attempt}"
  user_serialized = open(url).read
  user = JSON.parse(user_serialized)
  user["outputs"][0]["output"]
end

