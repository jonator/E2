module Coders exposing (decodeCardList, decodeCartItemList, decodeCartItem, decodeCard, ApiCartItem, apiCartItemToElmCartItem)

import Json.Decode as JD exposing (Decoder, field, int, string)
import Types exposing (Card, CartItem)


decodeCard : Decoder Card
decodeCard =
    JD.map5 Card
        (field "cardId" int)
        (field "title" string)
        (field "imageUrl" string)
        (field "cost" int)
        (field "category" string)


decodeCardList : Decoder (List Card)
decodeCardList =
    JD.list decodeCard


decodeCartItem : Decoder ApiCartItem
decodeCartItem =
    JD.map6 ApiCartItem
        (field "cardId" int)
        (field "title" string)
        (field "imageUrl" string)
        (field "cost" int)
        (field "category" string)
        (field "quantity" int)



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

