# frozen_string_literal: true

module TokenScreener
  module Pipelines
    module Steps
      class TokenSnifferValidation
        # Accept Result([contracts]) returns Result
        def call(result)
          result.halt if result.value.empty?

          filtered_contracts = result.value.each_with_object([]) do |address, _r| # Filter based on TokenSniffer results
            # time for investigation niggers
            #
            # Need a way to mark a contract 'rug' if certain conditions are met
            # Perhaps --- Result.rug? monad??? :soyface: nigger coom face
            response = token_sniffer_client.sniff_token(address)

            # Hold up nigger let's think about this for a second
            # understand? Cool. We are accepting a [] and need to
            # do something to each element in it okay?
            # each -> fetch(contract)
            #  -> read rug criteria
            #   -> mark rug if reached
            #
            #
            next unless response['message'] == 'OK'

            # Continue if any are true
            too_risky = response['score'] < 80
            contract_source_unverified = !response['contract']['is_source_verified']
            has_fee_modifier = response['contract']['has_fee_modifier']
            has_blocklist = response['contract']['has_blocklist']
            has_proxy = response['contract']['has_proxy']

            # Rug if any are true
            is_flagged = response['is_flagged']
            too_risky = response['riskLevel'] == 'high'
            unsellable = !response.dig('swap_simulation', 'is_sellable')

            # Rug if any of these tests are true
            rug_tests = Set[
                              'testForProxy',
                              'testForMaxTransactionAmount',
                              'testForHighCreatorTokenBalance',
                              'testForHighOwnerTokenBalance',
                              'testForUnableToSell',
                              'testForExtremeFee'
                            ]
            rug_test_detected = dexscreener_client.rug_test_detected?(rug_tests)
          end
        end

        private

        def token_sniffer_client
          @token_sniffer_client ||= TokenScreener::Services::TokenSniffer::Client.new
        end

        def contract_db_interface
          # Need to write rug=true to db
          # Throw bad data out early
        end
      end
    end
  end
end
