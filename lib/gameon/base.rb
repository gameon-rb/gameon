module GameOn

  module Middleware 
    include Mushin::Domain::Middleware
  end

  module DSL 
    include Mushin::DSL
    def self.find activity_context, activity_statment
      Mushin::DSL.middlewares = []
      Mushin::DSL.contexts.each do |current_context|
	if activity_context == current_context.title
	  current_context.statments.each do |statment|
	    if activity_statment == statment.title
	      statment.activations.each do |middleware|
		Mushin::DSL.middlewares << middleware 
	      end
	    end
	  end
	end
      end
      Mushin::DSL.middlewares
    end
  end

  module Engine
    extend Mushin::Engine
    class << self
      #attr_accessor :middlewares, :stack
      def run domain_context, activity
	#@middlewares = GameOn::DSL.find domain_context, activity 
	@stack = Mushin::Middleware::Builder.new do
	  (GameOn::DSL.find domain_context, activity).each do |middleware|
	    p "GameOn Logging: use #{middleware.name}, #{middleware.opts}, #{middleware.params}"
	    use middleware.name, middleware.opts, middleware.params
	  end
	end
	@setup_middlewares.each do |setup_middleware|
	  @stack.insert_before 0, setup_middleware 
	end
	@stack.call
	#@middlewares = []
      end
    end
  end

  class Env 
    extend Mushin::Env

    class << self
      attr_accessor :id

      def get id
	GameOn::Persistence::DS.load id.to_s + 'gameon'
      end

      def set id, &block 
	@id = id.to_s + 'gameon' 
	def on domain_context, &block
	  @domain_context = domain_context 
	  @activities = []  
	  def activity statment 
	    @activities << statment
	    #@activities += [statment]                                                                          
	  end
	  instance_eval(&block)
	end
	instance_eval(&block)

	Dir["./gameon/*"].each {|file| load file }  
	GameOn::Engine.setup [Object.const_get('GameOn::Persistence::DS')]
	@activities.each do |activity| 
	  GameOn::Engine.run @domain_context, activity   
	end
	#@activities = [] # reset the activities 
	return GameOn::Persistence::DS.load @id 
      end
    end
  end
end
