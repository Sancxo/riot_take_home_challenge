defmodule RiotTakeHomeChallengeWeb.EncryptionControllerTest do
  use RiotTakeHomeChallengeWeb.ConnCase

  describe "POST /api/encrypt" do
    test "renders json payload containing the same keys but not the same values", %{conn: conn} do
      conn =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post(~p"/api/encrypt", ~s({"hello": "world"}))

      resp = json_response(conn, 200)

      assert Map.has_key?(resp, "hello")
      refute resp["hello"] == "world"
    end
  end

  describe "POST /api/decrypt" do
    test "renders json payload containing the same keys but not the same values", %{conn: conn} do
      conn =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post(~p"/api/decrypt", ~s({"hello": "IndvcmxkIg=="}))

      resp = json_response(conn, 200)

      assert Map.has_key?(resp, "hello")
      refute resp["hello"] == "IndvcmxkIg=="
    end
  end

  describe "POST /api/encrypt then POST /api/decrypt" do
    test "renders the initial payload", %{conn: conn} do
      first_conn =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post(~p"/api/encrypt", ~s({"hello": "world"}))

      resp = json_response(first_conn, 200)

      second_conn =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post(~p"/api/decrypt", resp)

      new_resp = json_response(second_conn, 200)

      assert Map.has_key?(new_resp, "hello")
      assert new_resp["hello"] == "world"
    end
  end
end
