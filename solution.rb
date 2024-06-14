# frozen_string_literal: true

require "bundler/inline"
require "logger"
require "json"

gemfile do
  source "https://rubygems.org"
  gem "tensorflow"
end

logger = Logger.new($stdout)
logger.info "Loaded TensorFlow v#{TensorFlow::VERSION}"

# data = JSON.parse(File.read('arc_task.json'))
data = Dir["./data/training/*.json"].map { |f| JSON.parse File.read(f) }.flatten
train_data = data["train"]
test_data = data["test"]

# Preprocess data to suitable format
def preprocess_data(data)
  inputs, outputs = [], []
  data.each do |pair|
    inputs << pair['input'].flatten
    outputs << pair['output'].flatten
  end
  [inputs, outputs]
end

# Define spatial reasoning functions
def translate_grid(grid, dx, dy)
  translated = Array.new(grid.size) { Array.new(grid[0].size, 0) }
  grid.each_with_index do |row, i|
    row.each_with_index do |val, j|
      ni, nj = i + dy, j + dx
      if ni.between?(0, grid.size - 1) && nj.between?(0, row.size - 1)
        translated[ni][nj] = val
      end
    end
  end
  translated
end

def rotate_grid(grid, angle)
  case angle
  when 90
    grid.transpose.map(&:reverse)
  when 180
    grid.reverse.map(&:reverse)
  when 270
    grid.transpose.reverse
  else
    grid
  end
end

def reflect_grid(grid, axis)
  axis == :horizontal ? grid.map(&:reverse) : grid.reverse
end

def scale_grid(grid, factor)
  scaled = Array.new(grid.size * factor) { Array.new(grid[0].size * factor) }
  grid.each_with_index do |row, i|
    row.each_with_index do |val, j|
      factor.times do |fi|
        factor.times do |fj|
          scaled[i * factor + fi][j * factor + fj] = val
        end
      end
    end
  end
  scaled
end


# Prediction and reasoning functions
def predict_patterns(model, input_grid)
  # Simplified prediction for demonstration
  [{ dx: 1, dy: 1, angle: 90, axis: :horizontal, factor: 2 }]
end

def apply_symbolic_reasoning(grid, pattern)
  transformed_grid = translate_grid(grid, pattern[:dx], pattern[:dy])
  transformed_grid = rotate_grid(transformed_grid, pattern[:angle])
  transformed_grid = reflect_grid(transformed_grid, pattern[:axis])
  transformed_grid = scale_grid(transformed_grid, pattern[:factor])
  transformed_grid
end

def valid_solution?(solution)
  # Validate the solution according to ARC rules
  true
end

def find_solution(input_grid, model)
  predicted_patterns = predict_patterns(model, input_grid)
  
  solutions = []
  predicted_patterns.each do |pattern|
    solution = apply_symbolic_reasoning(input_grid, pattern)
    solutions << solution if valid_solution?(solution)
  end
  solutions.first
end

# Embed cognitive priors
def embed_cognitive_priors(grid)
  # Implement cognitive priors like symmetry and repetition
  grid
end

# Define the model
def setup_model
  model = TensorFlow::Keras::Models::Sequential.new
  model.add(TensorFlow::Keras::Layers::Dense.new(128, activation: 'relu', input_shape: [4]))
  model.add(TensorFlow::Keras::Layers::Dense.new(256, activation: 'relu'))
  model.add(TensorFlow::Keras::Layers::Dense.new(512, activation: 'relu'))
  model.add(TensorFlow::Keras::Layers::Dense.new(36, activation: 'softmax'))
  model.compile(optimizer: 'adam', loss: 'sparse_categorical_crossentropy', metrics: ['accuracy'])
  model
end

def train_model(model, inputs, outputs)
  train_inputs = TensorFlow::Convert.to_tensor(inputs)
  train_outputs = TensorFlow::Convert.to_tensor(outputs)

  model.fit(train_inputs, train_outputs, epochs: 50)
end

train_model(setup_model, train_data)

test_data.each do |test|
  input = test["input"]
  input = embed_cognitive_priors(input)
  output = find_solution(input, model)
  puts JSON.pretty_generate(output)
end
