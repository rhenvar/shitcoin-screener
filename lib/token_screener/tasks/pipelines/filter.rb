# frozen_string_literal: true

module TokenScreener
  module Tasks
    module Pipelines
      class Filter
        def self.perform
          # Batch read from Postgresql?
          addresses = []
          initial_result = TokenScreener::Pipelines::Result.new(addresses)

          filterer = TokenScreener::Pipelines::Pipeline.new do |p|
            p.step do |r|
              puts 'Logging'
              r
            end
            p.step TokenScreener::Pipelines::Steps::ScreenValuation.new
            p.step TokenScreener::Pipelines::Steps::TokenSnifferValidation.new
            p.step { |r| r.value.empty? ? r.halt : r }
          end

          final_result = filterer.call(initial_result)
          puts final_result.value
          puts final_result.continue?
        end
      end
    end
  end
end
