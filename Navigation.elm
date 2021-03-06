module Navigation exposing (..)

import Keyboard exposing (KeyCode)
import Matrix exposing (Location)
import Dom


inFocus : Dom.Id
inFocus =
    "inFocus"


type Direction
    = Up
    | Down
    | Left
    | Right
    | None


type alias Size =
    ( Int, Int )


isReturn : KeyCode -> Bool
isReturn =
    (==) 13


direction : KeyCode -> Direction
direction code =
    case code of
        38 ->
            Up

        40 ->
            Down

        37 ->
            Left

        39 ->
            Right

        _ ->
            None


validDirection : KeyCode -> Bool
validDirection code =
    case (direction code) of
        None ->
            False

        _ ->
            True


updateSelection : Size -> Direction -> Location -> Location
updateSelection size dir ( x, y ) =
    case dir of
        Up ->
            ( x, clampY size (y - 1) )

        Down ->
            ( x, clampY size (y + 1) )

        Left ->
            ( clampX size (x - 1), y )

        Right ->
            ( clampX size (x + 1), y )

        None ->
            ( x, y )


clamp0 : Int -> Int -> Int
clamp0 mi i =
    max 0 (min (mi - 1) i)


clampX : Size -> Int -> Int
clampX ( maxX, _ ) =
    clamp0 maxX


clampY : Size -> Int -> Int
clampY ( _, maxY ) =
    clamp0 maxY
