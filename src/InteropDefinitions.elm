module InteropDefinitions exposing (Flags, FromElm, ToElm, interop)

import TsJson.Decode as TsDecode exposing (Decoder)
import TsJson.Encode as TsEncode exposing (Encoder)


interop :
    { toElm : Decoder ToElm
    , fromElm : Encoder FromElm
    , flags : Decoder Flags
    }
interop =
    { toElm = toElm
    , fromElm = fromElm
    , flags = flags
    }


type alias Flags =
    { width : Int
    , height : Int 
    }

type alias ToElm = {}

type alias FromElm = {}

fromElm : Encoder FromElm
fromElm =
    TsEncode.null


toElm : Decoder ToElm
toElm =
    TsDecode.null {}


flags : Decoder Flags
flags =
    TsDecode.succeed Flags
        |> TsDecode.andMap (TsDecode.field "width" TsDecode.int)
        |> TsDecode.andMap (TsDecode.field "height" TsDecode.int)
