module Assets exposing (..)

import Theme exposing (Theme(..))
import VitePluginHelper exposing (asset)


fabio320 =
    asset "/assets/img/fabio320.webp"


fabio640 =
    asset "/assets/img/fabio640.webp"


githubLogo theme =
    case theme of
        Light ->
            asset "/assets/img/github-mark.png"

        Dark ->
            asset "/assets/img/github-mark-white.png"
