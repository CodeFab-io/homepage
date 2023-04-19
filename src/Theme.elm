module Theme exposing (Theme(..), apply)

import Html exposing (a)


type Theme
    = Light
    | Dark


apply : { light : out, dark : out } -> Theme -> out
apply { light, dark } theme =
    case theme of
        Light ->
            light

        Dark ->
            dark
