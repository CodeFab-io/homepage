module Main exposing (main)

import Assets
import Browser exposing (Document)
import Browser.Events
import Element exposing (Element, alignRight, alignTop, centerX, centerY, column, el, fill, fillPortion, height, inFront, maximum, minimum, none, padding, paragraph, px, rgb255, rgba255, row, scrollbarY, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
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
            [ width fill, Font.family [ Font.typeface "Ubuntu", Font.sansSerif ] ]
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
desktopView _ =
    let
        scaled =
            Element.modular 16 1.25 >> round

        p =
            paragraph [ Font.size (scaled 3) ]
    in
    column
        [ width fill
        , inFront <|
            row
                [ width fill, padding (scaled 1) ]
                [ el [ alignRight, Border.shadow { offset = ( 0, 0 ), size = 5, blur = 10, color = rgb255 100 100 100 }, width (px 200), height (px 200), Background.image Assets.fabio640, Border.rounded 100 ] none ]
        ]
        [ column
            [ padding (scaled 1)
            , width fill
            , Background.color <| rgb255 100 100 100
            ]
            [ el [ centerX, width <| (fillPortion 3 |> maximum 800), Font.size (scaled 6), Font.color <| rgb255 255 255 255 ] <|
                text "codefab.io"
            ]
        , el [ width fill, height <| px 10, Background.gradient { angle = pi, steps = [ rgb255 100 100 100, rgba255 255 255 255 0.1 ] } ] none
        , row
            [ centerX, width <| (fillPortion 3 |> maximum 800) ]
            [ column
                [ width <| (fillPortion 3 |> maximum 580), spacing (scaled 1) ]
                [ column [ width fill, height fill ]
                    [ p firstParagraph
                    , p secondParagraph
                    ]
                ]
            , column
                [ width <| (fillPortion 1 |> minimum 220), alignTop ]
                []
            ]
        ]


firstParagraph : List (Element msg)
firstParagraph =
    [ text <| String.repeat 50 "First line " ]


secondParagraph : List (Element msg)
secondParagraph =
    [ text <| String.repeat 500 "Second line " ]



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
