module Requests exposing (getCards)

import Coders
import Json.Decode as JD
import Http exposing (Error(..))
import Types exposing (Card, Msg(..))
--https://package.elm-lang.org/packages/elm-lang/http/latest/Http
authority : String
authority =
    "http://localhost:3000/"


apiPath : String
apiPath =
    "api/"


fullPath : String
fullPath =
    authority ++ apiPath


httpErrToString : Http.Error -> String
httpErrToString err =
    case err of
        BadUrl url ->
            "Bad url: " ++ url

        Timeout ->
            "Timeout"

        NetworkError ->
            "Network Error"

        BadStatus resStr ->
            "Bad status"

        BadPayload str resStr ->
            "Bad payload"


processResult : (Result String a -> msg) -> Result Http.Error a -> msg
processResult message res =
    case res of
        Ok a ->
            message <| Ok a

        Err httpErr ->
            message <| Err <| httpErrToString httpErr


getCards : (Result String (List Card) -> msg) -> Cmd msg
getCards hook =
    Http.get (fullPath ++ "cards") Coders.decodeCardList
        |> Http.send (processResult hook)


authenticateUser : String -> String -> (Result String String -> msg) -> Cmd msg
authenticateUser username password hook =
    Http.get (fullPath ++ "users/authenticate/" ++ username ++ "/" ++ password) JD.string
        |> Http.send (processResult hook)

