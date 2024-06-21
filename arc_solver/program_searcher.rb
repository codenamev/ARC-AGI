# frozen_string_literal: true

class ProgramSearcher
  def search(task)
    train_pairs = task[:train]
    operations = train_pairs.map { |pair| identify_operation(pair[:input], pair[:output]) }

    return nil if operations.any?(&:nil?) || operations.uniq.length != 1

    operations.first
  end

  def apply_operation(input, operation)
    return input if operation.nil?

    if operation.is_a?(Array)
      operation.reduce(input) { |acc, op| apply_single_operation(acc, op) }
    else
      apply_single_operation(input, operation)
    end
  end

  private

  def identify_operation(input, output)
    return { operation: :row_reversal } if row_reversal?(input, output)
    return { operation: :column_reversal } if column_reversal?(input, output)

    arithmetic_op = identify_arithmetic_operation(input, output)
    return arithmetic_op if arithmetic_op

    complex_op = identify_complex_operation(input, output)
    return complex_op if complex_op

    nil
  end

  def apply_single_operation(input, operation)
    case operation[:operation]
    when :addition
      input.map { |row| row.map { |cell| cell + operation[:value] } }
    when :multiplication
      input.map { |row| row.map { |cell| cell * operation[:value] } }
    when :row_reversal
      input.map(&:reverse)
    when :column_reversal
      input.reverse
    else
      input
    end
  end

  def row_reversal?(input, output)
    input.map(&:reverse) == output
  end

  def column_reversal?(input, output)
    input.reverse == output
  end

  def identify_arithmetic_operation(input, output)
    flattened_input = input.flatten
    flattened_output = output.flatten

    if flattened_input.zip(flattened_output).all? { |i, o| o == i + 1 }
      { operation: :addition, value: 1 }
    elsif flattened_input.zip(flattened_output).all? { |i, o| o == i * 2 }
      { operation: :multiplication, value: 2 }
    else
      nil
    end
  end

  def identify_complex_operation(input, output)
    operations = []

    # Check for multiplication followed by addition
    multiplied = input.map { |row| row.map { |cell| cell * 2 } }
    if multiplied.flatten.zip(output.flatten).all? { |m, o| o == m + 1 }
      operations << { operation: :multiplication, value: 2 }
      operations << { operation: :addition, value: 1 }
    end

    operations.empty? ? nil : operations
  end
end
