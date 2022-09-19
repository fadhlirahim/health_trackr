defmodule HealthTrackrWeb.PageController do
  use HealthTrackrWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
