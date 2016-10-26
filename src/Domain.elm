module Domain exposing (Project, Projects)


type alias Project =
    { key : Maybe String
    , name : String
    , title : String
    , description : String
    }


type alias Projects =
    List Project
