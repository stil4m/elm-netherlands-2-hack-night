module ActiveProject exposing (..)

import Domain exposing (Project)
import Html exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    Maybe Project


type Msg
    = Edit Project
    | Close


init : Maybe Project -> Model
init project =
    project


update : Msg -> Model -> ( Model, Maybe Project )
update msg model =
    case msg of
        Edit project ->
            ( model, Just project )

        Close ->
            ( Nothing, Nothing )


view : Model -> Html Msg
view model =
    case model of
        Nothing ->
            div [] []

        Just project ->
            viewProject project


viewProject : Project -> Html Msg
viewProject project =
    div [ style [ ( "padding", "0 20px" ) ] ]
        [ h1 [] [ text project.title ]
        , p [] [ i [] [ text project.name ] ]
        , p [] [ text project.description ]
        ]
