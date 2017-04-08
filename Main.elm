module Main exposing (..)

import Html exposing (Html, pre, text, div, p, beginnerProgram, input, fieldset, label, section)
import Matrix exposing (Matrix, matrix)
import Cell exposing (RenderedCell(..), InputCell, show)


init : Matrix InputCell
init =
    matrix 10 10 (\(r, c) -> (InputCell (toString r ++ toString c)))


resolve : Matrix InputCell -> Matrix RenderedCell
resolve mat =
    let
        res =
            \{ input } -> Show False input
    in
        Matrix.map res mat


view : Matrix InputCell -> Html msg
view sheet =
    div [] [ sheet |> resolve |> show ]


update = always


main =
    beginnerProgram { model = init, view = view, update = update }
