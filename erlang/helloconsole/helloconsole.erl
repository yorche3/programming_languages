-module(helloconsole).
-export([start/0]).

start() ->
   Name = io:get_line("Cual es tu nombre?   "),
   io:fwrite("Hola ~s", [Name]).