# frozen_string_literal: true

module TokenScreener
  module Pipelines
    module Steps
      class TokenSnifferValidation
        # Accept Result([contracts]) returns Result
        # Filter some tokens, call some rugs out, pass the rest along
        def call(result)
          result.halt if result.value.empty?

          rugs = []
          filtered_contracts = result.value.each_with_object([]) do |address, addresses| # Filter based on TokenSniffer results
            next unless token_sniffer_client.audited?(address)

            rug = token_sniffer_client.flagged?(address) || token_sniffer_client.risk_level(address) == 'high' || !token_sniffer_client.sellable?(address) || token_sniffer_client.rug_test_detected?(address)
            sus = token_sniffer_client.score(address) < 50 || token_sniffer_client.sus_contract_detected?(address)
            # BUSINESS LOGIC
            # PASS if:
            #   score < 50
            #   sus_contract_tests?
            #
            # RUG if:
            #   is_flagged?
            #   risk_level == 'high
            #   sellable? == false
            #   rug_test_detected?
            # ADD rest

            rugs << address if rug
            next if rug || sus

            addresses << address
          end

          # THIS SHOULD BE A SEPARATE JOB TBH NO CAP THINK ABOUT IT FAM
          # OR A METAPIPELINE :SOYFACE:
          rug(rugs)

          # Move values onto next step. Might be empty
          result.continue(filtered_contracts)
        end

        private

        def rug(addresses)
          addresses.each do |address|
            puts 'Rugging contract: ', address, "See explanation: https://tokensniffer.com/token/eth/#{address}"
            Token.update_all({ address: }, { rugged: true })
          end
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
