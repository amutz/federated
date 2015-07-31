defmodule Federated.CommunityController do
  use Federated.Web, :controller

  alias Federated.Community

  plug :scrub_params, "community" when action in [:create, :update]

  def index(conn, _params) do
    communities = Repo.all(Community) |> Repo.preload(:submissions)
    render conn, "index.json", %{data: communities, params: _params}
  end

  def create(conn, %{"community" => community_params}) do
    changeset = Community.changeset(%Community{}, community_params)

    if changeset.valid? do
      community = Repo.insert!(changeset)
      render conn, "show.json", %{data: community}
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Federated.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"name" => name}) do
    community = Repo.get_by(Community, name: name)  
    unless community do
      community = Repo.insert(%Community{name: name})
    end
    community = community |> Repo.preload(:submissions)
 
    render conn, "show.json", %{data: community}
  end

  def update(conn, %{"name" => name, "community" => community_params}) do
    community = Repo.get_by!(Community, name: name)
    changeset = Community.changeset(community, community_params)

    if changeset.valid? do
      community = Repo.update!(changeset)
      render conn, "show.json", %{data: community}
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Federated.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"name" => name}) do
    community = Repo.get_by!(Community, name: name)

    community = Repo.delete!(community)
    render conn, "show.json", %{data: community}
  end
end

