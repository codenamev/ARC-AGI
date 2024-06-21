# frozen_string_literal: true

require_relative "arc_solver/mixture_of_experts"
require_relative "arc_solver/hybrid_integrator"
require_relative "arc_solver/program_searcher"
require_relative "arc_solver/pattern_recognizer"

class ARCSolver
  def initialize
    @program_searcher = ProgramSearcher.new
    @moe_system = MixtureOfExperts.new
    @pattern_recognizer = PatternRecognizer.new
    @hybrid_integrator = HybridIntegrator.new
  end

  def solve(task)
    discrete_solution = @program_searcher.search(task)
    expert_solution = @moe_system.process(task[:test].first[:input])
    pattern = @pattern_recognizer.recognize(task)

    @hybrid_integrator.combine(discrete_solution, expert_solution, pattern)
  end
end
