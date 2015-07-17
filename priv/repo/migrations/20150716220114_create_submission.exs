defmodule Federated.Repo.Migrations.CreateSubmission do
  use Ecto.Migration

  def change do
    create table(:submissions) do
      add :title, :string
      add :link, :string
      add :community_id, :integer
      timestamps
    end

  end
end
