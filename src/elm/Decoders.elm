module Decoders exposing (cardDecoder)

import Json.Decode as JD exposing (Decoder, field, int, string)
import Types exposing (Card)


cardDecoder : Decoder Card
cardDecoder =
    JD.map3 Card
        (field "cardId" int)
        (field "title" string)
        (field "imageUrl" string)
        (field "cost" int)
        (field "category" string)


cardListDecoder : Decoder (List Card)
cardListDecoder =
    JD.list cardDecoder
