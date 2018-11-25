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
    { user = Nothing, page = Loading }
