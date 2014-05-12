module GameOn
  module Gamebook
    class Dynamic
      attr_accessor :name, :opts, :params
      def initialize name, opts={}, params={} 
	@name = name 
	@opts = opts
	@params = params
      end

    end
  end
end
