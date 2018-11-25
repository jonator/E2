module CardEditor exposing (..)

import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events exposing (onClick, onInput)


type alias Model =
    { title : String
    , imageUrl : String
    , cost : Int
    , category : String
    }


type CardEditorMsg
    = TypeTitle String
    | TypeImageUrl String
    | TypeCost String
    | TypeCategory String
    | SubmitCard String String Int String


init : Model
init =
    { title = ""
    , imageUrl = ""
    , cost = 0
    , category = ""
    }


update : CardEditorMsg -> Model -> Model
update msg model =
    case msg of
        TypeTitle val ->
            { model | title = val }

        TypeImageUrl val ->
            { model | imageUrl = val }

        TypeCost val ->
            case String.toInt val of
                Ok v ->
                    { model | cost = v }

                Err _ ->
                    model

        TypeCategory val ->
            { model | category = val }

        _ ->
            model


view : Model -> (CardEditorMsg -> msg) -> Html msg
view model upgrade =
    Html.map upgrade <|
        div [ Attrs.class "create-card" ]
            [ text "Create a new card for the store:"
            , input
                [ Attrs.class "title-input input"
                , Attrs.placeholder "title"
                , onInput TypeTitle
                ]
                []
            , input
                [ Attrs.class "imageUrl-input input"
                , Attrs.placeholder "image url"
                , onInput TypeImageUrl
                ]
                []
            , input
                [ Attrs.class "cost-input input"
                , Attrs.placeholder "cost ($)"
                , onInput TypeCost
                ]
                []
            , input
                [ Attrs.class "category-input input"
                , Attrs.placeholder "category"
                , onInput TypeCategory
                ]
                []
            , div
                [ Attrs.class "create-card-btn button"
                , onClick <| SubmitCard model.title model.imageUrl model.cost model.category
                ]
                [ text "Create card" ]
            ]
