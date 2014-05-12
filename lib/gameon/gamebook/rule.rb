module GameOn
  module Gamebook
    class Rule
      attr_accessor :title, :dynamix
      def initialize title 
	@title = title
	@dynamix = []
      end

      def add_dynamic dynamic
	@dynamix += [dynamic]
      end

      def all_dynamix 
	@dynamix
      end

    end
  end
end
