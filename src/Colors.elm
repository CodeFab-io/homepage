module Colors exposing (..)

import Element exposing (Color, rgb255, rgba255)
import Theme exposing (Theme(..))


navbarBackground : Theme -> Color
navbarBackground =
    Theme.apply
        { light = rgb255 120 120 120
        , dark = rgb255 50 50 50
        }


navbarBackgroundShadow : Theme -> Color
navbarBackgroundShadow =
    Theme.apply
        { light = rgba255 255 255 255 0.2
        , dark = rgba255 30 30 30 0.2
        }


navbarText : Theme -> Color
navbarText =
    Theme.apply
        { light = rgb255 250 250 250
        , dark = rgb255 250 250 250
        }


dark : Theme -> Color
dark =
    Theme.apply
        { light = rgb255 25 25 25
        , dark = rgb255 255 255 255
        }


white : Theme -> Color
white =
    Theme.apply
        { light = rgb255 225 225 225
        , dark = rgb255 30 30 30
        }

