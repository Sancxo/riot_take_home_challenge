defmodule RiotTakeHomeChallenge.Encryption do
  @moduledoc """
  Behaviour module used to redirected to the proper encoding/decoding module
  for a specified algorithm, based on its name on the `modules_registry` module
  attribute

  Currently supported encoding algorithms:
    - base64
  """

  alias RiotTakeHomeChallenge.Algorithms

  @callback encrypt!(data :: binary()) :: binary()
  @callback decrypt!(data :: binary()) :: binary()

  @modules_registry %{
    base64: Algorithms.Base64
  }

  @avalaible_algorithms_list Map.keys(@modules_registry)

  defmodule UnavailableEncryptionAlgorithm, do: defexception([:message])

  @spec encrypt!(binary(), atom()) :: binary()
  @doc """
  Multi-algorithm encoding function.

  ## Example:

      iex> encrypt!("hello", :base64)
      "aGVsbG8="

      iex> encrypt!("hello", :wrong_algo)
      ** (UnavailableEncryptionAlgorithm)
  """
  def encrypt!(data, algorithm) when algorithm in @avalaible_algorithms_list,
    do: @modules_registry[algorithm].encrypt!(data)

  def encrypt!(_data, algorithm),
    do:
      raise(
        UnavailableEncryptionAlgorithm,
        "Encryption algorithm #{algorithm} not found to encrypt, here is a list of available algorithms: #{inspect(@avalaible_algorithms_list)}"
      )

  @doc """
  Multi-algorithm decoding function.

  ## Example:

      iex> decrypt!("aGVsbG8=", :base64)
      "hello"

      iex> decrypt!("aGVsbG8=", :wrong_algo)
      ** (UnavailableEncryptionAlgorithm)
  """

  @spec decrypt!(binary(), atom()) :: binary()
  def decrypt!(data, algorithm) when algorithm in @avalaible_algorithms_list,
    do: @modules_registry[algorithm].decrypt!(data)

  def decrypt!(_data, algorithm),
    do:
      raise(
        UnavailableEncryptionAlgorithm,
        "Encryption algorithm #{algorithm} not found to decrypt, here is a list of available algorithms: #{inspect(@avalaible_algorithms_list)}"
      )
end
