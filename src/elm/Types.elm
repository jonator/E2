module Types exposing (Card, Model, Msg(..), Page(..))


type alias Model =
    { user : Maybe User
    , page : Page
    }


type alias User =
    { userId : Int
    , firstName : String
    , lastName : String
    }


type Page
    = Loading
    | SignIn
    | Homepage (List Card)
    | CardView Card
    | CartView (List (CartItem Card))
    | AdminPage TotalSales OrderCount (List Order) TotalProfit


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
    = ChangeColor
    | HandleNewCards Result String (List Card)
