# frozen_string_literal: true

module TokenScreener
  module Pipelines
    class Pipeline
      attr_reader :steps

      def initialize(&config)
        @steps = []
        config.call(self) and @steps.freeze if block_given?
      end

      def step(callable = nil, &block)
        callable ||= block
        @steps << callable
        self
      end

      def call(result)
        steps.reduce(result) do |r, step|
          r.continue? ? step.call(r) : r
        end
      end
    end
  end
end
