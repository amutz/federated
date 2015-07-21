defmodule Federated.SubmissionController do
  use Federated.Web, :controller

  alias Federated.Submission
  
  def index(conn, _params) do
    submissions = Repo.all(Submission)
    render conn, "index.json", %{data: submissions, params: _params}
  end

  def create(conn, %{"data" => submission_params}) do
    changeset = Submission.changeset(%Submission{}, submission_params["attributes"], submission_params["relationships"])

    if changeset.valid? do
      submission = Repo.insert!(changeset)
      notify_created(submission)
      render conn, "show.json", %{data: submission}
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Federated.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    submission = Repo.get!(Submission, id)
    render conn, "show.json", %{data: submission}
  end

  def update(conn, %{"data" => submission_params}) do
    id = submission_params["id"]
    submission = Repo.get!(Submission, id)
    changeset = Submission.changeset(%Submission{id: elem(Integer.parse(id), 0)}, submission_params["attributes"], submission_params["relationships"])

    if changeset.valid? do
      submission = Repo.update!(changeset)
      notify_modified(submission)
      render conn, "show.json", %{data: submission}
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Federated.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    submission = Repo.get!(Submission, id)

    submission = Repo.delete!(submission)
    render conn, "show.json", %{data: submission}
  end

  def notify_modified(submission) do
    payload = Federated.SubmissionView |> JSONAPI.show(submission, nil, nil)
    Federated.Endpoint.broadcast! "submissions:#{submission.id}", "update", payload 
  end
  def notify_created(submission) do
    community = Repo.get_by!(Federated.Community, id: submission.community_id) |> Repo.preload(:submissions)

    payload = Federated.CommunityView |> JSONAPI.show(community, nil, nil)
    Federated.Endpoint.broadcast! "communities:#{community.id}", "update", payload 
  end
end
