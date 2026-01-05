defmodule RiotTakeHomeChallenge.EncryptionTest do
  use ExUnit.Case
  alias RiotTakeHomeChallenge.Encryption

  describe "encrypt!/2" do
    test "returns encrypted values for the given algorithm" do
      assert Encryption.encrypt!("world", :base64) == "IndvcmxkIg=="
    end

    test "raises UnavailableAlgorithm if algorithm is not supported" do
      assert_raise Encryption.UnavailableAlgorithm, fn ->
        Encryption.encrypt!("world", :weird_algo)
      end
    end
  end

  describe "decrypt!/2" do
    test "returns decrypted values for the given algorithm" do
      assert Encryption.decrypt!("IndvcmxkIg==", :base64) == "world"
    end

    test "returns unchanged data if the value is not encrypted with the specified algorithm" do
      assert Encryption.decrypt!("world", :base64) == "world"
    end

    test "returns unchanged data if the value is not a binary" do
      assert Encryption.decrypt!(%{hello: "world"}, :base64) == %{hello: "world"}
    end

    test "raises UnavailableAlgorithm if algorithm is not supported" do
      assert_raise Encryption.UnavailableAlgorithm, fn ->
        Encryption.decrypt!("world", :weird_algo)
      end
    end
  end
end
