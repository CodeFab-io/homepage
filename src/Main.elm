module Main exposing (main)

import Browser exposing (Document)
import Browser.Events
import Browser.Navigation as Nav
import Element exposing (Element, centerX, centerY, el, text)
import Element.Font as Font
import Html exposing (Html)
import InteropPorts
import Json.Decode


type alias Model =
    { width : Int
    , height : Int
    }


type Msg
    = OnResize Int Int


init : Json.Decode.Value -> ( Model, Cmd Msg )
init flags =
    case InteropPorts.decodeFlags flags of
        Err _ ->
            ( { width = 1000
              , height = 1000
              }
            , Cmd.none
            )

        Ok decodedFlags ->
            ( { width = decodedFlags.width
              , height = decodedFlags.height
              }
            , Cmd.none
            )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnResize width height ->
            ( { model | width = width, height = height }, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "codefab.io"
    , body =
        [ Element.layout
            [ Font.family [ Font.typeface "Ubuntu", Font.sansSerif ] ]
            (mainView model)
        ]
    }


mainView : Model -> Element Msg
mainView _ =
    el
        [ centerX
        , centerY
        ]
    <|
        text "Hello from Elm 👋🏻"



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize OnResize



-- MAIN


main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
