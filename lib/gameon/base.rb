module GameOn

  module Middleware 
    include Mushin::Domain::Middleware
  end

  module DSL 
    include Mushin::DSL

    def self.find current_context_title, current_activity_title

      #Mushin::DSL.middlewares = [] #could be GameOn::DSL.middlewares

      Mushin::DSL.contexts.each do |context|
	if context.title == current_context_title
	  context.statments.each do |activity|
	    if activity.title == current_activity_title
	      @@middlewares = []
	      activity.activations.each do |middleware|
		#if Mushin::DSL.middlewares.empty?
		if @@middlewares.empty?
		  p "adding first middleware !!!"
		  @@middlewares << middleware 
		  #return @@middlewares
		  #  Mushin::DSL.middlewares << middleware 
		else
		  # Mushin::DSL.middlewares.each do |prev| 
		  @@middlewares.each do |prev|
		    if prev.name == middleware.name && prev.opts == middleware.opts && prev.params ==  middleware.params
		      p "this activation already exists nothing to do!!!"
		    else
		      p "adding new activation"
		      #Mushin::DSL.middlewares << middleware 
		      @@middlewares << middleware 
		      p "$$$$$$$$$$$$$$$$$$$$$$$$$$$"
		      #p Mushin::DSL.middlewares
		    end
		  end
		end
		return @@middlewares
	      end
	    end
	  end
	end

      end
      #return Mushin::DSL.middlewares
      #Mushin::DSL.middlewares = []
    end
  end

  module Engine
    extend Mushin::Engine
    class << self
      #attr_accessor :middlewares, :stack
      def run domain_context, activity
	#@middlewares = GameOn::DSL.find domain_context, activity 
	stack = Mushin::Middleware::Builder.new do
	  (GameOn::DSL.find domain_context, activity).uniq.each do |middleware|
	    p "GameOn Logging: use #{middleware.name}, #{middleware.opts}, #{middleware.params}"
	    use middleware.name, middleware.opts, middleware.params
	  end
	end
	@setup_middlewares.each do |setup_middleware|
	  stack.insert_before 0, setup_middleware 
	end
	stack.call
      end
    end
  end

  class Env 
    extend Mushin::Env

    class << self
      attr_accessor :id

      def get id
	GameOn::Persistence::DS.load id.to_s + 'gameon' #TODO some app key based encryption method 
      end

      def set id, &block 
	@id = id.to_s + 'gameon' 
	def on domain_context, &block
	  @domain_context = domain_context 
	  @activities = []  
	  def activity statment 
	    @activities << statment
	  end
	  instance_eval(&block)
	end
	instance_eval(&block)

	Dir["./gameon/*"].each {|file| load file }  
	GameOn::Engine.setup [Object.const_get('GameOn::Persistence::DS')]
	@activities.uniq.each do |activity| 
	  GameOn::Engine.run @domain_context, activity   
	end
	@activities = [] # reset the activities 
	return GameOn::Persistence::DS.load @id 
      end
    end
  end
end
