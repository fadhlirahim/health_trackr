defmodule HealthTrackr.Weights.Weight do
  use Ecto.Schema
  import Ecto.Changeset

  schema "weights" do
    field :date, :date
    field :weight, :float

    timestamps()
  end

  @doc false
  def changeset(weight, attrs) do
    weight
    |> cast(attrs, [:date, :weight])
    |> validate_required([:date, :weight])
  end
end
