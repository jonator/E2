module Types exposing (Model, Msg(..))

import Http


type alias Model =
    { color : String
    }


type Msg
    = ChangeColor
    | HandleNewColor String
    | HandleColorError Http.Error
