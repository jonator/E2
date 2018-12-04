module Requests exposing (..)

import Coders exposing (..)
import Json.Decode as JD
import Http exposing (Error(..), emptyBody, jsonBody, Request, Body, request, expectString)
import Types exposing (..)


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
    Http.get (fullPath ++ "cards/") Coders.decodeCardList
        |> Http.send (processResult hook)


getCard : Int -> (Result String Card -> msg) -> Cmd msg
getCard userId hook =
    Http.get (fullPath ++ "cards/" ++ (toString userId)) Coders.decodeCard
        |> Http.send (processResult hook)


createCard : String -> String -> Int  -> Int -> String -> (Result String String -> msg) -> Cmd msg
createCard title imageUrl cost costToProduce category hook =
    Http.post (fullPath ++ "cards/") (jsonBody <| encodeNewCard title imageUrl cost costToProduce category ) JD.string
        |> Http.send (processResult hook)


updateCard : Int -> String -> String -> Int -> Int -> String -> (Result String String -> msg) -> Cmd msg
updateCard cardId title imageUrl cost costToProduce category hook =
    putRequest (fullPath ++ "cards/") (jsonBody <| encodeUpdatedCard cardId title imageUrl cost costToProduce category )
        |> Http.send (processResult hook)


deleteCard : Int ->(Result String String -> msg) -> Cmd msg
deleteCard cardId hook =
    deleteRequest (fullPath ++ "cards/" ++ (toString cardId))
        |> Http.send (processResult hook)



--User


authenticateUser : String -> String -> (Result String User -> msg) -> Cmd msg
authenticateUser email password hook =
    Http.get (fullPath ++ "users/authenticate/" ++ email ++ "/" ++ password) decodeApiUser
        |> Http.send (processUserResult hook)


registerUser : String -> String -> String -> String -> (Result String User -> msg) -> Cmd msg
registerUser email firstName lastName password hook =
    Http.post (fullPath ++ "users") (jsonBody <| encodeUser firstName lastName email password True) decodeApiUser
        |> Http.send (processUserResult hook)


processUserResult : (Result String User -> msg) -> Result Http.Error ApiUser -> msg
processUserResult message res =
    case res of
        Ok user ->
            message <| Ok (processApiUserToElmUser user)

        Err e ->
            message <| Err <| httpErrToString e



--Cart


processCartResult : (Result String (List (CartItem Card)) -> msg) -> Result Http.Error (List ApiCartItem) -> msg
processCartResult message res =
    case res of
        Ok cart ->
            message <| Ok (List.map apiCartItemToElmCartItem cart)

        Err httpErr ->
            message <| Err <| httpErrToString httpErr


processCartItemResult : (Result String (CartItem Card) -> msg) -> Result Http.Error ApiCartItem -> msg
processCartItemResult message res =
    case res of
        Ok cartItem ->
            message <| Ok <| apiCartItemToElmCartItem cartItem

        Err httpErr ->
            message <| Err <| httpErrToString httpErr


getCartItems : Int -> (Result String (List (CartItem Card)) -> msg) -> Cmd msg
getCartItems userId hook =
        Http.get (fullPath ++ "cartItems/" ++ (toString userId)) Coders.decodeCartItemList
            |> Http.send (processCartResult hook)


getCartItem : Int -> Int -> (Result String (CartItem Card) -> msg) -> Cmd msg
getCartItem cartId cardId hook =
    Http.get (fullPath ++ "cartItems/" ++ (toString cartId) ++ "/" ++ (toString cardId)) Coders.decodeCartItem
        |> Http.send (processCartItemResult hook)


deleteCartItems : Int -> (Result String String -> msg) -> Cmd msg
deleteCartItems cartId hook =
    deleteRequest (fullPath ++ "cartItems/" ++ (toString cartId))
        |> Http.send (processResult hook)


deleteCartItem : Int -> Int -> (Result String String -> msg) -> Cmd msg
deleteCartItem cartId cardId hook =
    deleteRequest (fullPath ++ "cartItems/" ++ (toString cartId) ++ "/" ++ (toString cardId))
        |> Http.send (processResult hook)


createCartItem : Int -> Int -> Int -> (Result String String -> msg) -> Cmd msg
createCartItem userId cardId quantity hook =
    Http.post (fullPath ++ "users/cartItems") (jsonBody <| encodeCartItem userId cardId quantity) JD.string
        |> Http.send (processResult hook)


updateCartItem : Int -> Int -> Int -> (Result String String -> msg) -> Cmd msg
updateCartItem userId cardId quantity hook =
    putRequest (fullPath ++ "users/cartItems") (jsonBody <| encodeCartItem userId cardId quantity)
        |> Http.send (processResult hook)


createUser : String -> String -> String -> String -> Bool -> (Result String String -> msg) -> Cmd msg
createUser firstName lastName email password isAdmin hook =
    Http.post (fullPath ++ "users") (jsonBody <| encodeUser firstName lastName email password isAdmin) JD.string
        |> Http.send (processResult hook)



--Orders


getAllOrders : (Result String (List Types.Order) -> msg) -> Cmd msg
getAllOrders hook =
    Http.get (fullPath ++ "orders") Coders.decodeOrderList
        |> Http.send (processOrderResult hook)


processOrderResult : (Result String (List Types.Order) -> msg) -> Result Http.Error (List ApiOrder) -> msg
processOrderResult message res =
    case res of
        Ok order ->
            message <| Ok (List.map apiOrderToElmOrder order)

        Err httpErr ->
            message <| Err <| httpErrToString httpErr



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
