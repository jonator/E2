module Requests exposing (fetchColor)

import Http
import Json.Decode exposing (Decoder)
import Task exposing (Task)
import Types exposing (Msg(..))


fetchColor : Cmd Msg
fetchColor =
    Http.get Json.Decode.string "http://localhost:3000/color"
        |> Task.perform HandleColorError HandleNewColor
