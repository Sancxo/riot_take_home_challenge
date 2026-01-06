defmodule RiotTakeHomeChallenge.Algorithms.Base64 do
  @moduledoc """
  Module to encode and decode data with the Base64 algorithm.
  """
  @behaviour RiotTakeHomeChallenge.Encryption

  @impl true
  @spec encrypt!(binary()) :: binary()
  @doc """
  Base64 encoding function.

  ## Example:

      iex> encrypt!("hello")
      "aGVsbG8="
  """
  def encrypt!(data), do: data |> Jason.encode!() |> Base.encode64()

  @impl true
  @spec decrypt!(binary()) :: binary()
  @doc """
  Base64 decoding function. Returns unchanged input
  if it is not a valid Base64 encoded string.

  **IMPROV**: Updates to Elixir 1.19 and use the new `Base.valid64?/2` function to validate the input with better performances.

  ## Example:

      iex> decrypt!("aGVsbG8=")
      "hello"

      iex> decrypt!("hello")
      "hello"
  """
  def decrypt!(data) when is_binary(data) do
    case Base.decode64(data) do
      {:ok, decoded_binary} ->
        Jason.decode!(decoded_binary)

      :error ->
        data
    end
  end

  def decrypt!(data), do: data
end
