module Decoders exposing (cardList)

import Json.Decode as JD exposing (Decoder, field, int, string)
import Types exposing (Card)


card : Decoder Card
card =
    JD.map5 Card
        (field "cardId" int)
        (field "title" string)
        (field "imageUrl" string)
        (field "cost" int)
        (field "category" string)


cardList : Decoder (List Card)
cardList =
    JD.list card
