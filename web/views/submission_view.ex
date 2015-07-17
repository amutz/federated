defmodule Federated.SubmissionView do
  use Federated.Web, :view

  use JSONAPI.PhoenixView

  def type, do: "submission"

  def attributes(model) do
    Map.take(model, [:id, :title, :link, :created_at])
  end

  def relationships() do
    %{}
  end

  def url_func() do
    &submission_url/3
  end
end
