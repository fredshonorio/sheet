module Cell exposing (InputCell, RenderedCell(..), show)

import Html exposing (Html, text, tr, table, td)
import Matrix exposing (Matrix, matrix)


type alias InputCell =
    { input : String
    }


type alias Selected =
    Bool


type RenderedCell
    = Editing InputCell
    | Show Selected String


type alias Model =
    Matrix InputCell


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
showCell i =
    let
        t =
            case i of
                Editing _ ->
                    ""

                Show _ s ->
                    s
    in
        td [] [ text t ]
