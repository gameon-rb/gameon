require_relative './spec_helper'
require 'forwardable'
require "redis"

module GameOn 
  module Persistence
    class DS 

      GameOn::Env.register do 
	attr_accessor :id
      end

      @@redis = Redis.new

      def initialize app
	@app = app
	@id = GameOn::Env.id
      end

      def call(env)
	p "GameOn::Persistence::DS instance id = #{@id}" 
	if exists? @id 
	  env[:gameon] = DS.load @id 
	  p "resotred #{env[:gameon]}"
	else 
	  p 'new obj from GameOn::Env class '
	  env[:gameon] = GameOn::Env.new
	  env[:gameon].id  = @id
	  p "env[:gameon].id equals #{env[:gameon].id}"
	end
	@app.call(env)
	DS.store env[:gameon] 
	p "stored #{env[:gameon]}" 
      end

      def DS.store obj
	begin
	  @gameon_env = Marshal.dump obj 
	  @@redis.set(obj.id, @gameon_env)
	ensure
	  p "storing GameOn Env #{obj}"
	end
      end
      def DS.load id
	return Marshal.load (@@redis.get(id))
      end

      def exists? id
	if (@@redis.get id) && (Marshal.load @@redis.get id) 
	  p "GameOn::Persistence::DS.exists? true" 
	  return true
	else 
	  p "GameOn::Persistence::DS.exists? false" 
	  return false
	end
      end
    end
  end
end
GameOn::Env.register do
  attr_accessor :points

  def add_points value
    (@points.nil?) ? (@points = value) : (@points += value) 
  end

  def remove_points value
    (@points.nil?) ? (@points = -value) : (@points -= value) 
  end

end

module GameOn
  class Points  
    include GameOn::Middleware 

    def initialize(app, opts={},params={})
      @app = app
      @opts = opts 
      @params = params
    end

    def call(env)
      if !@opts.nil? && !@params.nil? && @params.has_key?(:add)
	env[:gameon].add_points(@params[:add] * @opts[:inc_by]) 
	#env[:gameon].points = GameOn::Env.add_points(@params[:add] * @opts[:inc_by]) 
	#GameOn::Env.add_points(@params[:add] * @opts[:inc_by]) 
      end
      if !@opts.nil? && !@params.nil? && @params.has_key?(:remove) 
	env[:gameon].remove_points(@params[:remove] * @opts[:dec_by]) 
      end
      @app.call(env) # run the next middleware
    end
  end
end

require 'sinatra'

class User
  attr_accessor :id
  def initialize id
    @id = id
  end
end


get '/good/:id' do
  user = User.new params[:id]

  GameOn::Env.set user.id do 
    on :good_mayor do 
      activity [:user, :visits, :good_page_four]
    end
  end
  #GameOn::Points::Params[:addition] = {:add => 1} 


  gameon = GameOn::Env.get user.id 

  "#{gameon.id}: #{gameon.points}"  #"#{Time.now} Welcome #{gameon.id} Current score is #{gameon.points}"
end

GameOn::Points::Params[:addition] = {:add => 10} 
module GoMaster 
  module Gamebook 
    extend GameOn::DSL
    opts = {:inc_by => 1, :dec_by => 1 }

    context :good_mayor do 
      statment [:user, :visits, :good_page_four] do 
	activation GameOn::Points, opts, GameOn::Points::Params[:addition] 
	activation GameOn::Points, opts, {:remove => 3}
	#activation GameOn::Points, opts, {:add => 1} 
      end
    end
  end
end

describe "a sinatra web application" do 

  before do
    @app_key = "secret_key used by domain frameworks for encryptions"
    @user_id = rand(1000000).to_s #@user_id = "05"
  end

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "should successfully return the user's Points" do
    10.times do 
      get "/good/#{@user_id}"
    end
    last_response.must_be :ok?
    last_response.body.must_include "#{@user_id+'gameon'}:"
    last_response.body.must_equal "#{@user_id+'gameon'}: #{70}" 
  end

  after do 
    redis = Redis.new
    redis.del @user_id + 'gameon' 
  end
end

=begin # remove into its own file
describe "GameOn Framework" do
  before do 
  end

  it "provides a GameOn DSL for Gamification Experts & Domain Developers" do 

    module GoMaster 
      module Gamebook 
	extend GameOn::DSL
	opts = {:inc_by => 1, :dec_by => 1 }

	context :good_mayor do 
	  statment [:user, :visits, :good_page_two] do 
	    activation GameOn::Points, opts, {:remove => 2}
	    activation GameOn::Points, opts, {:add => 2}
	  end
	end

	context :bad_mayor do 
	  statment [:user, :visits, :bad_page_two] do 
	    activation GameOn::Points, opts, {:remove => 2}
	  end
	end

      end 
    end 

  end

  it "provides a Domain Enviroment" do 

  end
end
=end
