module Coders exposing (..)

import Json.Decode as JD exposing (Decoder, field, int, string)
import Json.Encode as JE exposing (object, int, string, Value)
import Types exposing (Card, CartItem)


decodeCard : Decoder Card
decodeCard =
    JD.map5 Card
        (field "cardId" JD.int)
        (field "title" JD.string)
        (field "imageUrl" JD.string)
        (field "cost" JD.int)
        (field "category" JD.string)


decodeCardList : Decoder (List Card)
decodeCardList =
    JD.list decodeCard


decodeCartItem : Decoder ApiCartItem
decodeCartItem =
    JD.map6 ApiCartItem
        (field "cardId" JD.int)
        (field "title" JD.string)
        (field "imageUrl" JD.string)
        (field "cost" JD.int)
        (field "category" JD.string)
        (field "quantity" JD.int)



decodeCartItemList : Decoder (List ApiCartItem)
decodeCartItemList =
    JD.list decodeCartItem


type alias ApiCartItem =
    { cardId : Int
    , title : String
    , imageUrl : String
    , cost : Int
    , category : String
    , quantity : Int
    }

apiCartItemToElmCartItem : ApiCartItem -> CartItem Card
apiCartItemToElmCartItem apiCartItem = 
    CartItem apiCartItem.quantity (Card apiCartItem.cardId apiCartItem.title apiCartItem.imageUrl apiCartItem.cost apiCartItem.category)

encodeCartItem : Int -> Int -> Int -> Value
encodeCartItem userId cardId quantity =
    object 
        [ ("userId",JE.int userId)
        , ("cardId",JE.int cardId)
        , ("quantity",JE.int quantity)
        ]

encodeUser : String -> String -> String -> String -> Bool -> Value
encodeUser firstName lastName email password isAdmin =
    object 
        [ ("firstName",JE.string firstName)
        , ("lastName",JE.string lastName)
        , ("email",JE.string email)
        , ("password",JE.string password)
        , ("isAdmin", JE.bool isAdmin)
        ]

encodeNewCard :  String -> String -> Int -> String -> Int -> Value
encodeNewCard title imageUrl cost category userId = 
    object
        [
            ("card", 
                object 
                    [ ("title",JE.string title)
                    , ("imageUrl",JE.string imageUrl)
                    , ("cost",JE.int cost)
                    , ("category",JE.string category)
                    ]
            ),
            ("userId", JE.int userId)
        ]

encodeUpdatedCard : Int -> String -> String -> Int -> String -> Int -> Value
encodeUpdatedCard cardId title imageUrl cost category userId = 
    object
        [
            ("card", 
                object 
                    [ ("cardId",JE.int cardId)
                    , ("title",JE.string title)
                    , ("imageUrl",JE.string imageUrl)
                    , ("cost",JE.int cost)
                    , ("category",JE.string category)
                    ]
            ),
            ("userId", JE.int userId)
        ]