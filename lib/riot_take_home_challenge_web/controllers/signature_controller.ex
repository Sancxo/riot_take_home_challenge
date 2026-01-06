defmodule RiotTakeHomeChallengeWeb.SignatureController do
  use RiotTakeHomeChallengeWeb, :controller
  alias RiotTakeHomeChallenge.Signature

  @algorithm Application.compile_env(:riot_take_home_challenge, :signature_algorithm)

  def sign(conn, params) do
    signature = Signature.sign!(params, @algorithm)

    json(conn, %{signature: signature})
  end

  def verify(conn, %{"data" => data, "signature" => signature}) do
    if Signature.verify!(data, signature, @algorithm) do
      send_resp(conn, 204, "")
    else
      send_resp(conn, 400, "Invalid signature.")
    end
  end

  def verify(conn, _params) do
    send_resp(
      conn,
      400,
      "The body request should be a JSON containing \"data\" and \"signature\" keys for its entries ; ex: {\"data\": {\"hello\": \"world\"}, \"signature\": \"abcdefghijkl...\"}"
    )
  end
end
