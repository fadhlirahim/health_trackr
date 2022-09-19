defmodule HealthTrackrWeb.WeightLive.Index do
  use HealthTrackrWeb, :live_view

  alias HealthTrackr.Weights
  alias HealthTrackr.Weights.Weight

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Weights.subscribe()

    labels = list_weights()
             |> Enum.map(fn ts -> ts.date end)

    values = list_weights()
             |> Enum.map(fn ts -> ts.weight end)

    {:ok,
     assign(socket,
       chart_data: %{
         labels: labels,
         values: values
       },
       current_reading: List.last(labels),
       weights: list_weights()
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Weight")
    |> assign(:weight, Weights.get_weight!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Weight")
    |> assign(:weight, %Weight{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Weights")
    |> assign(:weight, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    weight = Weights.get_weight!(id)
    {:ok, _} = Weights.delete_weight(weight)

    {:noreply, assign(socket, :weights, list_weights())}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: Routes.weight_index_path(socket, :index))}
  end

  defp list_weights do
    Weights.list_weights()
  end

  def handle_info({:weight_created, weight}, socket) do
    socket =
      update(
        socket,
        :weights,
        fn weights -> [weight | weights] end
      )

    {:noreply, update_chart(socket)}
  end

  def handle_info({:weight_updated, weight}, socket) do
    # Find the matching id in the current list of
    # data, change it, and update the list of data:
    socket =
      update(socket, :weights, fn weights ->
        for w <- weights do
          case w.id == weight.id do
            true -> weight
            _ -> w
          end
        end
      end)

    {:noreply, update_chart(socket)}
  end

  defp update_chart(socket) do
    push_event(socket, "update-chart", %{})
  end
end
