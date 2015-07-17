defmodule Federated.SubmissionControllerTest do
  use Federated.ConnCase

  alias Federated.Submission
  @valid_attrs %{link: "some content", title: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, submission_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    submission = Repo.insert! %Submission{}
    conn = get conn, submission_path(conn, :show, submission)
    assert json_response(conn, 200)["data"] == %{
      "id" => submission.id
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, submission_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, submission_path(conn, :create), submission: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Submission, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, submission_path(conn, :create), submission: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    submission = Repo.insert! %Submission{}
    conn = put conn, submission_path(conn, :update, submission), submission: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Submission, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    submission = Repo.insert! %Submission{}
    conn = put conn, submission_path(conn, :update, submission), submission: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    submission = Repo.insert! %Submission{}
    conn = delete conn, submission_path(conn, :delete, submission)
    assert json_response(conn, 202)["data"]["id"]
    refute Repo.get(Submission, submission.id)
  end
end
