module Main exposing (main)

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Browser
import Html exposing (Html, b, br, div, h3, pre, text, ul)
import Http
import Json.Decode as JSON exposing (Decoder, field, index, string)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type Model
    = Failure
    | Loading
    | Success (List User)


type alias User =
    { id : Int
    , name : String
    , username : String
    , company : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , Http.get
        { url = "http://localhost:678/users"
        , expect = Http.expectJson GotText usersDecoder
        }
    )


usersDecoder : Decoder (List User)
usersDecoder =
    JSON.list
        (JSON.map4
            User
            (JSON.field "id" JSON.int)
            (JSON.field "name" JSON.string)
            (JSON.field "username" JSON.string)
            (JSON.field "company" JSON.string)
        )



-- UPDATE


type Msg
    = GotText (Result Http.Error (List User))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( Success fullText, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    Grid.container []
        [ CDN.stylesheet
        , br [] []
        , br [] []
        , viewUtil model
        ]


viewUtil : Model -> Html Msg
viewUtil model =
    case model of
        Failure ->
            text "Not able to load the data!"

        Loading ->
            text "Loading..."

        Success users ->
            users |> List.map userView |> ul []


userView : User -> Html Msg
userView user =
    div []
        [ h3 [] [ text (String.fromInt user.id) ]
        , pre [] [ b [] [ text "Name: " ], text user.name ]
        , pre [] [ b [] [ text "Username: " ], text user.username ]
        , pre [] [ b [] [ text "Company: " ], text user.company ]
        ]
