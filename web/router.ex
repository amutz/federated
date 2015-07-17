defmodule Federated.Router do
  use Federated.Web, :router
  
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json-api"]
  end

  scope "/", Federated do
    pipe_through :api
    
    resources "/communities", CommunityController, param: "name"
    resources "/submissions", SubmissionController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Federated do
  #   pipe_through :api
  # end
end
