require_relative '../../lib/longest_word.rb'

class WordsController < ApplicationController

  def game
    @grid = generate_grid(params[:grid_size].to_i).join('  ')
    @start_time = Time.now
  end

  def score
    end_time = Time.now
    grid = params[:grid].split('  ')
    start_time = Time.parse(params[:start_time])
    attempt = params[:user_answer]
    # byebug
    @result = run_game(attempt, grid, start_time, end_time)

  end
end
