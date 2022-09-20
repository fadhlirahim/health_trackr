defmodule HealthTrackrWeb.PageLive do
  use HealthTrackrWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, title: "Hello, World")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col">
      <.h2 class="!mb-0">Start Here</.h2>

      <div>
        <.link link_type="live_redirect"
               to={Routes.weight_index_path(@socket, :index)}
               class="no-underline hover:underline text-blue-100"
               label="Weight Tracker" />
      </div>
    </div>
    """
  end
end
