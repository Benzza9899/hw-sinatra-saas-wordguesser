# frozen_string_literal: true

# Represents a word guessing game.
class WordGuesserGame
  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # Make a guess in the game.
  def guess(letter)
    raise ArgumentError if letter.nil? || letter !~ /\A[a-zA-Z]\Z/i

    letter = letter[0].downcase
    if @word.include?(letter) && !@guesses.include?(letter)
      @guesses += letter
    elsif !@word.include?(letter) && !@wrong_guesses.include?(letter)
      @wrong_guesses += letter
    else
      false
    end
  end

  # Returns the word with guessed letters filled in.
  def word_with_guesses
    display = ''
    @word.chars do |char|
      display += @guesses.include?(char) ? char : '-'
    end
    display
  end

  # Check if the game is won, lost, or still in progress.
  def check_win_or_lose
    return :win if word_with_guesses == @word
    return :lose if @wrong_guesses.length >= 6

    :play
  end

  # Get a random word from a remote service.
  def self.random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, '').body
    end
  end
end
