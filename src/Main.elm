module Main exposing (main)

import Browser
import Element exposing (Element, centerX, centerY, el, text)
import Element.Font as Font
import Html exposing (Html)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    ()


init : Model
init =
    ()


update : msg -> Model -> Model
update _ model =
    model


view : Model -> Html msg
view _ =
    Element.layout
        [ Font.family [ Font.typeface "Ubuntu", Font.sansSerif ] ]
        mainView


mainView : Element msg
mainView =
    el
        [ centerX
        , centerY
        ]
    <|
        text "Hello from Elm 👋🏻"
