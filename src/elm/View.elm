module View exposing (view)

import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events exposing (..)
import Types exposing (Card, Model, Msg(..), Page(..), User)


view : Model -> Html Msg
view model =
    div [ Attrs.class "main" ]
        [ header model.user
        , content model.page
        ]


header : Maybe User -> Html Msg
header mUser =
    div [ Attrs.class "header" ]
        [ text "Cheeky Beak Card Company"
        ]


content : Page -> Html Msg
content page =
    let
        content =
            case page of
                Homepage cardList ->
                    div [ Attrs.class "cards" ] <|
                        List.map card cardList

                _ ->
                    div [] [ text "Other page!" ]
    in
    div [ Attrs.class "content" ] [ content ]


card : Card -> Html Msg
card c =
    div [ Attrs.class "card" ]
        [ div [ Attrs.class "info" ]
            [ div [ Attrs.class "id" ]
                [ text <| toString c.cardId ]
            , div [ Attrs.class "title" ]
                [ text c.title ]
            , div [ Attrs.class "cost" ]
                [ text <| String.append "$" <| toString c.cost ]
            , div [ Attrs.class "category" ]
                [ text c.category ]
            ]
        , div [ Attrs.class "image" ]
            [ img [ Attrs.src c.imageUrl ] [] ]
        ]
