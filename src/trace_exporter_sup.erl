%%%-------------------------------------------------------------------
%% @doc trace_exporter top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(trace_exporter_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

-define(CLOUD_TRACE_URL(Project, TraceId, SpanId),
        <<"https://cloudtrace.googleapis.com/v2/projects/", Project, "/traces/", TraceId, "/spans/", SpanId, "/?key=AIzaSyDiE64Eil0GmV597ALmo3wZoGgShR1CvMo">>).

start_link() ->
    % os:putenv("GOOGLE_CREDENTIALS", "/Users/wbeebe/Downloads/terraform-seed-splunk-eada91d466bc.json"),
    {ok, _Headers, Client} =
        egoth:for_scope(<<"https://www.googleapis.com/auth/cloud-platform https://www.googleapis.com/auth/trace.append">>),
    Body = #{
        <<"startTime">> => <<"2020-08-21T06:30:59Z">>,
        <<"endTime">> => <<"2020-08-21T06:32:01Z">>,
        <<"spanId">> => <<"1234942831952321">>,
        <<"displayName">> => #{
            <<"value">> => <<"errrrlang los four">>,
            <<"truncatedByteCount">> => 0
        }
    },
    URL = ?CLOUD_TRACE_URL("terraform-seed-splunk", "299d39ee2b0af307536490dc37c11356", "1234942831952321"),
    {{ok, _Status1, _Headers1, _Response }, Client2} =
        egoth:request(
          post, json, URL, [200], [], Body, Client),
    Body2 = #{
        <<"startTime">> => <<"2020-08-21T06:30:59Z">>,
        <<"endTime">> => <<"2020-08-21T06:32:01Z">>,
        <<"spanId">> => <<"1234952831958321">>,
        <<"displayName">> => #{
            <<"value">> => <<"errrrlang los five">>,
            <<"truncatedByteCount">> => 0
        }
    },
    URL2 = ?CLOUD_TRACE_URL("terraform-seed-splunk", "299d39ee2b0af307536490dc37c11356", "1234952831958321"),
        {{ok, _Status2, _Headers2, _Response2 }, Client3} =
            egoth:request(
            post, json, URL2, [200], [], Body2, Client2),

    io:fwrite("Hello Worldddd!~n"),
    io:fwrite(_Response),
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
    SupFlags = #{strategy => one_for_all,
                 intensity => 0,
                 period => 1},
    ChildSpecs = [#{id => trace_exporter,
                    start => {trace_exporter, start_link, []},
                    restart => permanent,
                    shutdown => brutal_kill,
                    type => worker,
                    modules => [trace_exporter]}],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
