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
            (responsiveView model)
        ]
    }


responsiveView : Model -> Element Msg
responsiveView model =
    case (model |> Element.classifyDevice).class of
        Element.Phone ->
            model |> phoneView

        Element.Tablet ->
            model |> desktopView

        Element.Desktop ->
            model |> desktopView

        Element.BigDesktop ->
            model |> desktopView


phoneView : Model -> Element Msg
phoneView model =
    el
        [ centerX
        , centerY
        ]
    <|
        text "📱 This is the phone view"


desktopView : Model -> Element Msg
desktopView model =
    el
        [ centerX
        , centerY
        ]
    <|
        text "💻 This is the desktop view"



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
