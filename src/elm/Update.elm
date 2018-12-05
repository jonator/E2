module Update exposing (update)

import CardEditor exposing (CardEditorMsg(..))
import Dict
import Requests exposing (..)
import Types exposing (Card, CartItem, Model, Msg(..), Order, AuthMsg(..), Page(..), User)
import SignIn exposing (SignInMsg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleCards res ->
            case res of
                Ok newCards ->
                    { model | page = Homepage newCards } ! []

                Err _ ->
                    ignoreOtherCases model

        HandleRegisterUser res ->
            case res of
                Ok _ ->
                    case model.page of
                        SignIn siModel ->
                            { model | page = Loading } ! [ authenticateUser siModel.registerEmail siModel.registerPassword HandleAuthenticateUser ]

                        _ ->
                            ignoreOtherCases model

                Err _ ->
                    case model.page of
                        SignIn siModel ->
                            let
                                newSiModel =
                                    { siModel | validReg = False }
                            in
                                { model | page = SignIn newSiModel } ! []

                        _ ->
                            ignoreOtherCases model

        HandleAuthenticateUser res ->
            case res of
                Ok user ->
                    { model | user = Just user, page = Loading }
                        ! [ getCards HandleCards
                          , getCartItems user.userId <| AuthenticatedMsgs << HandleGetUserCart
                          ]

                Err _ ->
                    case model.page of
                        SignIn siModel ->
                            let
                                newSiModel =
                                    { siModel | validAuth = False }
                            in
                                { model | page = SignIn newSiModel } ! []

                        _ ->
                            ignoreOtherCases model

        ClickCard card ->
            { model | page = CardView card } ! []

        ClickBackToCards ->
            { model | page = Loading } ! [ getCards HandleCards ]

        ClickTitleText ->
            { model | page = Loading } ! [ getCards HandleCards ]

        ClickSignIn ->
            { model | page = SignIn <| SignIn.init True True } ! []

        SignInMsgs siMsg ->
            case model.page of
                SignIn oldModel ->
                    case siMsg of
                        Authenticate email pass ->
                            model ! [ authenticateUser email pass HandleAuthenticateUser ]

                        Register email fName lName pass ->
                            model ! [ registerUser email fName lName pass HandleRegisterUser ]

                        _ ->
                            let
                                newSIModel =
                                    SignIn.update siMsg oldModel
                            in
                                { model | page = SignIn newSIModel } ! []

                _ ->
                    ignoreOtherCases model

        AuthenticatedMsgs authMsg ->
            case model.user of
                Just user ->
                    case authMsg of
                        HandleGetUserCart res ->
                            case res of
                                Ok cart ->
                                    let
                                        newCart =
                                            List.map (\x -> ( x.item.cardId, x )) cart

                                        newUser =
                                            { user | cart = Dict.fromList newCart }
                                    in
                                        { model | user = Just newUser } ! []

                                Err _ ->
                                    ignoreOtherCases model

                        HandleCreateCard res ->
                            ignoreOtherCases model

                        HandleUpdateCard res ->
                            ignoreOtherCases model

                        HandleDeleteCard res ->
                            ignoreOtherCases model

                        HandleDeleteCartItem res ->
                            ignoreOtherCases model

                        HandleCreateCartItem res ->
                            model ! [ getCartItems user.userId <| AuthenticatedMsgs << HandleGetUserCart ]

                        HandleUpdateCartItem res ->
                            ignoreOtherCases model

                        HandleGetAllOrders res ->
                            case res of
                                Ok orderList ->
                                    -- call getorder total by this order id, calculate total profit
                                    { model | page = AdminPage 0 (List.length orderList) orderList 0 } ! []

                                Err _ ->
                                    ignoreOtherCases model

                        HandleGetOrderTotal res ->
                            ignoreOtherCases model

                        ClickAddToCart card ->
                            { model
                                | user =
                                    Just <|
                                        addCardToUsersCart user card
                            }
                                ! [ createCartItem user.userId card.cardId 1 <| AuthenticatedMsgs << HandleCreateCartItem ]

                        ClickCart ->
                            { model | page = CartView } ! []

                        ClickSignOut ->
                            { model | user = Nothing, page = Loading } ! [ getCards HandleCards ]

                        CartCardQuantityChange cardId stringValue ->
                            case String.toInt stringValue of
                                Ok val ->
                                    let
                                        newUser =
                                            { user
                                                | cart =
                                                    Dict.update
                                                        cardId
                                                        (\y ->
                                                            case y of
                                                                Just item ->
                                                                    if val > 0 then
                                                                        Just { item | quantity = val }
                                                                    else
                                                                        Nothing

                                                                Nothing ->
                                                                    Nothing
                                                        )
                                                        user.cart
                                            }
                                    in
                                        if val > 0 then
                                            { model | user = Just newUser } ! []
                                        else
                                            ignoreOtherCases model

                                --api to update cart item to val
                                Err _ ->
                                    ignoreOtherCases model

                        ClickMyStore ->
                            --get adminpage api calls, switch page to loading
                            if user.isAdmin then
                                { model | page = Loading } ! [ getAllOrders <| AuthenticatedMsgs << HandleGetAllOrders ]
                            else
                                ignoreOtherCases model

                        ClickCreateCard ->
                            { model | page = CreateCardView CardEditor.init } ! []

                        CardEditorMsgs ceMsg ->
                            case model.page of
                                CreateCardView ceModel ->
                                    case ceMsg of
                                        SubmitCard title img cost category ->
                                            -- api call to create card
                                            { model | page = Loading } ! []

                                        _ ->
                                            let
                                                newCEModel =
                                                    CardEditor.update ceMsg ceModel
                                            in
                                                { model | page = CreateCardView newCEModel } ! []

                                _ ->
                                    ignoreOtherCases model

                        TypeEditCardTitle card str ->
                            case model.page of
                                Homepage cardList ->
                                    let
                                        updateTitle c =
                                            if c.cardId == card.cardId then
                                                { c | title = str }
                                            else
                                                c
                                    in
                                        { model | page = Homepage (List.map updateTitle cardList) } ! []

                                _ ->
                                    ignoreOtherCases model

                        TypeEditCardPrice card str ->
                            case model.page of
                                Homepage cardList ->
                                    let
                                        updatePrice c =
                                            if c.cardId == card.cardId then
                                                case String.toInt str of
                                                    Ok v ->
                                                        { c | price = v }

                                                    Err _ ->
                                                        c
                                            else
                                                c
                                    in
                                        { model | page = Homepage (List.map updatePrice cardList) } ! []

                                _ ->
                                    ignoreOtherCases model

                        TypeEditCardCategory card str ->
                            case model.page of
                                Homepage cardList ->
                                    let
                                        updateCat c =
                                            if c.cardId == card.cardId then
                                                { c | category = str }
                                            else
                                                c
                                    in
                                        { model | page = Homepage (List.map updateCat cardList) } ! []

                                _ ->
                                    ignoreOtherCases model

                        TypeEditCardImgUrl card str ->
                            case model.page of
                                Homepage cardList ->
                                    let
                                        updateImgUrl c =
                                            if c.cardId == card.cardId then
                                                { c | imageUrl = str }
                                            else
                                                c
                                    in
                                        { model | page = Homepage (List.map updateImgUrl cardList) } ! []

                                _ ->
                                    ignoreOtherCases model

                        ClickUpdateCard card ->
                            ignoreOtherCases model

                        ClickDeleteCard card ->
                            ignoreOtherCases model

                Nothing ->
                    { model | page = SignIn <| SignIn.init True True } ! []


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
