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
    @@ds = 'GameOn::Persistence::DS'
  end
end
