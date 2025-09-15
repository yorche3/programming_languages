%%%-------------------------------------------------------------------
%% @doc numbers public API
%% @end
%%%-------------------------------------------------------------------

-module(numbers_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    numbers_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
