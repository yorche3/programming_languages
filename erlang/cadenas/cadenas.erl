%% ** this is the overview.doc file for the application 'frob' **
%%
%% @author Jorge Eduardo Ascencio Espíndola <hyaoki123@gmail.com>
%% @version 1.0.0
%% @doc 'cadenas' es un programa para ver cómo se tratan las cadenas,

-module(cadenas).
-export([start/0, palindromo/1]).

%% @doc
%% Verifica si una palabra es palindromo
%% @param W palabra a evaluar
%% @returns true si es palindromo, False en otro caso
%% @end
palindromo(W) ->
   if 
      W -> 
         io:fwrite("True"); 
      true -> 
         io:fwrite("False") 
   end,
   1.

start() ->
   io:format("Es palindromo: ~p\n", [palindromo(true)]).
