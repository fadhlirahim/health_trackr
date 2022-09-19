defmodule HealthTrackr.Weights do
  @moduledoc """
  The Weights context.
  """

  import Ecto.Query, warn: false
  alias HealthTrackr.Repo

  alias HealthTrackr.Weights.Weight

  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(HealthTrackr.PubSub, @topic)
  end

  defp broadcast({:ok, server}, event) do
    Phoenix.PubSub.broadcast(
      HealthTrackr.PubSub,
      @topic,
      {event, server}
    )

    {:ok, server}
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  def list_weights(criteria) when is_list(criteria) do
    query = from(v in Weight)

    Enum.reduce(criteria, query, fn
      {:paginate, %{page: page, per_page: per_page}}, query ->
        from q in query,
          offset: ^((page - 1) * per_page),
          limit: ^per_page

      {:sort, %{sort_by: sort_by, sort_order: sort_order}}, query ->
        from q in query, order_by: [{^sort_order, ^sort_by}]
    end)
    |> Repo.all()
  end

  @doc """
  Returns the list of weights.

  ## Examples

      iex> list_weights()
      [%Weight{}, ...]

  """
  def list_weights do
    Repo.all(from(w in Weight, order_by: [asc: w.date]))
  end

  @doc """
  Gets a single weight.

  Raises `Ecto.NoResultsError` if the Weight does not exist.

  ## Examples

      iex> get_weight!(123)
      %Weight{}

      iex> get_weight!(456)
      ** (Ecto.NoResultsError)

  """
  def get_weight!(id), do: Repo.get!(Weight, id)

  @doc """
  Creates a weight.

  ## Examples

      iex> create_weight(%{field: value})
      {:ok, %Weight{}}

      iex> create_weight(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_weight(attrs \\ %{}) do
    %Weight{}
    |> Weight.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:weight_created)
  end

  @doc """
  Updates a weight.

  ## Examples

      iex> update_weight(weight, %{field: new_value})
      {:ok, %Weight{}}

      iex> update_weight(weight, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_weight(%Weight{} = weight, attrs) do
    weight
    |> Weight.changeset(attrs)
    |> Repo.update()
    |> broadcast(:weight_updated)
  end

  @doc """
  Deletes a weight.

  ## Examples

      iex> delete_weight(weight)
      {:ok, %Weight{}}

      iex> delete_weight(weight)
      {:error, %Ecto.Changeset{}}

  """
  def delete_weight(%Weight{} = weight) do
    Repo.delete(weight)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking weight changes.

  ## Examples

      iex> change_weight(weight)
      %Ecto.Changeset{data: %Weight{}}

  """
  def change_weight(%Weight{} = weight, attrs \\ %{}) do
    Weight.changeset(weight, attrs)
  end
end
