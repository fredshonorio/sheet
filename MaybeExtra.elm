module MaybeExtra exposing (..)

contains : comparable -> Maybe comparable -> Bool
contains a ma =
  case ma of
    Just x -> a == x
    Nothing -> False
