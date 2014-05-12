require_relative './gamebook/game'
require_relative './gamebook/rule'
require_relative './gamebook/dynamic'


module GameOn
  def GameOn.env id
    require 'redis'
    @@redis = Redis.new
    Marshal.load @@redis.get id
    #p env[:gameon].id 
  end

  class Env < Mushin::Env
  end

  module Gamebook
    extend Mushin::DSL::Notebook 
    @@constructs = [] 
    # this is Mandatory as the .find funtion in DSL::Notebook needs it 
    @@games = []
    def game title, &block
      @@game = GameOn::Gamebook::Game.new title
      def rule rule=[], &block
	@rule = GameOn::Gamebook::Rule.new rule
	def activate dynamic, opts={}, params={}
	  @dynamic = GameOn::Gamebook::Dynamic.new dynamic, opts, params
	  @rule.add_dynamic @dynamic 
	end
	@@game.add_rule @rule
	yield
      end
      yield
      @@games << @@game
      @@constructs = @@games
    end
    def Gamebook.games
      @@games
    end
  end

  class Activities < Mushin::DSL::Activities
    #include Mushin::DSL::Activities
    #extend Mushin::DSL::Activities
    def self.construction game, activity   
      GameOn::Engine.run game, activity   
    end
  end

  module Engine
    def Engine.run game, activity
      #[Mushin::Presistence::DS, Mushin::blahblah]
      #use Mushin::Persistence::DS
      #Mushin::Engine.setup do
	#['some entity middleware','some datastore'] 
	#use Mushin::DS.blaa and then class_eval there
      #end
      Mushin::Engine.setup [GameOn::Persistence::DS]
      Mushin::Engine.run game, activity
    end
  end
end
