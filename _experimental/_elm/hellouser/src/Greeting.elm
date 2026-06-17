module Greeting exposing (greet)

greet : String -> String
greet name =
    "Hello, " ++ name ++ "!"