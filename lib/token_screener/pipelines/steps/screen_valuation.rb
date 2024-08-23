# frozen_string_literal: true

module TokenScreener
  module Pipelines
    module Steps
      class ScreenValuation
        MIN_LIQUIDITY = 10_000
        MIN_FDV = 100_000

        def call(result)
          return result.halt if result.value.empty?

          # Opportunity for batch?
          filtered_contracts = result.value.each_with_object([]) do |address, r|
            adequate_liquidity = dexscreener_client.liquidity(address) > MIN_LIQUIDITY
            adequate_fdv = dexscreener_client.fdv(address) > MIN_FDV

            r << address if adequate_liquidity && adequate_fdv
          end

          result.continue(filtered_contracts)
        end

        def dexscreener_client
          @dexscreener_client ||= TokenScreener::Services::DexScreener::Client.new
        end
      end
    end
  end
end
