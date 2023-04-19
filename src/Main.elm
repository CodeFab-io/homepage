module Main exposing (main)

import Assets
import Browser exposing (Document)
import Browser.Events
import Colors
import Element exposing (Element, alignRight, alignTop, centerX, column, el, fill, fillPortion, height, inFront, link, maximum, minimum, newTabLink, none, padding, paddingEach, paddingXY, paragraph, pointer, px, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Html.Attributes exposing (title)
import InteropPorts
import Json.Decode
import Theme exposing (Theme(..))


type alias Model =
    { width : Int
    , height : Int
    , theme : Theme
    }


type Msg
    = OnResize Int Int
    | ToggleTheme


type alias TextUtils msg =
    { scaled : Int -> Int
    , normal : String -> Element msg
    , semiBold : String -> Element msg
    , italic : String -> Element msg
    }


init : Json.Decode.Value -> ( Model, Cmd Msg )
init flags =
    let
        defaultTheme =
            Light
    in
    case InteropPorts.decodeFlags flags of
        Err _ ->
            ( { width = 1000
              , height = 1000
              , theme = defaultTheme
              }
            , Cmd.none
            )

        Ok decodedFlags ->
            ( { width = decodedFlags.width
              , height = decodedFlags.height
              , theme = defaultTheme
              }
            , Cmd.none
            )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnResize width height ->
            ( { model | width = width, height = height }, Cmd.none )

        ToggleTheme ->
            ( case model.theme of
                Light ->
                    { model | theme = Dark }

                Dark ->
                    { model | theme = Light }
            , Cmd.none
            )


view : Model -> Document Msg
view model =
    { title = "codefab.io"
    , body =
        [ Element.layout
            [ width fill
            , Font.family [ Font.typeface "Ubuntu", Font.sansSerif ]
            , Background.color <| Colors.white model.theme
            , Font.color <| Colors.dark model.theme
            ]
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

        textUtils =
            { scaled = scaled
            , semiBold = el [ Font.size (scaled 1), Font.semiBold ] << text
            , italic = el [ Font.size (scaled 1), Font.italic ] << text
            , normal = el [ Font.size (scaled 1) ] << text
            }
    in
    column
        [ width fill, height fill, spacing (scaled 1), padding (scaled 1) ]
        [ el [ Font.size (scaled 6) ] <| text "codefab.io"
        , column [ spacing (scaled 1) ] <| paragraphs textUtils
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

        textUtils =
            { scaled = scaled
            , semiBold = el [ Font.size (scaled 2), Font.semiBold ] << text
            , italic = el [ Font.size (scaled 2), Font.italic ] << text
            , normal = el [ Font.size (scaled 2) ] << text
            }
    in
    column
        [ width fill
        , height fill
        , inFront <|
            el
                [ width fill, padding (scaled 1) ]
            <|
                desktopSidebarView { scaled = scaled, sidebarWidth = sidebarWidth } model
        ]
        [ row
            [ padding (scaled 1)
            , width fill
            , Background.color <| Colors.navbarBackground model.theme
            ]
            [ el
                [ centerX
                , width <| (fillPortion 3 |> maximum mainContentMaxWidth)
                , Font.size (scaled 4)
                , Font.color <| Colors.navbarText model.theme
                , Font.shadow { offset = ( 0, 3 ), blur = 10, color = Element.rgb255 0 0 0 }
                ]
              <|
                text "codefab.io"
            ]
        , el [ width fill, height <| px 10, Background.gradient { angle = pi, steps = [ Colors.navbarBackground model.theme, Colors.navbarBackgroundShadow model.theme ] } ] none
        , row
            [ centerX, width <| (fillPortion 3 |> maximum mainContentMaxWidth) ]
            [ column
                [ width <| (fillPortion 3 |> maximum (mainContentMaxWidth - sidebarWidth - modularNormal)), spacing (scaled 1) ]
                [ column [ width fill, height fill, spacing (scaled 1), paddingXY modularNormal modularNormal ] <|
                    paragraphs textUtils
                ]
            , column
                [ width <| (fillPortion 1 |> minimum (sidebarWidth + modularNormal)), alignTop ]
                []
            ]
        ]


desktopSidebarView : { scaled : Int -> Int, sidebarWidth : Int } -> Model -> Element Msg
desktopSidebarView { scaled, sidebarWidth } model =
    let
        withTitle =
            Element.htmlAttribute << title

        iconElement icon =
            el [ width <| px 24, height <| px 24, Background.image icon ] none

        iconWithLink { title, icon, url } =
            newTabLink [ withTitle title ] { url = url, label = iconElement icon }
    in
    column
        [ alignRight
        , spacing (scaled 1)
        , width (px sidebarWidth)
        , Font.size (scaled 1)
        , inFront <| el [ pointer, alignRight, Events.onClick ToggleTheme, padding (scaled -2), Element.htmlAttribute <| title "I have an idea:\ntoggle the theme color here" ] <| text "💡"
        ]
        [ el
            [ Border.shadow { offset = ( 0, 0 ), size = 5, blur = 10, color = Colors.navbarBackground model.theme }
            , width (px sidebarWidth)
            , height (px sidebarWidth)
            , Background.image Assets.fabio640
            , Border.rounded (sidebarWidth // 2)
            ]
            none
        , column [ centerX, spacing (scaled 1) ]
            [ column [ spacing (scaled -3) ]
                [ el [ centerX, Font.bold, Font.size (scaled 3) ] <| text "Fábio Beirão"
                , paragraph [ Font.center, Font.size (scaled -1) ] [ text "Freelancer, full-stack software architect and developer" ]
                ]
            , column [ centerX, spacing (scaled 1) ]
                [ row [ centerX, spacing (scaled -2) ]
                    [ iconWithLink { title = "linkedin.com", icon = Assets.linkedinLogo, url = "https://www.linkedin.com/in/fdbeirao/" }
                    , iconWithLink { title = "github.com", icon = Assets.githubLogo model.theme, url = "https://github.com/fdbeirao" }
                    , iconWithLink { title = "gitlab.com", icon = Assets.gitlabLogo, url = "https://gitlab.com/fdbeirao" }
                    , iconWithLink { title = "keybase.io", icon = Assets.keybaseLogo, url = "https://www.keybase.io/fdbeirao" }
                    ]
                , row [ centerX, spacing (scaled -2) ]
                    [ iconWithLink { title = "WhatsApp", icon = Assets.whatsappLogo, url = "https://wa.me/31640801406" }
                    , iconWithLink { title = "Telegram", icon = Assets.telegramLogo, url = "https://t.me/+31640801406" }
                    ]
                ]
            , newTabLink [ centerX ] { url = "mailto:fabio@codefab.io", label = text "fabio@codefab.io" }
            , newTabLink [ centerX ] { url = "tel:+31640801406", label = text "+31 6 40801406" }
            , el [ centerX ] <| text "📌 Netherlands"
            ]
        ]


paragraphs : TextUtils msg -> List (Element msg)
paragraphs t =
    let
        p =
            paragraph [ Font.size (t.scaled 3) ]
    in
    [ p
        [ el [ Font.bold, paddingEach { top = 0, left = 0, right = t.scaled -2, bottom = 0 } ] <| text "Welcome!"
        , t.normal "My name is Fábio Beirão. I am a software architect and developer at heart. I have had the amazing opportunity to collaborate in this constantly evolving field for over "
        , t.semiBold "12 years"
        , t.normal " now."
        ]
    , p
        [ t.normal "I am a"
        , t.semiBold " freelancer "
        , t.normal " since May 2022. I am originally from"
        , t.semiBold " Portugal "
        , t.normal "and I moved to the Netherlands in December 2015. Have I been able to learn Dutch meanwhile? All I can say is: "
        , t.italic <| quote "Het spijt me, ik praat geen Nederlands. Het is niet makkelijk. Tot ziens, dank je wel."
        , t.normal " (so: no, not that much)."
        ]
    , p
        [ t.semiBold "Technology-wise"
        , t.normal " my background has been in"
        , t.semiBold " dotnet (c#) "
        , t.normal " (started with .NET Framework 2.0, back in the day),"
        , t.semiBold " javascript/typescript "
        , t.normal "using both vanilla as well as more modern frameworks. "
        , t.normal "Throughout my career have have always been a "
        , t.semiBold "devop"
        , t.normal ", even before that was a word. I don't believe in building software that I don't follow-through to production. "
        , t.normal "It's the best way to learn, I might even say it's the only way."
        ]
    , p
        [ t.normal "This devops experience has made me change the way I approach development."
        , t.semiBold " Reliability "
        , t.normal "should never be underestimated. After one too many "
        , t.italic <| quote "undefined is not a function"
        , t.normal " or the dreaded "
        , t.italic <| quote "Unhandled Exception: System.NullReferenceException"
        , t.normal " (many of them caused by me, oops) I have started gravitating towards different languages and paradigms. Despite most of my previous carrer having been"
        , t.italic <| quote "object oriented"
        , t.normal " and imperative, in 2017 I had a ground-breaking pivotal moment when I decided to learn "
        , t.semiBold "Erlang"
        , t.normal ", "
        , t.semiBold "Elixir"
        , t.normal ", "
        , t.semiBold "Elm"
        , t.normal " and "
        , t.semiBold "Haskell"
        , t.normal ". These technologies have helped me understand and fully embrace "
        , t.semiBold "functional programming"
        , t.normal " as a tool to maximize code reliability. Don't get me wrong, it is not a silver bullet, but the trade-offs it brings are more than worth it (in my experience). "
        , t.normal "I wrote a " 
        , newTabLink [ pointer, Font.underline ] { url = "https://www.linkedin.com/pulse/one-problem-functional-programming-solved-me-reasoning-f%C3%A1bio-beir%C3%A3o", label = t.normal "small post" }
        , t.normal " about it back then."
        ]
    , p
        [ t.normal "📝 Write about AWS, Terraform, Orleans (actor model), Event Sourcing, DDD, Type-Driven development"
        ]
    ]


quote : String -> String
quote t =
    "“" ++ t ++ "”"



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize OnResize



-- MAIN


main : Program Json.Decode.Value Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
