module Requests
    exposing
        ( apiPath
        , authenticateUser
        , authority
        , createCard
        , createCartItem
        , createOrder
        , createUser
        , deleteCard
        , deleteCartItem
        , deleteRequest
        , fullPath
        , getAllOrders
        , getCards
        , getCardsSoldByCategory
        , getCartItems
        , getTotalProfit
        , getTotalSales
        , httpErrToString
        , processCartItemResult
        , processOrderListResult
        , processResult
        , processUpdateCartItem
        , processUserResult
        , putRequest
        , registerUser
        , updateCard
        , updateCartItem
        )

import Coders exposing (..)
import Http exposing (Body, Error(..), Request, emptyBody, expectJson, expectString, jsonBody, request)
import Json.Decode as JD exposing (Decoder, field)
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
            "Bad payload" ++ str ++ resStr.body


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


createCard : String -> String -> Int -> Int -> String -> (Result String String -> msg) -> Cmd msg
createCard title imageUrl price costToProduce category hook =
    Http.post (fullPath ++ "cards/") (jsonBody <| encodeNewCard title imageUrl price costToProduce category) JD.string
        |> Http.send (processResult hook)


updateCard : Card -> (Result String String -> msg) -> Cmd msg
updateCard c hook =
    putRequest (fullPath ++ "cards/") (jsonBody <| encodeUpdatedCard c.cardId c.title c.imageUrl c.price c.costToProduce c.category) JD.string
        |> Http.send (processResult hook)


deleteCard : Int -> (Result String String -> msg) -> Cmd msg
deleteCard cardId hook =
    deleteRequest (fullPath ++ "cards/" ++ toString cardId)
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
    Http.get (fullPath ++ "users/cartItems/" ++ toString userId) Coders.decodeCartItemList
        |> Http.send (processCartItemResult hook)


processCartItemResult : (Result String (List (CartItem Card)) -> msg) -> Result Http.Error (List (ApiCartItem Card)) -> msg
processCartItemResult message res =
    case res of
        Ok cartItems ->
            message <| Ok (List.map apiCartItemToElmCartItem cartItems)

        Err httpErr ->
            message <| Err <| httpErrToString httpErr


deleteCartItem : Int -> Int -> (Result String String -> msg) -> Cmd msg
deleteCartItem userId cardId hook =
    deleteRequest (fullPath ++ "users/cartItems/" ++ toString userId ++ "/" ++ toString cardId)
        |> Http.send (processResult hook)


createCartItem : Int -> Int -> Int -> (Result String String -> msg) -> Cmd msg
createCartItem userId cardId quantity hook =
    Http.post (fullPath ++ "users/cartItems") (jsonBody <| encodeCartItem userId cardId quantity) decodeCartItemUpdate
        |> Http.send (processUpdateCartItem hook)


updateCartItem : Int -> Int -> Int -> (Result String String -> msg) -> Cmd msg
updateCartItem userId cardId quantity hook =
    putRequest (fullPath ++ "users/cartItems") (jsonBody <| encodeCartItem userId cardId quantity) decodeCartItemUpdate
        |> Http.send (processUpdateCartItem hook)


processUpdateCartItem : (Result String String -> msg) -> Result Http.Error ApiCartUpdate -> msg
processUpdateCartItem message res =
    case res of
        Ok cartUpdate ->
            message <| Ok "ok"

        Err httpError ->
            message <| Err <| httpErrToString httpError


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
        Ok orders ->
            message <| Ok (List.map apiOrderToElmOrder orders)

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


createOrder : Int -> (Result String String -> msg) -> Cmd msg
createOrder userId hook =
    Http.post (fullPath ++ "orders/" ++ toString userId) Http.emptyBody JD.value
        |> Http.send (processValue hook)


processValue : (Result String String -> msg) -> Result Http.Error JD.Value -> msg
processValue message res =
    case res of
        Ok _ ->
            message <| Ok "ok"

        Err httpError ->
            message <| Err <| httpErrToString httpError



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
