# frozen_string_literal: true

namespace :pipelines do
  task filter: [:environment] do
    # Start contract filtering pipeline (Ethereum only)
    while True
      TokenScreener::Tasks::Pipelines::Filter.perform
      sleep(300)
    end
  end
end
