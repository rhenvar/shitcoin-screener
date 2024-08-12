# frozen_string_literal: true

module TokenScreener
  module Services
    module EtherScan
      class Client

        attr_reader :hydra

        def initialize
          @hydra = Typhoeus::Hydra.hydra
        end

        # Somehow fetch createdPairs in a stream or subscription?
        # Observer
        def contracts
        end

        def balance(address)
          client.get(etherscan_api_balance_url(address))
        end

        private
        def client
          Typhoeus
        end

        def etherscan_api_url
          "https://api.etherscan.io/api?apikey=#{ENV.fetch('ETHERSCAN_API_KEY')}"
        end

        def etherscan_api_balance_url(address)
          "#{etherscan_api_url}&module=account&action=balance&address=#{address}&tag=latest"
        end
      end
    end
  end
end

