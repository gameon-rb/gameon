module GameOn
  module Gamebook
    class Game
      attr_accessor :title, :rules
      def initialize title
	@title = title
	@rules = []
      end
      def add_rule rule
	@rules += [rule]
      end

      def rules 
	@rules
      end
    end
  end
end
