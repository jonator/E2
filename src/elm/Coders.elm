module Coders exposing (decodeCardList, decodeCartItemList, decodeCartItem, decodeCard, ApiCartItem, apiCartItemToElmCartItem, encodeCard)

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

encodeCard : Int -> Int -> Int -> Value
encodeCard userId cardId quantity =
    object 
        [ ("userId",JE.int userId)
        , ("cardId",JE.int cardId)
        , ("quantity",JE.int quantity)
        ]
