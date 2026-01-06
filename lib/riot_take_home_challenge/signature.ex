defmodule RiotTakeHomeChallenge.Signature do
  @moduledoc """
  Behaviour module used to redirected to the proper signing/verifying module
  for a specified algorithm, based on its name on the `modules_registry` module
  attribute

  Currently supported encoding algorithms:
    - hmac
  """

  alias RiotTakeHomeChallenge.Algorithms

  @callback sign!(data :: map()) :: binary()
  @callback verify!(data :: map(), signature :: binary()) :: boolean()

  @modules_registry %{
    hmac: Algorithms.HMAC
  }

  @avalaible_algorithms_list Map.keys(@modules_registry)

  defmodule UnavailableSignatureAlgorithm, do: defexception([:message])

  @spec sign!(map(), atom()) :: binary() | UnavailableSignatureAlgorithm
  @doc """
  Multi-algorithm signing function. Returns the hashed signature of the given data
  for a specific algorithm or raises if the algorithm is not supported.

  ## Example:

      iex> sign!(%{"hello" => "world"}, :hmac)
      "a1b2c3d4e5f6g7h8i9j0..."

      iex> sign!(%{"hello" => "world"}, :wrong_algo)
      ** (UnavailableSignatureAlgorithm)
  """
  def sign!(data, algorithm) when algorithm in @avalaible_algorithms_list,
    do: @modules_registry[algorithm].sign!(data)

  def sign!(_data, algorithm),
    do:
      raise(
        UnavailableSignatureAlgorithm,
        "Signature algorithm #{algorithm} not found to sign, here is a list of available algorithms: #{inspect(@avalaible_algorithms_list)}"
      )

  @spec verify!(map(), binary(), atom()) :: boolean() | UnavailableSignatureAlgorithm
  @doc """
  Multi-algorithm verifying function. Returns a boolean to indicate if the signature
  correspond to the given data or not.

  ## Example:

      iex> verify!(%{"hello" => "world"}, "a1b2c3d4e5f6g7h8i9j0...", :hmac)
      true

      iex> verify!(%{"hi" => "there"}, "a1b2c3d4e5f6g7h8i9j0...", :hmac)
      false

      iex> verify!(%{"hello" => "world"}, "a1b2c3d4e5f6g7h8i9j0...", :wrong_algo)
      ** (UnavailableSignatureAlgorithm)
  """
  def verify!(data, signature, algorithm) when algorithm in @avalaible_algorithms_list,
    do: @modules_registry[algorithm].verify!(data, signature)

  def verify!(_data, _signature, algorithm),
    do:
      raise(
        UnavailableSignatureAlgorithm,
        "Signature algorithm #{algorithm} not found to verify, here is a list of available algorithms: #{inspect(@avalaible_algorithms_list)}"
      )
end
