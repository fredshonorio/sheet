module Cursor exposing (Cursor(..), location, isEditing)

import Matrix exposing (Location)


type Cursor
    = CSelected Location
    | CEditing Location String


location : Cursor -> Location
location c =
    case c of
        CSelected x ->
            x

        CEditing x _ ->
            x


isEditing : Cursor -> Bool
isEditing c =
    case c of
        CEditing _ _ ->
            True

        CSelected _ ->
            False
