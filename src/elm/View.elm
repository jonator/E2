module View exposing (view)

import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events exposing (..)
import Types exposing (Model, Msg(..), Page(..), User)


view : Model -> Html Msg
view model =
    div [ Attrs.class "main" ]
        [ header model.user
        , content model.page
        ]


header : Maybe User -> Html Msg
header mUser =
    case mUser of
        Just user ->
            div [ Attrs.class "header" ]
                []

        Nothing ->
            div [ Attrs.class "header" ]
                []


content : Page -> Html Msg
content page =
    let
        content =
            case page of
                Homepage cardList ->
                    div [ Attrs.class "cards" ] <|
                        List.map
                            (\x ->
                                div [ Attrs.class "card" ]
                                    [ text <| toString x.cardId, text x.title ]
                            )
                            cardList

                _ ->
                    div [] [ text "Other page!" ]
    in
    div [ Attrs.class "content" ] [ content ]
