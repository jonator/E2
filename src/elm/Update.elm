module Update exposing (update)

import Dict
import Requests exposing (..)
import Types exposing (Card, CartItem, Model, Msg(..), Page(..), User)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleCards (Ok newCards) ->
            { model | page = Homepage newCards } ! []

        HandleCards (Err str) ->
            ignoreOtherCases model

        ClickCard card ->
            { model | page = CardView card } ! []

        ClickTitleText ->
            { model | page = Loading } ! [ getCards HandleCards ]

        ClickAddToCart card ->
            case model.user of
                Just user ->
                    { model
                        | user =
                            Just <|
                                addCardToUsersCart user card
                    }
                        ! []

                Nothing ->
                    { model | page = SignIn } ! []

        ClickSignIn ->
            { model | page = SignIn } ! []

        _ ->
            ignoreOtherCases model


ignoreOtherCases : model -> ( model, Cmd msg )
ignoreOtherCases m =
    m ! []


addCardToUsersCart : User -> Card -> User
addCardToUsersCart user card =
    let
        itemAdd mI =
            case mI of
                Just i ->
                    Just { i | quantity = i.quantity + 1 }

                Nothing ->
                    Just <| CartItem 1 card
    in
    { user | cart = Dict.update card.cardId itemAdd user.cart }
