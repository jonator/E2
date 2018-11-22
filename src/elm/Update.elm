module Update exposing (update)

import Requests exposing (..)
import Types exposing (Model, Msg(..), Page(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleCards (Ok newCards) ->
            { model | page = Homepage newCards } ! []

        HandleCards (Err str) ->
            ignoreOtherCases model


ignoreOtherCases : model -> ( model, Cmd msg )
ignoreOtherCases m =
    m ! []
