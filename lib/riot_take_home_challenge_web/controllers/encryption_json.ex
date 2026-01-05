defmodule RiotTakeHomeChallengeWeb.EncryptionJSON do
  def encrypt(%{payload: payload}), do: payload
  def decrypt(%{payload: payload}), do: payload
end
