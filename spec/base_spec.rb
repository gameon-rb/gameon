require_relative './spec_helper'
require 'minitest/autorun' 
require 'minitest/pride'

describe "GameOn Framework" do
  before do 
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
  end

  it "provides a GameOn DSL for Gamification Experts & Domain Developers" do 
    module GoMaster 
      module Gamebook 
	extend GameOn::DSL
	opts = {:inc_by => 1, :dec_by => 1 }

	context :good_mayor do 
	  statment [:user, :visits, :good_page_two] do 
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
