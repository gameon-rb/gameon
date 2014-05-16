require_relative './spec_helper'
require 'minitest/autorun' 
require 'minitest/pride'

describe GameOn::Gamebook do
  before do 
    @gamebook = Object.send :include, GameOn::Gamebook
    module GameOn::Points; end
    @gameon_gamebook = @gamebook.game('dd') do 
      rule [:user, :visits, :good_page] do 
	activate GameOn::Points
      end
      rule [:user, :visits, :bad_page] do 
	activate GameOn::Points
      end
    end 
  end

  it "provides gamebook array with 'game' objects" do
    @gameon_gamebook.must_be_kind_of Array 
    @gameon_gamebook.count.must_equal 1
    @gameon_gamebook.each do |game|
      game.must_be_kind_of GameOn::Gamebook::Game
      game.rules.each do |rule|
	rule.must_be_kind_of GameOn::Gamebook::Rule
	rule.dynamix.each do |dynamic|
	  dynamic.must_be_kind_of GameOn::Gamebook::Dynamic
	end
      end
    end
  end
end
