ENV['RACK_ENV'] = 'test'
require_relative '../lib/gameon.rb'  
require 'minitest/autorun' 
require 'minitest/pride'
require 'rack/test'
