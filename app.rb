# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require_relative './lib/wordguesser_game'

# The WordGuesserApp class represents a Sinatra web application
# for playing a word guessing game.
class WordGuesserApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  before do
    @game = session[:game] || WordGuesserGame.new('')
  end

  after do
    session[:game] = @game
  end
  # h
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end

  get '/new' do
    erb :new
  end

  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || WordGuesserGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = WordGuesserGame.new(word)
    redirect '/show'
  end

  # Use existing methods in WordGuesserGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    ### YOUR CODE HERE ###
    letter = params[:guess]
    begin
      flash[:message] = 'You have already used that letter.' unless @game.guess(letter[0])
    rescue ArgumentError
      flash[:message] = 'Invalid guess.'
    end
    redirect '/show'
  end

  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in WordGuesserGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    ### YOUR CODE HERE ###
    game_status = @game.check_win_or_lose
    if game_status == :win
      redirect '/win'
    elsif game_status == :lose
      redirect '/lose'
    else
      erb :show
    end
  end

  get '/win' do
    ### YOUR CODE HERE ###
    game_status = @game.check_win_or_lose
    if game_status == :win
      erb :win
    else
      redirect '/show'
    end
  end

  get '/lose' do
    ### YOUR CODE HERE ###
    game_status = @game.check_win_or_lose
    if game_status == :lose
      erb :lose
    else
      redirect '/show'
    end
  end
end
