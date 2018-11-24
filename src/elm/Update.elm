module Update exposing (update)

import Dict
import Requests exposing (..)
import Types exposing (Card, CartItem, Model, Msg(..), AuthMsg(..), Page(..), User)
import SignIn exposing (SignInMsg(..))


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

        ClickSignIn ->
            { model | page = SignIn model.page <| SignIn.init True True } ! []

        SignInMsgs siMsg ->
            case model.page of
                SignIn redPage oldModel ->
                    case siMsg of
                        Authenticate email pass ->
                            model ! []

                        --api call to auth
                        Register email fName lName pass ->
                            model ! []

                        --api call to register
                        _ ->
                            let
                                newSIModel =
                                    SignIn.update siMsg oldModel
                            in
                                { model | page = SignIn redPage newSIModel } ! []

                _ ->
                    ignoreOtherCases model

        AuthenticatedMsgs authMsg ->
            case model.user of
                Just user ->
                    case authMsg of
                        ClickAddToCart card ->
                            { model
                                | user =
                                    Just <|
                                        addCardToUsersCart user card
                            }
                                ! []

                Nothing ->
                    { model | page = SignIn model.page <| SignIn.init True True } ! []


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
