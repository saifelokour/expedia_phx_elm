module Components.Offers exposing (..)
import Html exposing (Html, text, ul, li, div, h2, button, br)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import List
import Hotel exposing (..)
import Http
import Json.Decode as Json exposing (..)
import Debug

type alias Model =
  { offers: List Hotel.Model }

type Msg
  = NoOp
  | Fetch
  | UpdateOffers (Result Http.Error (List Hotel.Model))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
    Fetch ->
      (model, fetchOffers)
    UpdateOffers result ->
      case result of
        Ok offers ->
          (Model offers, Cmd.none)
        Err error ->
          case error of
            Http.BadPayload errorMessage x ->
                Debug.log errorMessage
                (model, Cmd.none)
            _ ->
                (model, Cmd.none)

-- HTTP calls
fetchOffers : Cmd Msg
fetchOffers =
  let
    url = "/api/offers"
  in
    Http.send UpdateOffers (Http.get url decodeOffersFetch)

-- Fetch the offers out of the "offers" key
decodeOffersFetch : Json.Decoder (List Hotel.Model)
decodeOffersFetch =
  Json.at ["offers"] decodeHotelsFetch

-- Fetch the hotels out of the "hotel" key
decodeHotelsFetch : Json.Decoder (List Hotel.Model)
decodeHotelsFetch =
  Json.at ["Hotel"] decodeHotelList

-- Then decode the "hotel" key into a List of Hotel.Models
decodeHotelList : Json.Decoder (List Hotel.Model)
decodeHotelList =
  Json.list decodeHotelData

-- Finally, build the decoder for each individual Hotel.Model
decodeHotelData : Json.Decoder Hotel.Model
decodeHotelData = 
  Json.map6 
    Hotel.Model
    (Json.at ["hotelInfo"] Hotel.decodeHotelInfo)
    (Json.at ["hotelUrls"] Hotel.decodeHotelUrls)
    (Json.at ["destination"] Hotel.decodeDestination)
    (Json.at ["hotelUrgencyInfo"] Hotel.decodeHotelUrgencyInfo)
    (Json.at ["hotelPricingInfo"] Hotel.decodeHotelPricingInfo)
    (Json.at ["offerDateRange"] Hotel.decodeOfferDateRange)

renderOffer : Hotel.Model -> Html a
renderOffer hotel =
  div [ class "row" ] [ Hotel.view hotel ]

renderOffers : Model -> List (Html a)
renderOffers offers =
  List.map renderOffer offers.offers

initialModel : Model
initialModel =
  {offers = []}
      

view : Model -> Html Msg
view model =
  div [ class "container" ]
    [ h2 [] [ text "Offers" ]
    , br [] []
    , div [] (renderOffers model) ]
