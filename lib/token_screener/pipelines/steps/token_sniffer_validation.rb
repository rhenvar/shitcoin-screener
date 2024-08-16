# frozen_string_literal: true

module TokenScreener
  module Pipelines
    module Steps
      class TokenSnifferValidation
        # Accept Result([contracts]) returns Result
        def call(result)
          result.halt if result.value.empty?

          filtered_contracts = result.value.each_with_object([]) do |address, addresses| # Filter based on TokenSniffer results
            # time for investigation niggers
            #
            # Need a way to mark a contract 'rug' if certain conditions are met
            # Perhaps --- Result.rug? monad??? :soyface: nigger it has to make sense
            #
            next unless token_sniffer_client.audited?(address)

            rug = token_sniffer_client.flagged?(address) || token_sniffer_client.risk_level(address) == 'high' || !token_sniffer_client.sellable?(address) || token_sniffer_client.rug_test_detected?(address)
            sus = token_sniffer_client.score(address) < 50 || token_sniffer_client.sus_contract_detected?(address)
            # BUSINESS LOGI
            # PASS if:
            #   score < 50
            #   sus_contract_tests?
            #
            # RUG if:
            #   is_flagged?
            #   risk_level == 'high
            #   sellable? == false
            #   rug_test_detected?

            rug(address) if rug
            next if rug || sus

            addresses << address
          end

          # Move values onto next step. Might be empty
          result.continue(filtered_contracts)
        end

        private

        def rug(address)
          Token.rug(address)
        end

        def token_sniffer_client
          @token_sniffer_client ||= TokenScreener::Services::TokenSniffer::Client.new
        end

        def contract_db_interface
          # Need to write rug=true to db
          # Throw bad data out early
          'WOULD BE MARKING AS RUGGED'
        end
      end
    end
  end
end
