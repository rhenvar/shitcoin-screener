# frozen_string_literal: true

require 'colorize'
require 'faye/websocket'
require 'eventmachine'
require 'digest/keccak'
require 'eth'

module TokenScreener
  module Tasks
    module Contracts
      class Listen
        def self.perform
          listener = TokenScreener::Tasks::Contracts::Listen.new
          jrpc_payload = listener.jrpc_string(listener.uniswap_pair_created_topic)

          EM.run do
            new_pairs_observed = 0
            ws = Faye::WebSocket::Client.new("wss://mainnet.infura.io/ws/v3/#{ENV.fetch('INFURA_API_KEY')}")

            ws.on :open do |_event|
              p [:open]
              ws.send(jrpc_payload)
            end

            ws.on :message do |event|
              data = JSON.parse(event.data)

              case data['method']
              when 'eth_subscription'
                new_pairs_observed += 1
                pair = Eth::Abi.decode(['address'], data.dig('params', 'result', 'data'))[0]

                p ' --- NEW PAIR DETECTED ON ETH MAINNET  ---'
                p " --- Dexscreener URL: https://dexscreener.com/ethereum/#{pair} ---"
                Token.create(address: pair)
              end
            end

            ws.on :close do |event|
              p "New Pairs Observed: #{new_pairs_observed}"
              p [:close, event.code, event.reason]
              ws = nil
            end
          end
        end

        def jrpc_string(topic)
          {
            jsonrpc: '2.0',
            id: 1,
            method: 'eth_subscribe',
            params: [
              'logs',
              {
                topics: [topic]
              }
            ]
          }.to_json
        end

        # Uniswap V2 Factory
        # 0d3648bd0f6ba80134a33ba9275ac585d9d315f0ad8355cddefde31afa28d0e9
        def uniswap_pair_created_topic
          "0x#{Digest::Keccak.hexdigest('PairCreated(address,address,address,uint256)', 256)}" # 256bit hex digest
        end
      end
    end
  end
end
