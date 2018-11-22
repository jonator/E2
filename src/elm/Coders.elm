module Coders exposing (decodeCardList)

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
