# frozen_string_literal: true

require 'colorize'

module TokenScreener
  module Tasks
    module Pipelines
      module Ethereum
        class Filter
          def self.perform
            # Batch read from Postgresql?
            # Non rugged tokens recorded in the last 24hrs
            addresses = Token.where(created_at: 7.days.ago..Time.current, rugged: false).map(&:address)

            initial_result = TokenScreener::Pipelines::Result.new(addresses)

            filterer = TokenScreener::Pipelines::Pipeline.new do |p|
              p.step TokenScreener::Pipelines::Steps::ScreenValuation.new
              p.step TokenScreener::Pipelines::Steps::Ethereum::TokenSnifferValidation.new
              # p.step TokenScreener::Pipelines::Steps::AnnounceResults
              p.step { |r| r.value.empty? ? r.halt : r }
            end

            final_result = filterer.call(initial_result)

            # I think this can all be handeled in a Loader, or a final job. No need to clutter up this
            # space ya feel me dude?
            # TokenScreener::Pipelines::Steps::AnnounceResults
            #
            if final_result.value.empty?
              puts "

                Scanned #{initial_result.value.size} tokens on Uniswap v2

                No survivors detected!
              ".colorize(:yellow)
              return
            end

            puts "

                Current batch of surviving contracts announced!
            ".colorize(:green)

            puts final_result.value.inspect

            final_result.value.each { |address| puts " --- Dexscreener URL: https://dexscreener.com/ethereum#{address} --- ".colorize(:green) }
          end
        end
      end
    end
  end
end
