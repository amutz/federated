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

  def update(conn, %{"id" => id, "submission" => submission_params}) do
    submission = Repo.get!(Submission, id)
    changeset = Submission.changeset(submission, submission_params)

    if changeset.valid? do
      submission = Repo.update!(changeset)
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
end
