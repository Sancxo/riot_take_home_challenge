defmodule RiotTakeHomeChallenge.Encryption do
  @moduledoc """
  Behaviour module used to redirected to the proper encoding/decoding module
  for a specified algorithm, based on its name on the `modules_registry` module
  attribute

  Currently supported encoding algorithms:
    - base64
  """

  alias RiotTakeHomeChallenge.Encoders

  @callback encrypt!(data :: binary()) :: binary()
  @callback decrypt!(data :: binary()) :: binary()

  @modules_registry %{
    base64: Encoders.Base64
  }

  @avalaible_algorithms_list Map.keys(@modules_registry)

  defmodule UnavailableAlgorithm, do: defexception([:message])

  @spec encrypt!(binary(), atom()) :: binary()
  @doc """
  Multi-algorithm encoding function.

  ## Example:

      iex> encrypt!("hello", :base64)
      "aGVsbG8="

      iex> encrypt!("hello", :wrong_algo)
      ** (UnavailableAlgorithm)
  """
  def encrypt!(data, algorithm) when algorithm in @avalaible_algorithms_list,
    do: @modules_registry[algorithm].encrypt!(data)

  def encrypt!(_data, algorithm),
    do:
      raise(
        UnavailableAlgorithm,
        "Encoder not found for #{algorithm} algorithm, here is a list of available encoders: #{inspect(@avalaible_algorithms_list)}"
      )

  @doc """
  Multi-algorithm decoding function.

  ## Example:

      iex> decrypt!("aGVsbG8=", :base64)
      "hello"

      iex> decrypt!("aGVsbG8=", :wrong_algo)
      ** (UnavailableAlgorithm)
  """

  @spec decrypt!(binary(), atom()) :: binary()
  def decrypt!(data, algorithm) when algorithm in @avalaible_algorithms_list,
    do: @modules_registry[algorithm].decrypt!(data)

  def decrypt!(_data, algorithm),
    do:
      raise(
        UnavailableAlgorithm,
        "Decoder not found for #{algorithm} algorithm, here is a list of available decoders: #{inspect(@avalaible_algorithms_list)}"
      )
end
