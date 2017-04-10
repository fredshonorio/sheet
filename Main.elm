module Main exposing (..)

import Html exposing (Html, pre, text, div, p, input, fieldset, label, section)
import Matrix exposing (Matrix, matrix, Location)
import Cell exposing (RenderedCell, InputCell, show, Mode(..))
import Tuple
import Keyboard
import Platform.Cmd
import Navigation exposing (Size, direction, updateSelection)
import Msg exposing (Msg(..))
import Cell exposing (Model)
import MaybeExtra


dimensions : Size
dimensions =
    ( 10, 10 )


init : Model
init =
    { sheet =
        matrix (Tuple.first dimensions) (Tuple.second dimensions) (\( r, c ) -> (InputCell (toString r ++ toString c)))
    , selected = Just ( 0, 0 )
    }


selectCell : Maybe Location -> Location -> Mode
selectCell selected location =
    if MaybeExtra.contains location selected then
        Selected
    else
        Show


flip : Location -> Location
flip ( x, y ) =
    ( y, x )


evaluate : Model -> Matrix RenderedCell
evaluate { sheet, selected } =
    let
        res =
            \loc { input } -> { value = input, mode = (selectCell selected (flip loc)) }
    in
        -- the old (i, j), (j, i) debacle
        Matrix.mapWithLocation res sheet


view : Model -> Html Msg
view sheet =
    div [] [ sheet |> evaluate |> show ]


select : Keyboard.KeyCode -> Location -> Location
select code =
    code |> direction |> updateSelection dimensions


update : Msg -> Model -> ( Model, Cmd Msg )
update msg { sheet, selected } =
    let
        s =
            case msg of
                Key code ->
                    Maybe.map (select code) selected

                _ ->
                    selected
    in
        ( Model sheet s, Cmd.none )


main : Program Never Model Msg
main =
    Html.program { init = ( init, Cmd.none ), view = view, update = update, subscriptions = subscriptions }


subscriptions : a -> Sub Msg
subscriptions a =
    Sub.batch [ Keyboard.downs Key ]
