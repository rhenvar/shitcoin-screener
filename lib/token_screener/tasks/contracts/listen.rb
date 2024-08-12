# frozen_string_literal: true

require 'faye/websocket'
require 'eventmachine'

module TokenScreener
  module Tasks
    module Contracts
      class Listen

        def self.perform
          EM.run {
            ws = Faye::WebSocket::Client.new("wss://mainnet.infura.io/ws/v3/#{ENV.fetch('INFURA_API_KEY')}")
            # -x '{"jsonrpc":"2.0", "id": 1, "method": "eth_subscribe", "params": ["logs", {"address": "0x8320fe7702b96808f7bbc0d4a888ed1468216cfd", "topics":["0xd78a0cb8bb633d06981248b816e7bd33c2a35a6089241d099fa519e361cab902"]}]}'

            ws.on :open do |event|
              p [:open]
              ws.send('{"jsonrpc": "2.0", "id": 1, "method": "eth_subscribe", "params": ["newPendingTransactions"]}')
            end

            ws.on :message do |event|
              p [:message, event.data]
            end

            ws.on :close do |event|
              p [:close, event.code, event.reason]
              ws = nil
            end
          }
        end
      end
    end
  end
end

