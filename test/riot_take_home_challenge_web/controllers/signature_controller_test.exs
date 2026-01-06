defmodule RiotTakeHomeChallengeWeb.SignatureControllerTest do
  use RiotTakeHomeChallengeWeb.ConnCase

  @test_payload_data %{"hello" => "world"}
  # The test environment uses a different secret key than development or production environments,
  # so the expected result cannot be the same.
  @test_signed_data <<195, 135, 195, 162, 115, 96, 195, 168, 7, 80, 195, 166, 63, 194, 154, 60,
                      194, 178, 195, 135, 195, 147, 195, 136, 56, 195, 144, 66, 40, 115, 24, 195,
                      181, 195, 171, 194, 190, 119, 195, 159, 194, 145, 12, 114, 194, 184, 86,
                      194, 177>>

  describe "POST /api/sign" do
    test "renders json payload with only a `signature` key", %{conn: conn} do
      conn = post(conn, ~p"/api/sign", @test_payload_data)

      assert Map.keys(json_response(conn, 200)) == ["signature"]
    end
  end

  describe "POST /api/verify" do
    test "renders 204 HTTP response if the `signature` value matches the `data` value", %{
      conn: conn
    } do
      conn =
        post(
          conn,
          ~p"/api/verify",
          %{
            "data" => @test_payload_data,
            "signature" => @test_signed_data
          }
        )

      assert conn.status == 204
    end

    test "renders 400 HTTP response with `Invalid signature.` if the `signature` value doesn't matches the `data` value",
         %{
           conn: conn
         } do
      conn =
        post(conn, ~p"/api/verify", %{
          "data" => @test_payload_data,
          "signature" => "bad_signature"
        })

      assert conn.status == 400
      assert conn.resp_body == "Invalid signature."
    end

    test "renders 400 HTTP response with a proper message if the the payload keys are not `data` and `signature`",
         %{
           conn: conn
         } do
      conn_1 =
        post(conn, ~p"/api/verify", %{
          "data" => @test_payload_data,
          "hash" => @test_signed_data
        })

      assert conn_1.status == 400

      assert conn_1.resp_body =~
               "The body request should be a JSON containing \"data\" and \"signature\" keys for its entries"

      conn_2 =
        post(conn, ~p"/api/verify", %{
          "payload" => @test_payload_data,
          "signature" => @test_signed_data
        })

      assert conn_2.status == 400

      assert conn_2.resp_body =~
               "The body request should be a JSON containing \"data\" and \"signature\" keys for its entries"
    end
  end

  describe "POST /api/sign then POST /api/verify" do
    test "renders 204 HTTP response", %{conn: conn} do
      first_conn = post(conn, ~p"/api/sign", @test_payload_data)

      resp = json_response(first_conn, 200)

      conn =
        post(conn, ~p"/api/verify", %{
          "data" => @test_payload_data,
          "signature" => resp["signature"]
        })

      assert conn.status == 204
    end
  end
end
