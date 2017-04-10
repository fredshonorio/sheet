module Msg exposing (..)

import Keyboard
import Matrix exposing (Location)
import Dom

type Msg
    = NoOp
    | Key Keyboard.KeyCode
    | Set Location String
    | Focus (Result Dom.Error ())
