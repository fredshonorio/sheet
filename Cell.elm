module Cell exposing (InputCell, RenderedCell, show, Model, Mode(..))

import Html exposing (Html, text, tr, table, td)
import Html.Attributes exposing (style)
import Matrix exposing (Matrix, Location, matrix)


type alias InputCell =
    { input : String
    }


type Mode
    = Editing
    | Show
    | Selected


type alias RenderedCell =
    { value : String, mode : Mode }


type alias Model =
    { sheet : Matrix InputCell
    , selected : Maybe Location
    }


show : Matrix RenderedCell -> Html msg
show sheet =
    Matrix.toList sheet
        |> List.map showRow
        |> table []


showRow : List RenderedCell -> Html msg
showRow row =
    row
        |> List.map showCell
        |> tr []


showCell : RenderedCell -> Html msg
showCell cell =
    let
        t =
            cell.value

        st =
            case cell.mode of
                Selected ->
                    [ style [ ( "background-color", "powderblue" ) ] ]

                _ ->
                    []
    in
        td st [ text t ]
