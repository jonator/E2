module CardEditor exposing (..)

import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events exposing (onClick, onInput)


type alias Model =
    { title : String
    , imageUrl : String
    , price : Int
    , costToProduce : Int
    , category : String
    }


type CardEditorMsg
    = TypeTitle String
    | TypeImageUrl String
    | TypePrice String
    | TypeCostToProduce String
    | TypeCategory String
    | SubmitCard String String Int String


init : Model
init =
    { title = ""
    , imageUrl = ""
    , price = 0
    , costToProduce = 0
    , category = ""
    }


update : CardEditorMsg -> Model -> Model
update msg model =
    case msg of
        TypeTitle val ->
            { model | title = val }

        TypeImageUrl val ->
            { model | imageUrl = val }

        TypePrice val ->
            case String.toInt val of
                Ok v ->
                    { model | price = v }

                Err _ ->
                    model

        TypeCostToProduce val ->
            case String.toInt val of
                Ok v ->
                    { model | costToProduce = v }

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
                [ Attrs.class "price-input input"
                , Attrs.placeholder "Price ($)"
                , onInput TypePrice
                ]
                []
            , input
                [ Attrs.class "cost-to-produce-input input"
                , Attrs.placeholder "Cost to produce ($)"
                , onInput TypeCostToProduce
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
                , onClick <| SubmitCard model.title model.imageUrl model.price model.category
                ]
                [ text "Create card" ]
            ]
