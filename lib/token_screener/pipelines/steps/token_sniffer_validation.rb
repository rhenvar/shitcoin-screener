# frozen_string_literal: true

module TokenSniffer
  module Pipelines
    module Steps
      class TokenSnifferValidation
        # Accept Result([contracts]) returns Result
        def call(result)
          result.halt if result.value.empty?

          filtered_contracts = result.value.each_with_object([]) do |address, r|
            # Filter based on TokenSniffer results
            # time for investigation niggers
          end
        end

        private

        def verify_tradeable; end

        def verify_sellable; end

        def token_sniffer_client
          @token_sniffer_client ||= TokenScreener::Services::TokenSniffer::Client.new
        end
      end
    end
  end
end
