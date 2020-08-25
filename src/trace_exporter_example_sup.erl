%%%-------------------------------------------------------------------
%% @doc trace_exporter top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(trace_exporter_example_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    SupFlags = #{strategy => one_for_all,
                 intensity => 0,
                 period => 1},
    ChildSpecs = [],
    % ChildSpecs = [#{id => trace_exporter_example,
    %                 start => {trace_exporter_example, start_link, []},
    %                 restart => permanent,
    %                 shutdown => brutal_kill,
    %                 type => worker,
    %                 modules => [trace_exporter_example]}],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
