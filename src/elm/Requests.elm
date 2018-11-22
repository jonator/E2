module Requests exposing (getCards)

import Decoders
import Http exposing (Error(..))
import Types exposing (Card, Msg(..))


authority =
    "http://localhost:3000/"


apiPath =
    "api/"


fullPath =
    authority ++ apiPath


getCardsUrl =
    fullPath ++ "cards"


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
    Http.get getCardsUrl Decoders.cardList
        |> Http.send (processResult hook)
