defmodule RiotTakeHomeChallengeWeb.EncryptionController do
  use RiotTakeHomeChallengeWeb, :controller
  alias RiotTakeHomeChallenge.Encryption

  @algorithm Application.compile_env(:riot_take_home_challenge, :encryption_algorithm)

  def encrypt(conn, params) do
    payload =
      params
      |> Enum.map(fn {k, v} -> {k, Encryption.encrypt!(v, @algorithm)} end)
      |> Map.new()

    json(conn, payload)
  end

  def decrypt(conn, params) do
    payload =
      params
      |> Enum.map(fn {k, v} -> {k, Encryption.decrypt!(v, @algorithm)} end)
      |> Map.new()

    json(conn, payload)
  end
end
