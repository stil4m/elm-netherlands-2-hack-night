module AddProject exposing (..)

import Domain exposing (Project)
import Html exposing (..)
import Html.Events exposing (onInput)
import Html.Attributes exposing (..)
import Dialog exposing (..)
import Aui.Buttons as Aui


type alias Model =
    { title : String
    , author : String
    , description : String
    }


type Msg
    = SetTitle String
    | SetAuthor String
    | SetDescription String
    | Submit
    | Close


init : Model
init =
    { title = ""
    , author = ""
    , description = ""
    }


type Info
    = NewProject Project
    | Remove
    | NoInfo


update : Msg -> Model -> ( Model, Info )
update msg model =
    case msg of
        SetTitle title ->
            ( { model | title = title }, NoInfo )

        SetDescription description ->
            ( { model | description = description }, NoInfo )

        SetAuthor author ->
            ( { model | author = author }, NoInfo )

        Close ->
            ( model, Remove )

        Submit ->
            ( model, NewProject { key = Nothing, title = model.title, name = model.author, description = model.description } )


view : Model -> Html Msg
view model =
    div
        []
        [ Dialog.view <|
            Just
                { closeMessage = Just Close
                , containerClass = Just "your-container-class"
                , header = Just (h3 [] [ text "Add Project" ])
                , body = Just (projectForm model)
                , footer = Just footer
                }
        ]


footer : Html Msg
footer =
    Aui.button (Aui.baseConfig |> Aui.withAction Submit)
        [ text "Submit"
        ]


projectForm : Model -> Html Msg
projectForm model =
    Html.form [ class "form-horizontal" ]
        [ div [ class "form-group" ]
            [ label [ class "col-sm-2 control-label" ] [ text "Title" ]
            , div
                [ class "col-sm-10" ]
                [ input
                    [ onInput SetTitle, type' "text", class "form-control", placeholder "Title", defaultValue model.title ]
                    []
                ]
            ]
        , div [ class "form-group" ]
            [ label [ class "col-sm-2 control-label" ] [ text "Author" ]
            , div
                [ class "col-sm-10" ]
                [ input
                    [ onInput SetAuthor, type' "text", class "form-control", placeholder "Author", defaultValue model.author ]
                    []
                ]
            ]
        , div [ class "form-group" ]
            [ label [ class "col-sm-2 control-label" ] [ text "Description" ]
            , div
                [ class "col-sm-10" ]
                [ textarea
                    [ onInput SetDescription, class "form-control", placeholder "Description", defaultValue model.description ]
                    []
                ]
            ]
        ]
