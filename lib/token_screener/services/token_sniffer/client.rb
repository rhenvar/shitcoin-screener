# frozen_string_literal: true

module TokenScreener
  module Services
    module TokenSniffer
      class Client
        HEADERS = { 'Content-Type' => 'application/json' }.freeze

        attr_reader :hydra, :response_cache

        def initialize
          @hydra = Typhoeus::Hydra.hydra
          @response_cache = {}
        end

        def risk_level(address)
          response(address)['riskLevel']
        end

        def audited?(address)
          response(address)['message'] == 'OK'
        end

        def sellable?(address)
          response(address)['swap_simulation']['is_sellable']
        end

        def flagged?(address)
          response(address)['is_flagged']
        end

        def score(address)
          response(address)['score']
        end

        def rug_test_detected?(address)
          rug_tests = Set[
            'testForProxy',
            'testForMaxTransactionAmount',
            'testForHighCreatorTokenBalance',
            'testForHighOwnerTokenBalance',
            'testForUnableToSell',
            'testForExtremeFee'
          ]
          result = false
          response(address)['tests'].each do |test|
            if rug_tests.include?(test['id']) && test['result']
              result = true
              break
            end
          end
          result
        end

        def sus_contract_detected?(address)
          sus_contract_tests = %w[
            is_source_verified
            has_fee_modifier
            has_blocklist
            has_proxy
          ]

          result = false
          sus_contract_tests.each do |test|
            if response(address)[test]
              result = false
              break
            end
          end
          result
        end

        def client
          @client ||= Typhoeus
        end

        def response(address)
          return response_cache[address] if response_cache.key?(address)

          response_cache[address] = JSON.parse client.get(token_sniffer_url(address), headers: HEADERS).body
          response_cache[address]
        end

        def token_sniffer_url(address)
          "https://tokensniffer.com/api/v2/tokens/1/#{address}?apikey=#{ENV.fetch('TOKEN_SNIFFER_API_KEY')}&include_metrics=true&include_tests=true&block_until_ready=true"
        end
      end
    end
  end
end
