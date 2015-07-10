defmodule Federated.CommunityController do
  use Federated.Web, :controller

  alias Federated.Community

  plug :scrub_params, "community" when action in [:create, :update]

  def index(conn, _params) do
    communities = Repo.all(Community)
    render(conn, "index.json", communities: communities)
  end

  def create(conn, %{"community" => community_params}) do
    changeset = Community.changeset(%Community{}, community_params)

    if changeset.valid? do
      community = Repo.insert!(changeset)
      render(conn, "show.json", community: community)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Federated.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    community = Repo.get!(Community, id)
    render conn, "show.json", community: community
  end

  def update(conn, %{"id" => id, "community" => community_params}) do
    community = Repo.get!(Community, id)
    changeset = Community.changeset(community, community_params)

    if changeset.valid? do
      community = Repo.update!(changeset)
      render(conn, "show.json", community: community)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Federated.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    community = Repo.get!(Community, id)

    community = Repo.delete!(community)
    render(conn, "show.json", community: community)
  end
end
