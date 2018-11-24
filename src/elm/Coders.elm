module Coders exposing (decodeCardList, decodeCartItemList)

import Json.Decode as JD exposing (Decoder, field, int, string)
import Types exposing (Card)


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


decodeCartItem : Decoder (CartItem Card)
decodeCartItem =
    JD.map5 CartItem
        (field "title" decodeCard)
        (field "quantity" int)
        


decodeCartItemList : Decoder (List Card)
decodeCartItemList =
    JD.list decodeCartItem