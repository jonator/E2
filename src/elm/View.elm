module View exposing (view)

import Dict
import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events exposing (..)
import Types exposing (Card, Model, Msg(..), AuthMsg(..), Page(..), User)
import SignIn


view : Model -> Html Msg
view model =
    div [ Attrs.class "main" ]
        [ header model
        , content model.page
        ]


header : Model -> Html Msg
header model =
    let
        userBtns =
            case model.user of
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
                        , addToCartBtn <| AuthenticatedMsgs <| ClickAddToCart c
                        ]

                SignIn _ signInModel ->
                    SignIn.view signInModel SignInMsgs

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
            , addToCartBtn <| AuthenticatedMsgs <| ClickAddToCart c
            ]
        , div [ Attrs.class "image" ]
            [ img [ Attrs.src c.imageUrl ] [] ]
        ]


addToCartBtn : msg -> Html msg
addToCartBtn m =
    div
        [ Attrs.class "add-to-cart-btn button"
        , onClick m
        ]
        [ text "Add to cart" ]
