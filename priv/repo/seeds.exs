# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HealthTrackr.Repo.insert!(%HealthTrackr.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias HealthTrackr.Repo
alias HealthTrackr.Weights.Weight

for _i <- 1..30 do
  %Weight{
    date: Faker.Date.forward(30),
    weight: :rand.uniform * 100 |> Float.round(2),
  }
  |> Repo.insert!()
end
