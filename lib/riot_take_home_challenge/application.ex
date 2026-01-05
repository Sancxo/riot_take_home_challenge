defmodule RiotTakeHomeChallenge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RiotTakeHomeChallengeWeb.Telemetry,
      {DNSCluster,
       query: Application.get_env(:riot_take_home_challenge, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: RiotTakeHomeChallenge.PubSub},
      # Start a worker by calling: RiotTakeHomeChallenge.Worker.start_link(arg)
      # {RiotTakeHomeChallenge.Worker, arg},
      # Start to serve requests, typically the last entry
      RiotTakeHomeChallengeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RiotTakeHomeChallenge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RiotTakeHomeChallengeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
