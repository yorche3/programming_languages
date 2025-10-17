module HelloUser exposing (main)

import Browser
import Html exposing (text)
import Greeting

main =
    Browser.sandbox
        { init = ()
        , update = \_ model -> model
        , view = \model -> text (Greeting.greet "Yorche")
        }