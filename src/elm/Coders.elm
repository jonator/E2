module Coders exposing (..)

import Dict
import Json.Decode as JD exposing (Decoder, field, int, string)
import Json.Encode as JE exposing (object, int, string, Value)
import Types exposing (..)


type alias ApiCartItem =
    { cardId : Int
    , title : String
    , imageUrl : String
    , price : Int
    , costToProduce : Int
    , category : String
    , quantity : Int
    }


type alias ApiOrderUser =
    { userId : Int
    , firstName : String
    , lastName : String
    , email : String
    , password : String
    , isAdmin : Bool
    }


type alias ApiOrder =
    { orderId : Int
    , user : ApiUser
    , orderLines : List OrderLine
    , orderDate : String
    }


type alias ApiUser =
    { firstName : String
    , lastName : String
    , email : String
    , password : String
    , isAdmin : Bool
    , userId : Int
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


decodeCartItem : Decoder ApiCartItem
decodeCartItem =
    JD.map7 ApiCartItem
        (field "cardId" JD.int)
        (field "title" JD.string)
        (field "imageUrl" JD.string)
        (field "price" JD.int)
        (field "costToProduce" JD.int)
        (field "category" JD.string)
        (field "quantity" JD.int)


decodeCartItemList : Decoder (List ApiCartItem)
decodeCartItemList =
    JD.list decodeCartItem


apiCartItemToElmCartItem : ApiCartItem -> CartItem Card
apiCartItemToElmCartItem apiCartItem =
    CartItem apiCartItem.quantity (Card apiCartItem.cardId apiCartItem.title apiCartItem.imageUrl apiCartItem.price apiCartItem.costToProduce apiCartItem.category)


encodeCartItem : Int -> Int -> Int -> Value
encodeCartItem userId cardId quantity =
    object
        [ ( "userId", JE.int userId )
        , ( "cardId", JE.int cardId )
        , ( "quantity", JE.int quantity )
        ]


decodeApiUser : Decoder ApiUser
decodeApiUser =
    JD.map6 ApiUser
        (field "firstName" JD.string)
        (field "lastName" JD.string)
        (field "email" JD.string)
        (field "password" JD.string)
        (field "isAdmin" JD.bool)
        (field "userId" JD.int)


processApiUserToElmUser : ApiUser -> User
processApiUserToElmUser apiUser =
    User apiUser.userId apiUser.firstName apiUser.lastName apiUser.isAdmin Dict.empty


encodeUser : String -> String -> String -> String -> Bool -> Value
encodeUser firstName lastName email password isAdmin =
    object
        [ ( "firstName", JE.string firstName )
        , ( "lastName", JE.string lastName )
        , ( "email", JE.string email )
        , ( "password", JE.string password )
        , ( "isAdmin", JE.bool isAdmin )
        ]


encodeNewCard : String -> String -> Int -> String -> Int -> Value
encodeNewCard title imageUrl cost category userId =
    object
        [ ( "card"
          , object
                [ ( "title", JE.string title )
                , ( "imageUrl", JE.string imageUrl )
                , ( "cost", JE.int cost )
                , ( "category", JE.string category )
                ]
          )
        , ( "userId", JE.int userId )
        ]


encodeUpdatedCard : Int -> String -> String -> Int -> String -> Int -> Value
encodeUpdatedCard cardId title imageUrl cost category userId =
    object
        [ ( "card"
          , object
                [ ( "cardId", JE.int cardId )
                , ( "title", JE.string title )
                , ( "imageUrl", JE.string imageUrl )
                , ( "cost", JE.int cost )
                , ( "category", JE.string category )
                ]
          )
        , ( "userId", JE.int userId )
        ]


decodeOrderList : Decoder (List ApiOrder)
decodeOrderList =
    JD.list decodeOrder


decodeOrder : Decoder ApiOrder
decodeOrder =
    JD.map4 ApiOrder
        (field "orderId" JD.int)
        (field "user" decodeApiOrderUser)
        (field "orderLines" decodeOrderLines)
        (field "orderDate" JD.string)


apiOrderToElmOrder : ApiOrder -> Types.Order
apiOrderToElmOrder apiOrder =
    Order apiOrder.orderId (apiOrderUserToElmUser apiOrder.user) apiOrder.orderLines apiOrder.orderDate


apiOrderUserToElmUser : ApiOrderUser -> User
apiOrderUserToElmUser apiUser =
    User apiUser.userId apiUser.firstName apiUser.lastName apiUser.isAdmin Dict.empty


decodeApiOrderUser : Decoder ApiOrderUser
decodeApiOrderUser =
    JD.map6 ApiOrderUser
        (field "userId" JD.int)
        (field "firstName" JD.string)
        (field "lastName" JD.string)
        (field "email" JD.string)
        (field "password" JD.string)
        (field "isAdmin" JD.bool)


decodeApiAuthenticateUser : Decoder ApiUser
decodeApiAuthenticateUser =
    JD.map6 ApiUser
        (field "firstName" JD.string)
        (field "lastName" JD.string)
        (field "email" JD.string)
        (field "password" JD.string)
        (field "isAdmin" JD.bool)
        (field "userId" JD.int)


decodeOrderLine : Decoder OrderLine
decodeOrderLine =
    JD.map3 OrderLine
        (field "orderLineId" JD.int)
        (field "card" decodeCard)
        (field "quantity" JD.int)


decodeOrderLines : Decoder (List OrderLine)
decodeOrderLines =
    JD.list decodeOrderLine
