require 'lita'
require 'lita/handler'

module Lita
  class Handler
    class << self
      def inherited(subclass)
        handlers << subclass
        super
      end

      def handlers
        @handlers ||= []
      end
    end
  end
end
