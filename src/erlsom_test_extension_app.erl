%%%-------------------------------------------------------------------
%% @doc erlsom_test_extension public API
%% @end
%%%-------------------------------------------------------------------

-module(erlsom_test_extension_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    erlsom_test_extension_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
