module Requests exposing (..)

import Coders exposing (..)
import Json.Decode as JD exposing (Decoder, field)
import Json.Encode as JE
import Http exposing (Error(..), emptyBody, jsonBody, Request, Body, request, expectString, expectJson)
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


updateCard : Int -> String -> String -> Int -> Int -> String -> (Result String Card -> msg) -> Cmd msg
updateCard cardId title imageUrl cost costToProduce category hook =
    putRequest (fullPath ++ "cards/") (jsonBody <| encodeUpdatedCard cardId title imageUrl cost costToProduce category ) decodeCard
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
    Http.post (fullPath ++ "users") (jsonBody <| encodeUser firstName lastName email password) decodeApiUser
        |> Http.send (processUserResult hook)


processUserResult : (Result String User -> msg) -> Result Http.Error ApiUser -> msg
processUserResult message res =
    case res of
        Ok user ->
            message <| Ok (processApiUserToElmUser user)

        Err e ->
            message <| Err <| httpErrToString e



--Cart

getCartItems : Int -> (Result String (List (CartItem Card)) -> msg) -> Cmd msg
getCartItems userId hook =
        Http.get (fullPath ++ "users/cartItems/" ++ (toString userId)) Coders.decodeCartItemList
            |> Http.send (processResult hook)

deleteCartItems : Int -> (Result String String -> msg) -> Cmd msg
deleteCartItems cartId hook =
    deleteRequest (fullPath ++ "users/cartItems/" ++ (toString cartId))
        |> Http.send (processResult hook)


deleteCartItem : Int -> Int -> (Result String String -> msg) -> Cmd msg
deleteCartItem cartId cardId hook =
    deleteRequest (fullPath ++ "users/cartItems/" ++ (toString cartId) ++ "/" ++ (toString cardId))
        |> Http.send (processResult hook)


createCartItem : Int -> Int -> Int -> (Result String String -> msg) -> Cmd msg
createCartItem userId cardId quantity hook =
    Http.post (fullPath ++ "users/cartItems") (jsonBody <| encodeCartItem userId cardId quantity) JD.string
        |> Http.send (processResult hook)


updateCartItem : Int -> Int -> Int -> (Result String (CartItem Card) -> msg) -> Cmd msg
updateCartItem userId cardId quantity hook =
    putRequest (fullPath ++ "users/cartItems") (jsonBody <| encodeCartItem userId cardId quantity) decodeCartItem
        |> Http.send (processResult hook)


createUser : String -> String -> String -> String -> (Result String String -> msg) -> Cmd msg
createUser firstName lastName email password hook =
    Http.post (fullPath ++ "users") (jsonBody <| encodeUser firstName lastName email password) JD.string
        |> Http.send (processResult hook)



--Orders


getAllOrders : (Result String (List Types.Order) -> msg) -> Cmd msg
getAllOrders hook =
    Http.get (fullPath ++ "orders") Coders.decodeOrderList
        |> Http.send (processOrderListResult hook)


processOrderListResult : (Result String (List Types.Order) -> msg) -> Result Http.Error (List ApiOrder) -> msg
processOrderListResult message res =
    case res of
        Ok order ->
            message <| Ok (List.map apiOrderToElmOrder order)

        Err httpErr ->
            message <| Err <| httpErrToString httpErr

processOrderResult : (Result String (Types.Order) -> msg) -> Result Http.Error (List ApiOrder) -> msg
processOrderResult message res =
    case res of
        Ok order ->
            message <| Ok (List.map apiOrderToElmOrder order)

        Err httpErr ->
            message <| Err <| httpErrToString httpErr

getTotalSales : (Result String Int -> msg) -> Cmd msg
getTotalSales hook = 
    Http.send (processResult hook) <| Http.get (fullPath ++ "orders/totalSales") (field "total" JD.int)

getTotalProfit : (Result String Int -> msg) -> Cmd msg
getTotalProfit hook = 
    Http.send (processResult hook) <| Http.get (fullPath ++ "orders/totalProfit") (field "total" JD.int)

getCardsSoldByCategory : (Result String (List CardsSoldByCategory) -> msg) -> Cmd msg
getCardsSoldByCategory hook =
    Http.send (processResult hook) <| Http.get (fullPath ++ "orders/cardsSoldByCategory") decodeCardsSoldByCategory

createOrder : String -> (Result String Types.Order -> msg) -> Cmd msg
createOrder userId hook = 
    Http.post (fullPath ++ "users") (jsonBody <| JE.int userId) decodeOrder
        |> Http.send (processOrderResult hook)
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


putRequest : String -> Body -> Decoder a -> Request a
putRequest url body decoder =
    request
        { method = "PUT"
        , headers = []
        , url = url
        , body = body
        , expect = expectJson decoder
        , timeout = Nothing
        , withCredentials = False
        }
