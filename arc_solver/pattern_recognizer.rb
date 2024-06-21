# frozen_string_literal: true

class PatternRecognizer
  def recognize(task)
    input = task[:train].first[:input]
    output = task[:train].first[:output]

    if output.flatten.all? { |cell| cell == input.flatten.first * 2 }
      { type: :multiplication, factor: 2 }
    else
      { type: :unknown }
    end
  end
end
