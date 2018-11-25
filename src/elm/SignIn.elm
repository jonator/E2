module SignIn exposing (..)

import Html exposing (..)
import Html.Attributes as Attrs
import Html.Events exposing (..)


type alias Model =
    { authenticateEmail : String
    , authenticatePassword : String
    , registerEmail : String
    , registerFirstName : String
    , registerLastName : String
    , registerPassword : String
    , validAuth : Bool
    , validReg : Bool
    }


type SignInMsg
    = TypeAuthEmail String
    | TypeAuthPass String
    | TypeRegEmail String
    | TypeRegFName String
    | TypeRegLName String
    | TypeRegPass String
    | Authenticate String String
    | Register String String String String


init : Bool -> Bool -> Model
init validAuth validReg =
    { authenticateEmail = ""
    , authenticatePassword = ""
    , registerEmail = ""
    , registerFirstName = ""
    , registerLastName = ""
    , registerPassword = ""
    , validAuth = validAuth
    , validReg = validReg
    }


update : SignInMsg -> Model -> Model
update msg model =
    case msg of
        TypeAuthEmail s ->
            { model | authenticateEmail = s }

        TypeAuthPass s ->
            { model | authenticatePassword = s }

        TypeRegEmail s ->
            { model | registerEmail = s }

        TypeRegFName s ->
            { model | registerFirstName = s }

        TypeRegLName s ->
            { model | registerLastName = s }

        TypeRegPass s ->
            { model | registerPassword = s }

        _ ->
            model


view : Model -> (SignInMsg -> msg) -> Html msg
view model upgrade =
    map upgrade <|
        div [ Attrs.class "sign-in-wrapper" ]
            [ div [ Attrs.class "sign-in" ]
                [ text "Log in!"
                , div [ Attrs.class "inputs" ]
                    [ input
                        [ Attrs.class "auth-email-input input"
                        , onInput TypeAuthEmail
                        , Attrs.placeholder "email"
                        ]
                        []
                    , input
                        [ Attrs.class "auth-pass-input input"
                        , onInput TypeAuthPass
                        , Attrs.placeholder "password"
                        , Attrs.type_ "password"
                        ]
                        []
                    , if not <| model.validAuth then
                        div [ Attrs.class "bad-auth" ]
                            [ text "There was a problem logging in!" ]
                      else
                        div [] []
                    , div
                        [ Attrs.class "auth-btn button"
                        , onClick <| Authenticate model.authenticateEmail model.authenticatePassword
                        ]
                        [ text "Log in" ]
                    ]
                ]
            , div [ Attrs.class "register" ]
                [ text "Register for a new account!"
                , div [ Attrs.class "inputs" ]
                    [ input
                        [ Attrs.class "reg-email-input input"
                        , onInput TypeRegEmail
                        , Attrs.placeholder "email"
                        ]
                        []
                    , input
                        [ Attrs.class "reg-fName-input input"
                        , onInput TypeRegFName
                        , Attrs.placeholder "first name"
                        ]
                        []
                    , input
                        [ Attrs.class "reg-lName-input input"
                        , onInput TypeRegLName
                        , Attrs.placeholder "last name"
                        ]
                        []
                    , input
                        [ Attrs.class "reg-pass-input input"
                        , onInput TypeRegPass
                        , Attrs.placeholder "password"
                        , Attrs.type_ "password"
                        ]
                        []
                    , if not <| model.validReg then
                        div [ Attrs.class "bad-reg" ]
                            [ text "There was a problem registering!" ]
                      else
                        div [] []
                    , div
                        [ Attrs.class "reg-btn button"
                        , onClick <| Register model.registerEmail model.registerFirstName model.registerLastName model.registerPassword
                        ]
                        [ text "Register" ]
                    ]
                ]
            ]
