# frozen_string_literal: true

require "json"
require_relative "spec_helper"
require_relative "../arc_solver"

RSpec.describe ARCSolver do
  let(:sample_task) do
    JSON.parse(File.read("spec/fixtures/sample_task.json"), symbolize_names: true)
  end

  describe "#solve" do
    it "returns a solution for a given task" do
      solver = ARCSolver.new
      solution = solver.solve(sample_task)
      expect(solution).to be_a(Array)
      expect(solution.first).to be_a(Array)
    end
  end
end

RSpec.describe MixtureOfExperts do
  let(:input) { [[1, 2], [3, 4]] }

  describe "#process" do
    it "returns a combined output from experts" do
      moe = MixtureOfExperts.new
      result = moe.process(input)
      expect(result).to be_a(Array)
    end
  end
end

RSpec.describe PatternRecognizer do
  describe "#recognize" do
    it "identifies a pattern in the given task" do
      recognizer = PatternRecognizer.new
      task = { train: [{ input: [[1, 2], [3, 4]], output: [[2, 4], [6, 8]] }] }
      pattern = recognizer.recognize(task)
      expect(pattern).to be_a(Hash)
      expect(pattern).to have_key(:type)
    end
  end
end

RSpec.describe HybridIntegrator do
  describe "#combine" do
    it "integrates different solution approaches" do
      integrator = HybridIntegrator.new
      discrete_solution = [[2, 4], [6, 8]]
      expert_solution = [[2, 4], [6, 8]]
      pattern = { type: :multiplication, factor: 2 }

      result = integrator.combine(discrete_solution, expert_solution, pattern)
      expect(result).to be_a(Array)
      expect(result.first).to be_a(Array)
    end
  end
end
