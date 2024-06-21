# frozen_string_literal: true

class MixtureOfExperts
  def initialize
    @experts = [
      ->(input) { input.map { |row| row.map { |cell| cell * 2 } } },  # Doubling expert
      ->(input) { input.map { |row| row.map { |cell| cell + 1 } } }   # Incrementing expert
    ]
    @gating_network = GatingNetwork.new
  end

  def process(input)
    expert_outputs = @experts.map { |expert| expert.call(input) }
    @gating_network.route(input, expert_outputs)
  end

  class GatingNetwork
    def route(input, expert_outputs)
      expert_outputs.first
    end
  end
end
