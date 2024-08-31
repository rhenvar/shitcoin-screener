# frozen_string_literal: true

namespace :contracts do
  task listen: [:environment] do
    # Listen to newly released contracts
    TokenScreener::Tasks::Contracts::Ethereum::Listen.perform
  end
end
