# frozen_string_literal: true

require_relative "../../arc_solver/program_searcher"

RSpec.describe ProgramSearcher do
  let(:searcher) { ProgramSearcher.new }

  describe "#search" do
    context "with simple arithmetic operations" do
      it "identifies addition operation" do
        task = {
          train: [
            { input: [[1, 2], [3, 4]], output: [[2, 3], [4, 5]] },
            { input: [[0, 1], [2, 3]], output: [[1, 2], [3, 4]] }
          ]
        }
        result = searcher.search(task)
        expect(result).to eq({ operation: :addition, value: 1 })
      end

      it "identifies multiplication operation" do
        task = {
          train: [
            { input: [[1, 2], [3, 4]], output: [[2, 4], [6, 8]] },
            { input: [[2, 3], [4, 5]], output: [[4, 6], [8, 10]] }
          ]
        }
        result = searcher.search(task)
        expect(result).to eq({ operation: :multiplication, value: 2 })
      end
    end

    context "with pattern operations" do
      it "identifies row reversal" do
        task = {
          train: [
            { input: [[1, 2, 3], [4, 5, 6]], output: [[3, 2, 1], [6, 5, 4]] },
            { input: [[7, 8, 9], [1, 2, 3]], output: [[9, 8, 7], [3, 2, 1]] }
          ]
        }
        result = searcher.search(task)
        expect(result).to eq({ operation: :row_reversal })
      end

      it "identifies column reversal" do
        task = {
          train: [
            { input: [[1, 2], [3, 4], [5, 6]], output: [[5, 6], [3, 4], [1, 2]] },
            { input: [[7, 8], [9, 1], [2, 3]], output: [[2, 3], [9, 1], [7, 8]] }
          ]
        }
        result = searcher.search(task)
        expect(result).to eq({ operation: :column_reversal })
      end
    end

    context "with complex operations" do
      it "identifies combination of operations" do
        task = {
          train: [
            { input: [[1, 2], [3, 4]], output: [[3, 5], [7, 9]] },
            { input: [[2, 3], [4, 5]], output: [[5, 7], [9, 11]] }
          ]
        }
        result = searcher.search(task)
        expect(result).to eq([
          { operation: :multiplication, value: 2 },
          { operation: :addition, value: 1 }
        ])
      end
    end

    context "with unknown patterns" do
      it "returns nil for unrecognized patterns" do
        task = {
          train: [
            { input: [[1, 2], [3, 4]], output: [[5, 6], [7, 8]] },
            { input: [[2, 3], [4, 5]], output: [[6, 7], [8, 9]] }
          ]
        }
        result = searcher.search(task)
        expect(result).to be_nil
      end
    end
  end

  describe "#apply_operation" do
    it "applies addition operation" do
      input = [[1, 2], [3, 4]]
      operation = { operation: :addition, value: 2 }
      expect(searcher.apply_operation(input, operation)).to eq([[3, 4], [5, 6]])
    end

    it "applies multiplication operation" do
      input = [[1, 2], [3, 4]]
      operation = { operation: :multiplication, value: 3 }
      expect(searcher.apply_operation(input, operation)).to eq([[3, 6], [9, 12]])
    end

    it "applies row reversal operation" do
      input = [[1, 2, 3], [4, 5, 6]]
      operation = { operation: :row_reversal }
      expect(searcher.apply_operation(input, operation)).to eq([[3, 2, 1], [6, 5, 4]])
    end

    it "applies column reversal operation" do
      input = [[1, 2], [3, 4], [5, 6]]
      operation = { operation: :column_reversal }
      expect(searcher.apply_operation(input, operation)).to eq([[5, 6], [3, 4], [1, 2]])
    end

    it "applies multiple operations" do
      input = [[1, 2], [3, 4]]
      operations = [
        { operation: :multiplication, value: 2 },
        { operation: :addition, value: 1 }
      ]
      expect(searcher.apply_operation(input, operations)).to eq([[3, 5], [7, 9]])
    end
  end
end
