defmodule RiotTakeHomeChallengeWeb.EncryptionControllerTest do
  use RiotTakeHomeChallengeWeb.ConnCase

  describe "POST /api/encrypt" do
    test "renders json payload containing the same keys", %{conn: conn} do
      conn =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post(~p"/api/encrypt", ~s({"hello": "world"}))

      resp = json_response(conn, 200)

      assert Map.has_key?(resp, "hello")
    end
  end

  describe "POST /api/decrypt" do
    test "renders json payload containing the same keys", %{conn: conn} do
      conn =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post(~p"/api/decrypt", ~s({"hello": "world"}))

      resp = json_response(conn, 200)

      assert Map.has_key?(resp, "hello")
    end
  end
end
