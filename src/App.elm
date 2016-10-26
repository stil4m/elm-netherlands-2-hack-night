port module App exposing (main)

import Html.App as Html exposing (program)
import Html exposing (..)
import Html.Attributes exposing (..)
import ProjectList
import ActiveProject
import AddProject
import Domain exposing (Project)
import Aui.Buttons as Aui


main : Program Never
main =
    program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


port createProject : Project -> Cmd msg


type alias Model =
    { projectList : ProjectList.Model
    , activeProject : ActiveProject.Model
    , addProject : Maybe AddProject.Model
    }


type Msg
    = ProjectListMsg ProjectList.Msg
    | ActiveProjectMsg ActiveProject.Msg
    | AddProjectMsg AddProject.Msg
    | Add


init : ( Model, Cmd Msg )
init =
    ( { projectList = ProjectList.init
      , activeProject = ActiveProject.init Nothing
      , addProject = Nothing
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ ProjectList.subscriptions model.projectList |> Sub.map ProjectListMsg
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Add ->
            ( { model | addProject = Just AddProject.init }, Cmd.none )

        AddProjectMsg x ->
            case model.addProject of
                Just addProject ->
                    let
                        ( newAddProject, addedProject ) =
                            AddProject.update x addProject
                    in
                        case addedProject of
                            AddProject.Remove ->
                                { model | addProject = Nothing } ! []

                            AddProject.NewProject newProject ->
                                ( { model
                                    | addProject = Nothing
                                    , projectList = ProjectList.addProject newProject model.projectList
                                  }
                                , createProject newProject
                                )

                            AddProject.NoInfo ->
                                { model | addProject = Just newAddProject } ! []

                Nothing ->
                    model ! []

        ActiveProjectMsg x ->
            let
                ( newActiveProject, maybeEdit ) =
                    ActiveProject.update x model.activeProject
            in
                ( { model | activeProject = newActiveProject }
                , Cmd.none
                )

        ProjectListMsg x ->
            let
                ( projectList, maybeActive ) =
                    ProjectList.update x model.projectList

                newActiveProject =
                    maybeActive |> Maybe.map (Just >> ActiveProject.init) |> Maybe.withDefault model.activeProject
            in
                ( { model | projectList = projectList, activeProject = newActiveProject }
                , Cmd.none
                )


view : Model -> Html Msg
view model =
    div [ class "aui-page-focused aui-page-focused-large" ]
        [ section []
            [ div
                [ class "aui-page-panel" ]
                [ div
                    [ class "aui-page-panel-inner" ]
                    [ section
                        [ class "aui-page-panel-content" ]
                        [ h2
                            []
                            [ text "Elm Netherlands 2 - Hack Night" ]
                        , projectsList model
                        , activeProject model
                        ]
                    ]
                ]
            ]
        , model.addProject
            |> Maybe.map (AddProject.view >> Html.map AddProjectMsg)
            |> Maybe.withDefault (div [] [])
        ]


projectsList : Model -> Html Msg
projectsList model =
    div [ style [ ( "width", "30%" ), ( "float", "left" ) ] ]
        [ Aui.button (Aui.baseConfig |> Aui.withStyle Aui.primaryStyle |> Aui.withAction Add)
            [ text "Add" ]
        , ProjectList.view model.projectList |> Html.map ProjectListMsg
        ]


activeProject : Model -> Html Msg
activeProject model =
    div [ style [ ( "width", "70%" ), ( "float", "left" ) ] ]
        [ ActiveProject.view model.activeProject |> Html.map ActiveProjectMsg
        ]
