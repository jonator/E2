module View exposing (view)

import Dict
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
    let
        userBtns =
            case mUser of
                Just user ->
                    let
                        cartCount =
                            user.cart
                                |> Dict.toList
                                |> List.length
                                |> toString
                    in
                    [ div [ Attrs.class "cart button" ]
                        [ text ("Cart (" ++ cartCount ++ ")") ]
                    , div [ Attrs.class "sign-out button" ]
                        [ text "Sign out" ]
                    ]

                Nothing ->
                    [ div [ Attrs.class "sign-in button", onClick ClickSignIn ]
                        [ text "Sign in" ]
                    ]
    in
    div [ Attrs.class "header" ]
        ([ div [ Attrs.class "title-text", onClick ClickTitleText ]
            [ text "Cheeky Beak Card Company" ]
         ]
            ++ userBtns
        )


content : Page -> Html Msg
content page =
    let
        content =
            case page of
                Homepage cardList ->
                    div [ Attrs.class "cards" ] <|
                        List.map card cardList

                CardView c ->
                    div [ Attrs.class "card-view" ]
                        [ card c
                        , addToCartBtn <| ClickAddToCart c
                        ]

                SignIn ->
                    signInView

                Loading ->
                    div [ Attrs.class "loading" ]
                        [ text "Loading!" ]

                _ ->
                    div [] [ text "Other page!" ]
    in
    div [ Attrs.class "content" ] [ content ]


card : Card -> Html Msg
card c =
    div [ Attrs.class "card", onClick <| ClickCard c ]
        [ div [ Attrs.class "info" ]
            [ div [ Attrs.class "id" ]
                [ text <| toString c.cardId ]
            , div [ Attrs.class "title" ]
                [ text c.title ]
            , div [ Attrs.class "cost" ]
                [ text <| String.append "$" <| toString c.cost ]
            , div [ Attrs.class "category" ]
                [ text c.category ]
            , addToCartBtn <| ClickAddToCart c
            ]
        , div [ Attrs.class "image" ]
            [ img [ Attrs.src c.imageUrl ] [] ]
        ]


addToCartBtn : msg -> Html msg
addToCartBtn m =
    div [ Attrs.class "add-to-cart-btn button" ] []


signInView : Html Msg
signInView =
    div [ Attrs.class "sign-in-wrapper" ]
        [ div [ Attrs.class "sign-in" ]
            []
        , div [ Attrs.class "register" ]
            []
        ]
