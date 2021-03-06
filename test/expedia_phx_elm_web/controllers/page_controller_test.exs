defmodule ExpediaPhxElmWeb.OffersControllerTest do
  use ExpediaPhxElmWeb.ConnCase

  test "GET /api/offers", %{conn: conn} do
    conn = get conn, "/api/offers"
    %{"offers" => %{"Hotel" => [ %{"destination" => dest} | _]}} = json_response(conn, 200)

    assert dest["regionID"] == "178286"
  end

  test "GET /api/offers with with single query", %{conn: conn} do
    conn = get conn, "/api/offers?destinationName=LA"
    %{"offers" => %{"Hotel" => [ %{"destination" => dest} | _]}} = json_response(conn, 200)

    assert dest["regionID"] == "178280"
  end

  test "GET /api/offers with multiple queries", %{conn: conn} do
    conn = get conn, "/api/offers?destinationName=LA&lengthOfStay=1"
    %{"offers" => %{
        "Hotel" => [ %{"offerDateRange" => range, "destination" => dest} | _]
        }
      } = json_response(conn, 200)

    assert range["lengthOfStay"] == 1
    assert dest["regionID"] == "178280"
  end
end
