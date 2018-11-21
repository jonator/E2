module Update exposing (update)

import Requests exposing (fetchColor)
import Types exposing (Model, Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeColor ->
            ( model, fetchColor )

        HandleNewColor color ->
            ( { model | color = color }, Cmd.none )

        HandleColorError error ->
            ( model, Cmd.none )
