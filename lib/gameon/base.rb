module GameOn
  def GameOn.env id
    GameOn::Persistence::DS.load id
  end

  
  module Gamebook
    extend Mushin::DSL::Notebook 
    Mushin::DSL::Notebook.build 'game', 'rule', 'activate' 
    #TODO As a Framework developer you get to add alias_methods
    # Example  alias_method :ninja, :rule
  end

  class Env < Mushin::Env

  end

  #class Activities < Mushin::DSL::Activities
  #include Mushin::DSL::Activities
  #extend Mushin::DSL::Activities
  #TODO transfer construction to mushin
  #def self.construction game, activity   
  #  GameOn::Engine.run game, activity   
  #end
  #end
 
=begin
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
=end
end
