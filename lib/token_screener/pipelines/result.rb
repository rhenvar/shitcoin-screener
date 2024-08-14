# frozen_string_literal: true

module TokenScreener
  module Pipelines
    # Contract filter step Result monad
    class Result
      attr_reader :value

      def initialize(value, continue: true)
        @value = value
        @continue = continue
      end

      def continue(value)
        Result.new(value)
      end

      # Success
      def continue?
        @continue
      end

      # Failure
      def halt
        Result.new(value, continue: false)
      end
    end
  end
end
