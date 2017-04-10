module Cell exposing (InputCell, RenderedCell, show, Model, Mode(..))

import Html exposing (Html, text, tr, table, td, input)
import Html.Attributes exposing (style, id)
import Html.Events exposing (onInput)
import Matrix exposing (Matrix, Location, matrix)
import Cursor exposing (Cursor)
import Msg exposing (Msg)
import Navigation


type alias InputCell =
    { input : String }


type Mode
    = Editing
    | Show
    | Selected


type alias RenderedCell =
    { value : String, mode : Mode, location : Location }


type alias Model =
    { sheet : Matrix InputCell, cursor : Cursor }


show : Matrix RenderedCell -> Html Msg
show sheet =
    Matrix.toList sheet
        |> List.map showRow
        |> table []


showRow : List RenderedCell -> Html Msg
showRow row =
    row
        |> List.map showCell
        |> tr []


showCell : RenderedCell -> Html Msg
showCell { value, mode, location } =
    let
        common =
            [ ( "width", "50px" ) ]

        cellStyle =
            case mode of
                Selected ->
                    [ ( "background-color", "powderblue" ) ]

                _ ->
                    []

        cellElement =
            case mode of
                Editing ->
                    input [ onInput (Msg.Set location), id Navigation.inFocus ] []

                Show ->
                    text value

                Selected ->
                    text value
    in
        td [ style (common ++ cellStyle) ] [ cellElement ]
