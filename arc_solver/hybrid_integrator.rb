# frozen_string_literal: true

class HybridIntegrator
  def combine(discrete_solution, expert_solution, pattern)
    # Simplified implementation: use discrete_solution if pattern is recognized, otherwise use expert_solution
    pattern[:type] == :unknown ? expert_solution : discrete_solution
  end
end
