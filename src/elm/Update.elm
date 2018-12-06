module Update exposing (update)

import Dict
import Requests exposing (..)
import SignIn exposing (SignInMsg(..))
import Types
    exposing
        ( AuthMsg(..)
        , Card
        , CartItem
        , Collapsible
        , CreateCardModel
        , Model
        , Msg(..)
        , Order
        , Page(..)
        , User
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleCards res ->
            case res of
                Ok newCards ->
                    { model | page = Homepage newCards (CreateCardModel "" "" "" "" "") } ! []

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
                                Ok cartItems ->
                                    let
                                        newCart =
                                            List.map (\x -> ( x.item.cardId, x )) cartItems

                                        newUser =
                                            { user | cart = Dict.fromList newCart }
                                    in
                                    { model | user = Just newUser } ! []

                                Err _ ->
                                    ignoreOtherCases model

                        HandleCreateCard res ->
                            -- for simplicity, on the following we ignore whether it
                            -- succeeds or fails and will just get whats
                            -- on the server
                            model ! [ getCards HandleCards ]

                        HandleUpdateCard res ->
                            model ! [ getCards HandleCards ]

                        HandleDeleteCard res ->
                            model ! [ getCards HandleCards ]

                        ClickDeleteCartItem cartItem ->
                            model ! [ deleteCartItem user.userId cartItem.item.cardId <| AuthenticatedMsgs << HandleDeleteCartItem ]

                        HandleDeleteCartItem res ->
                            model ! [ getCartItems user.userId <| AuthenticatedMsgs << HandleGetUserCart ]

                        HandleCreateCartItem res ->
                            model ! [ getCartItems user.userId <| AuthenticatedMsgs << HandleGetUserCart ]

                        HandleUpdateCartItem res ->
                            model ! [ getCartItems user.userId <| AuthenticatedMsgs << HandleGetUserCart ]

                        HandleCreateOrder res ->
                            case res of
                                Ok _ ->
                                    { model | page = Loading }
                                        ! [ getCartItems user.userId <| AuthenticatedMsgs << HandleGetUserCart
                                          , getCards HandleCards
                                          ]

                                Err _ ->
                                    ignoreOtherCases model

                        HandleGetAllOrders res ->
                            case res of
                                Ok orderList ->
                                    { model | page = AdminPage 0 (List.length orderList) (List.map (toCollapsibleOrder True) orderList) 0 [] }
                                        ! [ getTotalSales <| AuthenticatedMsgs << HandleGetTotalSales
                                          , getTotalProfit <| AuthenticatedMsgs << HandleGetTotalProfit
                                          , getCardsSoldByCategory <| AuthenticatedMsgs << HandleGetCardsSoldByCategory
                                          ]

                                Err _ ->
                                    ignoreOtherCases model

                        HandleGetTotalSales res ->
                            case res of
                                Ok val ->
                                    case model.page of
                                        AdminPage totalSales a b c d ->
                                            { model | page = AdminPage val a b c d } ! []

                                        _ ->
                                            ignoreOtherCases model

                                Err _ ->
                                    ignoreOtherCases model

                        HandleGetTotalProfit res ->
                            case res of
                                Ok val ->
                                    case model.page of
                                        AdminPage a b c totalProfit d ->
                                            { model | page = AdminPage a b c val d } ! []

                                        _ ->
                                            ignoreOtherCases model

                                Err _ ->
                                    ignoreOtherCases model

                        HandleGetCardsSoldByCategory res ->
                            case res of
                                Ok catList ->
                                    case model.page of
                                        AdminPage a b c d _ ->
                                            { model | page = AdminPage a b c d catList } ! []

                                        _ ->
                                            ignoreOtherCases model

                                Err _ ->
                                    ignoreOtherCases model

                        ClickAddToCart card ->
                            model ! [ createCartItem user.userId card.cardId 1 <| AuthenticatedMsgs << HandleCreateCartItem ]

                        ClickCart ->
                            { model | page = CartView } ! []

                        ClickSignOut ->
                            { model | user = Nothing, page = Loading } ! [ getCards HandleCards ]

                        CartCardQuantityChange cardId stringValue ->
                            case String.toInt stringValue of
                                Ok quant ->
                                    if quant > 0 then
                                        model ! [ updateCartItem user.userId cardId quant <| AuthenticatedMsgs << HandleUpdateCartItem ]

                                    else
                                        model ! [ deleteCartItem user.userId cardId <| AuthenticatedMsgs << HandleDeleteCartItem ]

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
                            case model.page of
                                Homepage _ ccModel ->
                                    let
                                        cmd =
                                            case Result.map2 (\x y -> ( x, y )) (String.toInt ccModel.price) (String.toInt ccModel.costToProduce) of
                                                Ok ( price, costToProduce ) ->
                                                    createCard ccModel.title ccModel.imgUrl price costToProduce ccModel.category <|
                                                        AuthenticatedMsgs
                                                            << HandleCreateCard

                                                Err err ->
                                                    Cmd.none
                                    in
                                    ( model, cmd )

                                _ ->
                                    ignoreOtherCases model

                        TypeEditNewCardTitle str ->
                            case model.page of
                                Homepage cardList createCardModel ->
                                    { model | page = Homepage cardList { createCardModel | title = str } } ! []

                                _ ->
                                    ignoreOtherCases model

                        TypeEditNewCardPrice str ->
                            case model.page of
                                Homepage cardList createCardModel ->
                                    { model | page = Homepage cardList { createCardModel | price = str } } ! []

                                _ ->
                                    ignoreOtherCases model

                        TypeEditNewCardCostToProduce str ->
                            case model.page of
                                Homepage cardList createCardModel ->
                                    { model | page = Homepage cardList { createCardModel | costToProduce = str } } ! []

                                _ ->
                                    ignoreOtherCases model

                        TypeEditNewCardCategory str ->
                            case model.page of
                                Homepage cardList createCardModel ->
                                    { model | page = Homepage cardList { createCardModel | category = str } } ! []

                                _ ->
                                    ignoreOtherCases model

                        TypeEditNewCardImgUrl str ->
                            case model.page of
                                Homepage cardList createCardModel ->
                                    { model | page = Homepage cardList { createCardModel | imgUrl = str } } ! []

                                _ ->
                                    ignoreOtherCases model

                        TypeEditCardTitle card str ->
                            case model.page of
                                Homepage cardList createCardModel ->
                                    let
                                        updateTitle c =
                                            if c.cardId == card.cardId then
                                                { c | title = str }

                                            else
                                                c
                                    in
                                    { model | page = Homepage (List.map updateTitle cardList) createCardModel } ! []

                                _ ->
                                    ignoreOtherCases model

                        TypeEditCardPrice card str ->
                            case model.page of
                                Homepage cardList createCardModel ->
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
                                    { model | page = Homepage (List.map updatePrice cardList) createCardModel } ! []

                                _ ->
                                    ignoreOtherCases model

                        TypeEditCardCategory card str ->
                            case model.page of
                                Homepage cardList createCardModel ->
                                    let
                                        updateCat c =
                                            if c.cardId == card.cardId then
                                                { c | category = str }

                                            else
                                                c
                                    in
                                    { model | page = Homepage (List.map updateCat cardList) createCardModel } ! []

                                _ ->
                                    ignoreOtherCases model

                        TypeEditCardImgUrl card str ->
                            case model.page of
                                Homepage cardList createCardModel ->
                                    let
                                        updateImgUrl c =
                                            if c.cardId == card.cardId then
                                                { c | imageUrl = str }

                                            else
                                                c
                                    in
                                    { model | page = Homepage (List.map updateImgUrl cardList) createCardModel } ! []

                                _ ->
                                    ignoreOtherCases model

                        ClickUpdateCard card ->
                            model ! [ updateCard card <| AuthenticatedMsgs << HandleUpdateCard ]

                        ClickDeleteCard card ->
                            model ! [ deleteCard card.cardId <| AuthenticatedMsgs << HandleDeleteCard ]

                        ClickToggleOrderCollapsed order ->
                            case model.page of
                                AdminPage a b collapsibleOList c d ->
                                    let
                                        updateCollOrder o =
                                            if o.item.orderId == order.orderId then
                                                { o | collapsed = not o.collapsed }

                                            else
                                                o
                                    in
                                    { model | page = AdminPage a b (List.map updateCollOrder collapsibleOList) c d } ! []

                                _ ->
                                    ignoreOtherCases model

                        ClickPurchaseCart ->
                            case model.page of
                                CartView ->
                                    model ! [ createOrder user.userId <| AuthenticatedMsgs << HandleCreateOrder ]

                                _ ->
                                    ignoreOtherCases model

                Nothing ->
                    { model | page = SignIn <| SignIn.init True True } ! []


ignoreOtherCases : model -> ( model, Cmd msg )
ignoreOtherCases m =
    m ! []


toCollapsibleOrder : Bool -> Types.Order -> Collapsible Types.Order
toCollapsibleOrder isOpen o =
    Collapsible o isOpen
