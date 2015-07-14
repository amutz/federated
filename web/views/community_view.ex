defmodule Federated.CommunityView do
  use Federated.Web, :view
  use JSONAPI.PhoenixView

  def type, do: "community"

  def attributes(model) do
    Map.take(model, [:id, :name])
  end

  def relationships() do
    %{}
  end

  def url_func() do
    &community_url/3
  end
end
