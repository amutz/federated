defmodule Federated.Submission do
  use Federated.Web, :model

  schema "submissions" do
    field :title, :string
    field :link, :string

    belongs_to :community, Federated.Community
    timestamps
  end

  @required_fields ~w(title link community_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, attributes \\ :empty, relationships \\ :empty) do
    model
    |> cast(attributes |> apply_relations(relationships), @required_fields, @optional_fields)
  end

  def apply_relations(attributes, relationships) do
    attributes |> Map.put "community_id", relationships["community"]["data"]["id"]
  end

end
