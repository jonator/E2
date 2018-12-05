module Coders exposing (..)

import Dict
import Json.Decode as JD exposing (Decoder, field, int, string)
import Json.Encode as JE exposing (object, int, string, Value)
import Types exposing (..)


type alias ApiOrder =
    { orderId : Int
    , user : ApiUser
    , orderLines : List OrderLine
    , orderDate : String
    }


type alias ApiUser =
    { userId : Int
    , firstName : String
    , lastName : String
    , email : String
    , isAdmin : Bool
    }


type alias ApiCartItem a =
    { card : a
    , quantity : Int
    }


decodeCard : Decoder Card
decodeCard =
    JD.map6 Card
        (field "cardId" JD.int)
        (field "title" JD.string)
        (field "imageUrl" JD.string)
        (field "price" JD.int)
        (field "costToProduce" JD.int)
        (field "category" JD.string)


decodeCardList : Decoder (List Card)
decodeCardList =
    JD.list decodeCard


decodeCartItem : Decoder (ApiCartItem Card)
decodeCartItem =
    JD.map2 ApiCartItem
        (field "card" decodeCard)
        (field "quantity" JD.int)


decodeCartItemList : Decoder (List (ApiCartItem Card))
decodeCartItemList =
    JD.list decodeCartItem


apiCartItemToElmCartItem : ApiCartItem a -> CartItem a
apiCartItemToElmCartItem apiItem =
    CartItem apiItem.card apiItem.quantity


encodeCartItem : Int -> Int -> Int -> Value
encodeCartItem userId cardId quantity =
    object
        [ ( "userId", JE.int userId )
        , ( "cardId", JE.int cardId )
        , ( "quantity", JE.int quantity )
        ]


decodeApiUser : Decoder ApiUser
decodeApiUser =
    JD.map5 ApiUser
        (field "userId" JD.int)
        (field "firstName" JD.string)
        (field "lastName" JD.string)
        (field "email" JD.string)
        (field "isAdmin" JD.bool)


decodeCardsSoldByCategory : Decoder (List CardsSoldByCategory)
decodeCardsSoldByCategory =
    JD.list
        (JD.map2 CardsSoldByCategory
            (field "category" JD.string)
            (field "quantity" JD.int)
        )


processApiUserToElmUser : ApiUser -> User
processApiUserToElmUser apiUser =
    User apiUser.userId apiUser.firstName apiUser.lastName apiUser.email apiUser.isAdmin Dict.empty


encodeUser : String -> String -> String -> String -> Value
encodeUser firstName lastName email password =
    object
        [ ( "firstName", JE.string firstName )
        , ( "lastName", JE.string lastName )
        , ( "email", JE.string email )
        , ( "password", JE.string password )
        ]


encodeNewCard : String -> String -> Int -> Int -> String -> Value
encodeNewCard title imageUrl cost costToProduce category =
    object
        [ ( "title", JE.string title )
        , ( "imageUrl", JE.string imageUrl )
        , ( "price", JE.int cost )
        , ( "costToProduce", JE.int costToProduce )
        , ( "category", JE.string category )
        ]


encodeUpdatedCard : Int -> String -> String -> Int -> Int -> String -> Value
encodeUpdatedCard cardId title imageUrl cost costToProduce category =
    object
        [ ( "cardId", JE.int cardId )
        , ( "title", JE.string title )
        , ( "imageUrl", JE.string imageUrl )
        , ( "cost", JE.int cost )
        , ( "costToProduce", JE.int costToProduce )
        , ( "category", JE.string category )
        ]


decodeOrderList : Decoder (List ApiOrder)
decodeOrderList =
    JD.list decodeOrder


decodeOrder : Decoder ApiOrder
decodeOrder =
    JD.map4 ApiOrder
        (field "orderId" JD.int)
        (field "user" decodeApiUser)
        (field "orderLines" decodeOrderLines)
        (field "orderDate" JD.string)


apiOrderToElmOrder : ApiOrder -> Types.Order
apiOrderToElmOrder apiOrder =
    Order apiOrder.orderId (processApiUserToElmUser apiOrder.user) apiOrder.orderLines apiOrder.orderDate


decodeOrderLine : Decoder OrderLine
decodeOrderLine =
    JD.map3 OrderLine
        (field "orderLineId" JD.int)
        (field "card" decodeCard)
        (field "quantity" JD.int)


decodeOrderLines : Decoder (List OrderLine)
decodeOrderLines =
    JD.list decodeOrderLine
