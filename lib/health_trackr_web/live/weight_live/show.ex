defmodule HealthTrackrWeb.WeightLive.Show do
  use HealthTrackrWeb, :live_view

  alias HealthTrackr.Weights

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:weight, Weights.get_weight!(id))}
  end

  @doc """
    When using petal component, parent has to handle the close_modal to return to correct route.
  """
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: Routes.weight_show_path(socket, :show, socket.assigns.weight))}
  end

  defp page_title(:show), do: "Show Weight"
  defp page_title(:edit), do: "Edit Weight"
end
