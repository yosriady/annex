defmodule NeuralNetwork.Network do
  @moduledoc """
    This module implements a feed-forward artifical neural network with backpropagation.
  """

  alias NeuralNetwork.Random
  alias NeuralNetwork.Neuron

  defstruct [:sizes, :biases, :weights]

  @type t :: %NeuralNetwork.Network{
    sizes: list(pos_integer), # size of layers i.e. [2,3,1]
    biases: list(list(float)),
    weights: list(list(float))
  }

  @doc """
    Creates a new neural network.
  """
  def new(sizes) do
    weighted_layers = Enum.drop(sizes, 1) # layers except the input layer
    layers_except_output = Enum.drop(sizes, -1)
    %NeuralNetwork.Network{
      sizes: sizes,
      # biases is a list of lists, one list per layer, where each list
      # stores the biases of nodes in that layer
      biases: (for n <- weighted_layers, do: Random.randn(n, 1)),
      # weights is a list of matrices. Given a network of layer sizes [2,3,1] and
      # neurons `A`, `B` in the first layer & neurons  `1`, `2`, `3` in the second
      # we have:
      #
      # Enum.at(weights, 0)
      # > [
      #   [A1, B1],
      #   [A2, B2],
      #   [A3, B3]
      # ]
      #
      # A1 is the incoming edge from the first layer neuron `A` to
      # the second layer neuron `1`
      weights: (for tuple <- Enum.zip(layers_except_output, weighted_layers), do: Random.randn(elem(tuple, 1), elem(tuple, 0)))
    }
  end


  @doc """
    Calculates the outputs of each neuron layer by layer,
    where inputs is a vector of size equal to the size of the (first) input layer

    Returns a vector of size equal to the size of the (final) output layer
  """
  def feedforward(%NeuralNetwork.Network{sizes: sizes, biases: biases, weights: weights}, inputs)
  when length(inputs) == hd(sizes) do
    weighted_layers = Enum.drop(sizes, 1)
    _feedforward(weights, biases, weighted_layers, inputs)
  end

  # Feedforward algorithm Base case
  defp _feedforward([], [], [], inputs) do
     inputs
  end

  # Feedforward algorithm Recursive case
  defp _feedforward([layer_weights | remaining_weights],
                    [layer_biases | remaining_biases],
                    [layer_size | remaining_layers],
                    inputs) do
    # Activate the current layer of neurons, returning a vector of outputs
    layer_outputs = 0..(layer_size - 1)
    |> Enum.map(fn(i) -> Neuron.new(Enum.at(layer_weights, i), Enum.at(Enum.at(layer_biases, i), 0)) end)
    |> Enum.map(fn(n) -> Neuron.activate(n, inputs) end)

    # We recursively feedforward to the next layers
    _feedforward(remaining_weights,
                 remaining_biases,
                 remaining_layers,
                 layer_outputs)
  end


  @doc """
    Trains a neural network.

    The network will train until the training error has gone below the threshold or
    the max number of iterations (default 20000) has been reached, whichever comes first.
  """
  def train() do
    # TODO
  end

  @doc """
    Traverse the network for a given input and return a result.
  """
  def run() do
    # TODO
  end
end
