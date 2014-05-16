module GameOn
  def GameOn.env id
    require 'redis'
    @@redis = Redis.new
    Marshal.load @@redis.get id
  end

  class Env < Mushin::Env
  end

  module Gamebook
    extend Mushin::DSL::Notebook 
    Mushin::DSL::Notebook.build 'game', 'rule', 'activate' 
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
