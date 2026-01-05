defmodule RiotTakeHomeChallengeWeb.Router do
  use RiotTakeHomeChallengeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RiotTakeHomeChallengeWeb do
    pipe_through :api

    post "/encrypt", EncryptionController, :encrypt
    post "/decrypt", EncryptionController, :decrypt
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:riot_take_home_challenge, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: RiotTakeHomeChallengeWeb.Telemetry
    end
  end
end
