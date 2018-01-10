defmodule ExpediaPhxElmWeb.Router do
  use ExpediaPhxElmWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExpediaPhxElmWeb do
    pipe_through :browser 

    get "/", PageController, :index
  end

  scope "/api", ExpediaPhxElmWeb.Api do
    pipe_through :api

    get "/offers", OffersController, :index
  end
end
