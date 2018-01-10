defmodule ExpediaPhxElmWeb.Api.OffersController do
  use ExpediaPhxElmWeb, :controller

  @deals_uri "https://offersvc.expedia.com/offers/v2/getOffers?scenario=deal-finder&page=foo&uid=foo&productType=Hotel"

  plug :get_expedia_offers

  def index(conn, _params) do
    send_resp conn, 200, conn.assigns.payload
  end

  defp get_expedia_offers %{query_params: query} = conn, _opts do
    encoded_query = URI.encode_query(query)
    %{body: payload} = HTTPoison.get!("#{@deals_uri}&#{encoded_query}")
      
    conn
    |> put_resp_header("content-type", "appilication/json")
    |> assign(:payload, payload)
  end
end
