-module(hellouser).
-export([start/0]).

start() ->
   Name = io:get_line("Enter your name: "),
   io:fwrite("Hello, ~s", [Name]).