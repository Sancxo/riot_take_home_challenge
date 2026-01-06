defmodule RiotTakeHomeChallengeWeb.SignatureTest do
  use ExUnit.Case
  alias RiotTakeHomeChallenge.Signature

  @test_payload_data %{"hello" => "world"}
  # The test environment uses a different secret key than development or production environments,
  # so the expected result cannot be the same.
  @test_signed_data <<195, 135, 195, 162, 115, 96, 195, 168, 7, 80, 195, 166, 63, 194, 154, 60,
                      194, 178, 195, 135, 195, 147, 195, 136, 56, 195, 144, 66, 40, 115, 24, 195,
                      181, 195, 171, 194, 190, 119, 195, 159, 194, 145, 12, 114, 194, 184, 86,
                      194, 177>>

  describe "sign!/2" do
    test "returns hashed signature of the given data with the specified algorithm" do
      assert Signature.sign!(@test_payload_data, :hmac) == @test_signed_data
    end

    test "raises UnavailableSignatureAlgorithm if algorithm is not supported" do
      assert_raise Signature.UnavailableSignatureAlgorithm, fn ->
        Signature.sign!(@test_payload_data, :weird_algo)
      end
    end
  end

  describe "verify!/3" do
    test "returns true if the signature matches the data" do
      assert Signature.verify!(@test_payload_data, @test_signed_data, :hmac) === true
    end

    test "returns false if the signature doesn't match the data" do
      assert Signature.verify!(%{"bad" => "data"}, @test_signed_data, :hmac) === false
    end

    test "raises UnavailableSignatureAlgorithm if algorithm is not supported" do
      assert_raise Signature.UnavailableSignatureAlgorithm, fn ->
        Signature.verify!(@test_payload_data, @test_signed_data, :weird_algo)
      end
    end
  end
end
