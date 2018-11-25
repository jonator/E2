module Main exposing (main)

import Html
import Requests
import Types exposing (Model, Msg(..), Page(..), User)
import Update exposing (update)
import View exposing (view)
import Dict


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , update = update
        , init = ( initialModel, Requests.getCards HandleCards )
        , subscriptions = \_ -> Sub.none
        }


initialModel : Model
initialModel =
    { user = Just testUser, page = Loading }


testUser : User
testUser =
    { userId = 1
    , firstName = "Bob"
    , lastName = "Jones"
    , isAdmin = True
    , cart =
        Dict.fromList
            [ ( 99091
              , { quantity = 1
                , item =
                    { cardId = 99091
                    , title = "ASDdsdfsdf"
                    , imageUrl = "https://cdn.shopify.com/s/files/1/0558/4569/products/CHEERS-WHT_400x.jpg?v=1416259320"
                    , price = 1101
                    , costToProduce = 22
                    , category = "Rustic"
                    }
                }
              )
            , ( 39407
              , { quantity = 4
                , item =
                    { cardId = 39407
                    , title = "dfsfsdfsdf"
                    , imageUrl = "https://cdn.shopify.com/s/files/1/0558/4569/products/ALWAYS-FOREVER3_400x.jpg?v=1404230274"
                    , price = 3223
                    , costToProduce = 24
                    , category = "Fantastic"
                    }
                }
              )
            ]
    }
