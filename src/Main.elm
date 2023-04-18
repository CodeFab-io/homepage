module Main exposing (main)

import Browser exposing (Document)
import Browser.Events
import Element exposing (Element, centerX, centerY, column, el, fill, height, maximum, padding, paragraph, spacing, text, width)
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
phoneView _ =
    let
        scaled =
            Element.modular 16 1.25 >> round

        p =
            paragraph [ Font.size (scaled 2) ]
    in
    column
        [ width fill, height fill, spacing (scaled 1), padding (scaled 1) ]
        [ el [ Font.size (scaled 6) ] <| text "codefab.io"
        , p firstParagraph
        , p secondParagraph
        ]


desktopView : Model -> Element Msg
desktopView model =
    let
        scaled =
            Element.modular 16 1.25 >> round

        p =
            paragraph [ Font.size (scaled 3) ]
    in
    column
        [ width (fill |> maximum 800), height fill, spacing (scaled 1), padding (scaled 1), centerX ]
        [ el [ Font.size (scaled 6) ] <| text "codefab.io"
        , p firstParagraph
        , p secondParagraph
        ]


firstParagraph : List (Element msg)
firstParagraph =
    [ text "First line first line first line first line first line first line first line first line first line first line" ]


secondParagraph : List (Element msg)
secondParagraph =
    [ text "Second line second line second line second line second line second line second line second line second line second line" ]



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
