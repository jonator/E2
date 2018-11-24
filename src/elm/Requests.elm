module Requests exposing (getCards, getCartItems, getCartItem)

import Coders exposing (..)
import Json.Decode as JD
import Http exposing (Error(..), emptyBody, jsonBody, Request, Body, request, expectString)
import Types exposing (Card, CartItem, Msg(..))
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


--Cards
getCards : (Result String (List Card) -> msg) -> Cmd msg
getCards hook =
    Http.get (fullPath ++ "cards") Coders.decodeCardList
        |> Http.send (processResult hook)

createCard : String -> String -> Int -> String -> Int -> ((Result String String) -> msg) -> Cmd msg
createCard title imageUrl cost category userId hook =
    Http.post (fullPath ++ "users") (jsonBody <| encodeNewCard title imageUrl cost category userId) JD.string
        |> Http.send (processResult hook)

updateCard : Int -> String -> String -> Int -> String -> Int -> ((Result String String) -> msg) -> Cmd msg
updateCard cardId title imageUrl cost category userId hook =
    Http.post (fullPath ++ "users") (jsonBody <| encodeUpdatedCard cardId title imageUrl cost category userId) JD.string
        |> Http.send (processResult hook)

--User
authenticateUser : String -> String -> (Result String String -> msg) -> Cmd msg
authenticateUser username password hook =
    Http.get (fullPath ++ "users/authenticate/" ++ username ++ "/" ++ password) JD.string
        |> Http.send (processResult hook)



--Cart
processCartResult : (Result String (List (CartItem Card)) -> msg) -> Result Http.Error (List ApiCartItem) -> msg
processCartResult message res =
    case res of
        Ok cart ->
            message <| Ok (List.map apiCartItemToElmCartItem cart)

        Err httpErr ->
            message <| Err <| httpErrToString httpErr

processCartItemResult : ((Result String (CartItem Card)) -> msg) -> Result Http.Error ApiCartItem -> msg
processCartItemResult message res =
    case res of
        Ok cartItem ->
            message <| Ok <| apiCartItemToElmCartItem cartItem

        Err httpErr ->
            message <| Err <| httpErrToString httpErr

getCartItems : Int -> (Result String (List (CartItem Card)) -> msg) -> Cmd msg
getCartItems cartId hook =
    Http.get (fullPath ++ "cartItems/" ++ (toString cartId)) Coders.decodeCartItemList
        |> Http.send (processCartResult hook)

getCartItem : Int -> Int -> ((Result String (CartItem Card)) -> msg) -> Cmd msg
getCartItem cartId cardId hook =
    Http.get (fullPath ++ "cartItems/" ++ (toString cartId) ++ "/" ++ (toString cardId)) Coders.decodeCartItem 
        |> Http.send (processCartItemResult hook)

deleteCartItems : Int -> ((Result String String) -> msg) -> Cmd msg
deleteCartItems cartId hook =
    deleteRequest (fullPath ++ "cartItems/" ++ (toString cartId))
        |> Http.send (processResult hook)

deleteCartItem : Int -> Int -> ((Result String String) -> msg) -> Cmd msg
deleteCartItem cartId cardId hook =
    deleteRequest (fullPath ++ "cartItems/" ++ (toString cartId) ++ "/" ++ (toString cardId))
        |> Http.send (processResult hook)

createCartItem : Int -> Int -> Int -> ((Result String String) -> msg) -> Cmd msg
createCartItem userId cardId quantity hook =
    Http.post (fullPath ++ "users/cartItems") (jsonBody <| encodeCartItem userId cardId quantity) JD.string
        |> Http.send (processResult hook)

updateCartItem : Int -> Int -> Int -> ((Result String String) -> msg) -> Cmd msg
updateCartItem userId cardId quantity hook =
    putRequest (fullPath ++ "users/cartItems") (jsonBody <| encodeCartItem userId cardId quantity)
        |> Http.send (processResult hook)

createUser : String -> String -> String -> String -> Bool -> ((Result String String) -> msg) -> Cmd msg
createUser firstName lastName email password isAdmin hook =
    Http.post (fullPath ++ "users") (jsonBody <| encodeUser firstName lastName email password isAdmin) JD.string
        |> Http.send (processResult hook)

--Resquest Types
deleteRequest : String -> Request String
deleteRequest url =
  request
    { method = "DELETE"
    , headers = []
    , url = url
    , body = emptyBody
    , expect = expectString
    , timeout = Nothing
    , withCredentials = False
    }

putRequest : String -> Body -> Request String
putRequest url body =
  request
    { method = "PUT"
    , headers = []
    , url = url
    , body = body
    , expect = expectString
    , timeout = Nothing
    , withCredentials = False
    }