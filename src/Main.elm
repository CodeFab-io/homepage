module Main exposing (main)

import Assets
import Browser exposing (Document)
import Browser.Events
import Colors
import Element exposing (Element, alignRight, alignTop, centerX, column, el, fill, fillPortion, height, inFront, maximum, minimum, newTabLink, none, padding, paddingXY, paragraph, px, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
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
desktopView model =
    let
        modularNormal =
            16

        scaled =
            Element.modular modularNormal 1.25 >> round

        

        mainContentMaxWidth =
            clamp 700 1000 model.width

        sidebarWidth =
            mainContentMaxWidth // 4

        p =
            paragraph [ Font.size (scaled 3) ]
    in
    column
        [ width fill
        , inFront <|
            el
                [ width fill, padding (scaled 1) ]
            <|
                desktopSidebarView { scaled = scaled, sidebarWidth = sidebarWidth }
        ]
        [ column
            [ padding (scaled 1)
            , width fill
            , Background.color Colors.navbarBackground
            ]
            [ el [ centerX, width <| (fillPortion 3 |> maximum mainContentMaxWidth), Font.size (scaled 6), Font.color Colors.white ] <|
                text "codefab.io"
            ]
        , el [ width fill, height <| px 10, Background.gradient { angle = pi, steps = [ Colors.navbarBackground, Colors.navbarBackgroundShadow ] } ] none
        , row
            [ centerX, width <| (fillPortion 3 |> maximum mainContentMaxWidth) ]
            [ column
                [ width <| (fillPortion 3 |> maximum (mainContentMaxWidth - sidebarWidth - modularNormal)), spacing (scaled 1) ]
                [ column [ width fill, height fill, spacing (scaled 1), paddingXY modularNormal modularNormal ]
                    [ p firstParagraph
                    , p secondParagraph
                    ]
                ]
            , column
                [ width <| (fillPortion 1 |> minimum (sidebarWidth + modularNormal)), alignTop ]
                []
            ]
        ]


desktopSidebarView : { scaled : Int -> Int, sidebarWidth : Int } -> Element msg
desktopSidebarView { scaled, sidebarWidth } =
    column [ alignRight, spacing (scaled 1), Font.size (scaled 1) ]
        [ el
            [ Border.shadow { offset = ( 0, 0 ), size = 5, blur = 10, color = Colors.navbarBackground }
            , width (px sidebarWidth)
            , height (px sidebarWidth)
            , Background.image Assets.fabio640
            , Border.rounded (sidebarWidth // 2)
            ]
            none
        , column [ centerX, spacing (scaled 1) ]
            [ newTabLink [] { url = "mailto:fabio@codefab.io", label = text "📧 fabio@codefab.io" }
            , newTabLink [] { url = "tel:+31640801406", label = text "☎️ +31 6 40801406" }
            ]
        ]


firstParagraph : List (Element msg)
firstParagraph =
    [ text <| String.repeat 50 "first line " ]


secondParagraph : List (Element msg)
secondParagraph =
    [ text <| String.repeat 500 "second line " ]



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
