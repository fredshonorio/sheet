module Msg exposing (..)
import Keyboard


type Msg
    = NoOp
    | Key Keyboard.KeyCode
