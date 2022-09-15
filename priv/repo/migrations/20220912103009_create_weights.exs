defmodule HealthTrackr.Repo.Migrations.CreateWeights do
  use Ecto.Migration

  def change do
    create table(:weights) do
      add :date, :date
      add :weight, :float

      timestamps()
    end
  end
end
