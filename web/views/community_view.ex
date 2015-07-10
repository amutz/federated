defmodule Federated.CommunityView do
  use Federated.Web, :view

  def render("index.json", %{communities: communities}) do
    %{data: render_many(communities, "community.json")}
  end

  def render("show.json", %{community: community}) do
    %{data: render_one(community, "community.json")}
  end

  def render("community.json", %{community: community}) do
    %{id: community.id}
  end
end
