defmodule ExpediaPhxElmWeb.OffersControllerTest do
  use ExpediaPhxElmWeb.ConnCase

  test "GET /api/offers", %{conn: conn} do
    conn = get conn, "/api/offers"
    %{"offers" => %{"Hotel" => [ %{"destination" => dest} | _]}} = json_response(conn, 200)

    assert dest["regionID"] == "178286"
  end

  test "GET /api/offers with query on destinationName", %{conn: conn} do
    conn = get conn, "/api/offers?destinationName=LA"
    %{"offers" => %{"Hotel" => [ %{"destination" => dest} | _]}} = json_response(conn, 200)

    assert dest["regionID"] == "178280"
  end
end
