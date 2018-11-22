module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (Model, Msg(..))


view : Model -> Html Msg
view model =
    div [ class "container", style [ ( "height", "100%" ), ( "background-color", model.color ) ] ]
        [ div [ class "actions" ]
            [ button [ class "btn", onClick ChangeColor ]
                [ span [] [ text "Elm, Gimme Colors!" ] ]
            ]
        ]
