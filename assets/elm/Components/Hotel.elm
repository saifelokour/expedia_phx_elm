module Hotel exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Json exposing (..)
import Http exposing (..)

type alias Model =
  { hotelInfo : HotelInfo
  , hotelUrls : HotelUrls
  , destination : Destination
  , hotelUrgencyInfo : HotelUrgencyInfo
  , hotelPricingInfo : HotelPricingInfo
  , offerDateRange : OfferDateRange
  }

type alias OfferDateRange =
  { lengthOfStay : Int
  , travelStartDate : List Int
  , travelEndDate : List Int
  }

decodeOfferDateRange : Json.Decoder OfferDateRange
decodeOfferDateRange = 
  Json.map3 
    OfferDateRange
    (Json.at ["lengthOfStay"] Json.int)
    (Json.at ["travelStartDate"] (Json.list int))
    (Json.at ["travelEndDate"] (Json.list int))

type alias Destination =
  { regionID : String
  , longName : String
  }

decodeDestination : Json.Decoder Destination
decodeDestination = 
  Json.map2
    Destination
    (Json.at ["regionID"] Json.string)
    (Json.at ["longName"] Json.string)

type alias HotelInfo =
  { hotelName : String
  , hotelStarRating : String
  , hotelImageUrl : String
  }

decodeHotelInfo : Json.Decoder HotelInfo
decodeHotelInfo = 
  Json.map3 
    HotelInfo
    (Json.at ["hotelName"] Json.string)
    (Json.at ["hotelStarRating"] Json.string)
    (Json.at ["hotelImageUrl"] Json.string)

type alias HotelUrgencyInfo =
  { numberOfRoomsLeft : Int
  , almostSoldStatus : String
  }

decodeHotelUrgencyInfo : Json.Decoder HotelUrgencyInfo
decodeHotelUrgencyInfo = 
  Json.map2
    HotelUrgencyInfo
    (Json.at ["numberOfRoomsLeft"] Json.int)
    (Json.at ["almostSoldStatus"] Json.string)

type alias HotelPricingInfo =
  { originalPricePerNight : Float
  , currency : String
  }

decodeHotelPricingInfo : Json.Decoder HotelPricingInfo
decodeHotelPricingInfo = 
  Json.map2
    HotelPricingInfo
    (Json.at ["originalPricePerNight"] Json.float)
    (Json.at ["currency"] Json.string)


type alias HotelUrls =
  { hotelInfositeUrl : String}

decodeHotelUrls : Json.Decoder HotelUrls
decodeHotelUrls = 
  Json.map 
    HotelUrls
    (Json.at ["hotelInfositeUrl"] Json.string)

view : Model -> Html a
view model =
  case Http.decodeUri model.hotelUrls.hotelInfositeUrl of
      Just url ->
          hotelView model url
      Nothing ->
        div [] []

hotelView : Model -> String -> Html a
hotelView model url =
  div [] [
      div [ class "col-sm" ] [ a [ href url ] [ img [src model.hotelInfo.hotelImageUrl] [] ] ]
    , div [ class "col-sm" ] [
            strong [] [text model.hotelInfo.hotelName]
          , br [] []
          , text ("location: " ++ model.destination.longName)
          , br [] []
          , text ("rating: " ++ model.hotelInfo.hotelStarRating)
          , br [] []
          , text ("price per night: " ++ toString model.hotelPricingInfo.originalPricePerNight ++ " " ++ model.hotelPricingInfo.currency)
          , br [] []
          , text ("Number of Rooms Left: " ++ toString model.hotelUrgencyInfo.numberOfRoomsLeft)
    ]
    , br [] []
  ]
