module Assets exposing (..)

import Theme exposing (Theme(..))
import VitePluginHelper exposing (asset)


fabio320 =
    asset "/assets/img/fabio320.webp"


fabio640 =
    asset "/assets/img/fabio640.webp"


linkedinLogo =
    asset "/assets/img/LinkedInLogo.webp"


keybaseLogo =
    asset "/assets/img/KeyBaseLogo.webp"


gitlabLogo =
    asset "/assets/img/GitLabLogo.webp"


emailIcon =
    Theme.apply
        { light = asset "/assets/img/EmailLight.webp"
        , dark = asset "/assets/img/EmailDark.webp"
        }


whatsappLogo =
    asset "/assets/img/WhatsappGreenLogo.webp"

telegramLogo =
    asset "/assets/img/TelegramLogo.webp"



githubLogo =
    Theme.apply
        { light = asset "/assets/img/github-mark.png"
        , dark = asset "/assets/img/github-mark-white.png"
        }
