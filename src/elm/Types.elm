module Types exposing (..)

import Dict exposing (Dict)
import SignIn


type alias Model =
    { user : Maybe User
    , page : Page
    }


type alias User =
    { userId : Int
    , firstName : String
    , lastName : String
    , email : String
    , isAdmin : Bool
    , cart : Dict CardId (CartItem Card)
    }


type alias CardsSoldByCategory =
    { category : String
    , quantity : Int
    }


type Page
    = Loading
    | SignIn SignIn.Model
    | Homepage (List Card)
    | CardView Card
    | CartView
    | AdminPage TotalSales OrderCount (List Order) TotalProfit
    | DeleteCardView CardId


type alias Card =
    { cardId : Int
    , title : String
    , imageUrl : String
    , price : Int
    , costToProduce : Int
    , category : String
    }


type alias CartItem a =
    { item : a
    , quantity : Int
    }


type alias TotalSales =
    Int


type alias OrderCount =
    Int


type alias TotalProfit =
    Int


type alias FirstName =
    String


type alias LastName =
    String


type alias CardId =
    Int


type alias Order =
    { orderId : Int
    , user : User
    , orderLines : List OrderLine
    , orderDate : String -- temp
    }


type alias OrderLine =
    { orderLineId : Int
    , card : Card
    , quantity : Int
    }


type Msg
    = HandleCards (Result String (List Card))
    | HandleRegisterUser (Result String User)
    | HandleAuthenticateUser (Result String User)
    | SignInMsgs SignIn.SignInMsg
    | ClickCard Card
    | ClickBackToCards
    | ClickTitleText
    | ClickSignIn
    | AuthenticatedMsgs AuthMsg



--Event that requires user to be authenticated


type AuthMsg
    = HandleUpdateCartItem (Result String String)
    | HandleGetUserCart (Result String (List (CartItem Card)))
    | HandleCreateCard (Result String String)
    | HandleUpdateCard (Result String String)
    | HandleDeleteCard (Result String String)
    | HandleDeleteCartItem (Result String String)
    | HandleCreateCartItem (Result String String)
    | HandleGetAllOrders (Result String (List Order))
    | HandleGetOrderTotal (Result String Int)
    | ClickAddToCart Card
    | ClickCart
    | ClickSignOut
    | CartCardQuantityChange CardId String
    | ClickMyStore
    | ClickCreateCard
    | TypeEditCardTitle Card String
    | TypeEditCardPrice Card String
    | TypeEditCardCategory Card String
    | TypeEditCardImgUrl Card String
    | ClickUpdateCard Card
    | ClickDeleteCard Card
