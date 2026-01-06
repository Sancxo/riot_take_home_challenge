defmodule RiotTakeHomeChallenge.Algorithms.HMAC do
  @moduledoc """
  Module to sign and verify data with the HMAC algorithm.
  """

  @behaviour RiotTakeHomeChallenge.Signature

  @impl true
  @doc """
  HMAC signing function.

  ## Example:

      iex> sign!(%{"hello" => "world"})
      "a1b2c3d4e5f6g7h8i9j0.."
  """
  @spec sign!(map()) :: binary()
  def sign!(data) do
    :crypto.mac(:hmac, :sha256, get_secret_key(), Jason.encode!(data))
    |> :binary.bin_to_list()
    |> to_string()
  end

  @impl true
  @doc """
  HMAC signature verifying function.

  ## Example:

      iex> verify!(%{"hello" => "world"}, "a1b2c3d4e5f6g7h8i9j0..")
      true

      iex> verify!(%{"hi" => "there"}, "a1b2c3d4e5f6g7h8i9j0..")
      false
  """
  @spec verify!(map(), binary()) :: boolean()
  def verify!(data, signature), do: sign!(data) === signature

  # Returns the Phoenix secret key base set in runtime config file
  defp get_secret_key do
    config = Application.get_env(:riot_take_home_challenge, RiotTakeHomeChallengeWeb.Endpoint)

    config[:secret_key_base]
  end
end
