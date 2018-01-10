defmodule ExpediaPhxElmWeb.PageController do
  use ExpediaPhxElmWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
