# frozen_string_literal: true

module TokenScreener
  module Services
    module TokenSniffer
      class Client
        HEADERS = { 'Content-Type' => 'application/json' }.freeze

        attr_reader :hydra

        def initialize
          @hydra = Typhoeus::Hydra.hydra
        end

        def sniff_token(address)
          JSON.parse client.get(token_sniffer_url(address), headers: HEADERS).body
        end

        private

        def client
          @client ||= Typhoeus
        end

        def token_sniffer_url(address)
          "https://tokensniffer.com/api/v2/tokens/1/#{address}?apikey=#{ENV.fetch('TOKEN_SNIFFER_API_KEY')}&include_metrics=true&include_tests=true&block_until_ready=true"
        end
      end
    end
  end
end
