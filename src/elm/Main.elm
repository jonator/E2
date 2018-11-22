module Main exposing (main)

import Html
import Types exposing (Model, Msg(..), Page(..))
import Update exposing (update)
import View exposing (view)


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , update = update
        , init = ( initialModel, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


initialModel : Model
initialModel =
    { user = Nothing, page = Loading }
