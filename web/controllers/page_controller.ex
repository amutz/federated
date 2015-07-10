defmodule Federated.PageController do
  use Federated.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
