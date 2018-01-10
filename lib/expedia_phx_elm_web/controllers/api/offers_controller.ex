defmodule ExpediaPhxElmWeb.Api.OffersController do
  use ExpediaPhxElmWeb, :controller

  @deals_uri "https://offersvc.expedia.com/offers/v2/getOffers?scenario=deal-finder&page=foo&uid=foo&productType=Hotel"

  plug :get_expedia_offers

  def index(conn, _params) do
    send_resp conn, 200, conn.assigns.payload
  end

  defp get_expedia_offers conn, _opts do
    %{body: payload} = HTTPoison.get!(@deals_uri)
      
    conn
    |> assign(:payload, payload)
  end
end
