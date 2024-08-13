# frozen_string_literal: true

namespace :pipelines do
  task filter: [:environment] do
    # Start contract filtering pipeline (Ethereum only)
    TokenScreener::Tasks::Pipelines::Filter.perform
  end
end
