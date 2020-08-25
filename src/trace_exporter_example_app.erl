%%%-------------------------------------------------------------------
%% @doc trace_exporter public API
%% @end
%%%-------------------------------------------------------------------

-module(trace_exporter_example_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [{"/", trace_handler, #{}}]}
    ]),
    {ok, _} = cowboy:start_clear(http,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}
    ),
    trace_exporter_sup:start_link().

stop(_State) ->
    ok = cowboy:stop_listener(http).

%% internal functions
