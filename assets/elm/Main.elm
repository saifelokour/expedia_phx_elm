module Main exposing (..)
import Html exposing (Html, text, div)
import Html.Attributes exposing (class)
import Components.Offers as Offers

-- MODEL

type alias Model =
  { offerListModel : Offers.Model }

initialModel : Model
initialModel =
  { offerListModel = Offers.initialModel }

init : (Model, Cmd Msg)
init =
  let
    ( updatedModel, cmd ) = update (OffersMsg Offers.Fetch) initialModel
  in
    ( initialModel, cmd )

-- UPDATE

type Msg
  = OffersMsg Offers.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    OffersMsg offerMsg ->
      let (updatedModel, cmd) = Offers.update offerMsg model.offerListModel
      in ( { model | offerListModel = updatedModel }, Cmd.map OffersMsg cmd )

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW

view : Model -> Html Msg
view model =
  div [ class "elm-app" ]
    [ Html.map OffersMsg (Offers.view model.offerListModel) ]

-- MAIN

main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }