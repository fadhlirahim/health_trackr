defmodule HealthTrackr.Repo do
  use Ecto.Repo,
    otp_app: :health_trackr,
    adapter: Ecto.Adapters.Postgres
end
