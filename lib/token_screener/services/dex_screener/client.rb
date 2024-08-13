# frozen_string_literal: true

module TokenScreener
  module Services
    module DexScreener
      class Client
        def liquidity(pair)
          response(pair).dig('pair', 'liquidity', 'usd') || 0
        end

        def fdv(pair)
          response(pair).dig('pair', 'fdv') || 0
        end

        private

        def client
          Typhoeus
        end

        def response(pair)
          JSON.parse client.get(pairs_url(pair)).response_body
        end

        # Can pass in a list of pairs
        def pairs_url(pair)
          "https://api.dexscreener.com/latest/dex/pairs/ethereum/#{pair}"
        end
      end
    end
  end
end
