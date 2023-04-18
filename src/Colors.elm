module Colors exposing (..)

import Element exposing (Color, rgb255, rgba255)
import Theme exposing (Theme(..))


navbarBackground : Theme -> Color
navbarBackground =
    themed
        { l = rgb255 120 120 120
        , d = rgb255 50 50 50
        }


navbarBackgroundShadow : Theme -> Color
navbarBackgroundShadow =
    themed
        { l = rgba255 255 255 255 0.2
        , d = rgba255 30 30 30 0.2
        }


navbarText : Theme -> Color
navbarText =
    themed
        { l = rgb255 250 250 250
        , d = rgb255 250 250 250
        }


dark : Theme -> Color
dark =
    themed
        { l = rgb255 25 25 25
        , d = rgb255 255 255 255
        }


white : Theme -> Color
white =
    themed
        { l = rgb255 225 225 225
        , d = rgb255 30 30 30
        }


themed : { l : Color, d : Color } -> Theme -> Color
themed { l, d } theme =
    case theme of
        Light ->
            l

        Dark ->
            d
