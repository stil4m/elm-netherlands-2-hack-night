port module ProjectList exposing (..)

import Domain exposing (Project, Projects)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


port projects : (Projects -> msg) -> Sub msg


type alias Model =
    Maybe Projects


type Msg
    = NewProjects Projects
    | Focus Project


init : Model
init =
    Nothing


addProject : Project -> Model -> Model
addProject project model =
    model
        |> Maybe.map (flip (++) [ project ])


subscriptions : Model -> Sub Msg
subscriptions model =
    projects NewProjects


update : Msg -> Model -> ( Model, Maybe Project )
update msg model =
    case msg of
        NewProjects n ->
            ( Just n, Nothing )

        Focus p ->
            ( model, Just p )


view : Model -> Html Msg
view m =
    case m of
        Nothing ->
            div [] [ text "Loading!" ]

        Just projects ->
            ul [ class "projects", style [ ( "list-style", "none" ), ( "padding", "0" ) ] ]
                (List.map projectItem projects)


projectItem : Project -> Html Msg
projectItem project =
    li
        [ class "project"
        , style [ ( "padding", "10px" ), ( "border-top", "1px solid #ddd" ), ( "pointer", "cursor" ) ]
        , onClick (Focus project)
        ]
        [ p [] [ strong [] [ text project.title ] ]
        , p [] [ text project.name ]
        ]
