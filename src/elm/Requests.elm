module Requests exposing (fetchColor)

import Decoders
import Http
import Task exposing (Task)
import Types exposing (Msg(..))


authority =
    "http://localhost:3000/"


path =
    "api/"


apiPath =
    authority ++ path


fetchColor : Cmd Msg
fetchColor =
    Http.get Json.Decode.string "http://localhost:3000/color"
        |> Task.perform HandleHttpError HandleNewColor


getCards : Cmd Msg
getCards =
    Http.get Decoders.cardListDecoder apiPath
        ++ "cards"
        |> Task.perform HandleHttpError
