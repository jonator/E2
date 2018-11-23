module Requests exposing (getCards)

import Coders
import Http exposing (Error(..))
import Types exposing (Card, Msg(..))

--https://package.elm-lang.org/packages/elm-lang/core/1.0.0/Http

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
