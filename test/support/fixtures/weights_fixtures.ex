defmodule HealthTrackr.WeightsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HealthTrackr.Weights` context.
  """

  @doc """
  Generate a weight.
  """
  def weight_fixture(attrs \\ %{}) do
    {:ok, weight} =
      attrs
      |> Enum.into(%{
        date: ~D[2022-09-11],
        weight: 120.5
      })
      |> HealthTrackr.Weights.create_weight()

    weight
  end
end
