module Types exposing (..)

import CardEditor
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
    , isAdmin : Bool
    , cart : Dict CardId (CartItem Card)
    }


type Page
    = Loading
    | SignIn RedirectPage SignIn.Model
    | Homepage (List Card)
    | CardView Card
    | CartView
    | AdminPage TotalSales OrderCount (List Order) TotalProfit CardId CardId
    | CreateCardView CardEditor.Model
    | EditCardView CardId CardEditor.Model
    | DeleteCardView CardId


type alias Card =
    { cardId : Int
    , title : String
    , imageUrl : String
    , cost : Int
    , category : String
    }


type alias CartItem a =
    { quantity : Int
    , item : a
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


type alias RedirectPage =
    Page


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
    | SignInMsgs SignIn.SignInMsg
    | ClickCard Card
    | ClickBackToCards
    | ClickTitleText
    | ClickSignIn
    | AuthenticatedMsgs AuthMsg



--Event that requires user to be authenticated


type AuthMsg
    = CardEditorMsgs CardEditor.CardEditorMsg
    | ClickAddToCart Card
    | ClickCart
    | ClickSignOut
    | CartCardQuantityChange CardId String
    | ClickMyStore
    | ClickCreateCard
    | ClickEditCard
    | TypeEditCardId String
    | ClickDeleteCard
    | TypeDeleteCardId String