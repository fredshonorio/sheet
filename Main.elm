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
import Cursor exposing (Cursor)
import Task
import Dom

dimensions : Size
dimensions =
    ( 10, 10 )


init : Model
init =
    { sheet =
        matrix (Tuple.first dimensions) (Tuple.second dimensions) (\( r, c ) -> (InputCell (toString r ++ toString c)))
    , cursor = Cursor.CSelected ( 0, 0 )
    }


cellMode : Cursor -> Location -> Mode
cellMode cursor cellLocation =
    let
        isThis =
            (Cursor.location cursor) == cellLocation
    in
        case ( cursor, isThis ) of
            ( Cursor.CSelected _, True ) ->
                Selected

            ( Cursor.CEditing _ _, True ) ->
                Editing

            _ ->
                Show


flip : Location -> Location
flip ( x, y ) =
    ( y, x )


evaluate : Model -> Matrix RenderedCell
evaluate { sheet, cursor } =
    let
        res =
            \loc { input } -> { value = input, mode = (cellMode cursor (flip loc)), location = loc }
    in
        -- the old (i, j), (j, i) debacle
        Matrix.mapWithLocation res sheet


view : Model -> Html Msg
view sheet =
    div [] [ sheet |> evaluate |> show ]


select : Keyboard.KeyCode -> Location -> Location
select code =
    code |> direction |> updateSelection dimensions


updateCursor : Keyboard.KeyCode -> Model -> (Cursor, Bool)
updateCursor code { sheet, cursor } =
    let
        location =
            Cursor.location cursor

        prevValue =
            (Matrix.get location sheet) |> Maybe.map .input |> Maybe.withDefault ""

        return =
            Navigation.isReturn code

        editing =
            Cursor.isEditing cursor

        valid =
            Navigation.validDirection code
    in
        case ( return, editing, valid ) of
            ( True, True, _ ) ->
                {- stop editing cell -}
                (Cursor.CSelected location, False)

            ( True, False, _ ) ->
                {- start editing cell -}
                (Cursor.CEditing (location) prevValue, True)

            ( False, True, _ ) ->
                {- keep editing cell -}
                (Cursor.CEditing (location) prevValue, False)

            ( False, False, True ) ->
                {- navigate -}
                (Cursor.CSelected (select code location), False)

            ( False, False, False ) ->
                {--do nothing-}
                (cursor, False)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ sheet, cursor } as model) =
    let
        (cursor_, shouldFocus) =
            case msg of
                Key code ->
                    updateCursor code model

                Set _ _ ->
                    (cursor, False)

                NoOp ->
                    (cursor, False)
                Focus _ ->
                    (cursor, False)

        sheet_ =
            case msg of
                Set loc value ->
                    sheet |> Matrix.set loc (InputCell value)

                Key _ ->
                    sheet

                NoOp ->
                    sheet

                Focus _ ->
                        sheet

        nothing0 =
            Debug.log "msg" msg

        nothing1 =
            Debug.log "cursor_" cursor_

        nothing2 =
            Debug.log "sheet_" sheet_

        cmd = if shouldFocus then
            Task.attempt Focus (Dom.focus Navigation.inFocus)
          else
            Cmd.none
    in
        ( Model sheet cursor_, cmd )


main : Program Never Model Msg
main =
    Html.program { init = ( init, Cmd.none ), view = view, update = update, subscriptions = subscriptions }


subscriptions : a -> Sub Msg
subscriptions a =
    Sub.batch [ Keyboard.downs Key ]
