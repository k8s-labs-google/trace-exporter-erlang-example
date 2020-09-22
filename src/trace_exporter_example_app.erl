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

    Project = "terraform-seed-splunk",
    TraceId = "292d39ee5b0af307536490ac37c16355",
    SpanId = "1234942831924329",
    Body = #{
        startTime => <<"2020-08-26T15:01:23Z">>,
        endTime => <<"2020-08-26T15:01:25Z">>,
        spanId => <<"1234942831924329">>,
        displayName => #{
            value => <<"erlang rewrite bro">>,
            truncatedByteCount => 0
        }
    },

    % https://github.com/open-telemetry/opentelemetry-erlang/blob/master/src/ot_tracer_server.erl
    % pass in provider
    % ot_tracer_provider:init({sampler, })
    % ot_batch_processor:init(#{exporter => trace_exporter})

    % but maybe I need to integrate with the API and not the erlang SDK
    % it looks like there's overlap with the API and what we want as a standalone TraceExporter
    % https://github.com/open-telemetry/opentelemetry-erlang-api/blob/master/src/ot_tracer_provider.erl
    % _ = OpenTelemetry.register_application_tracer(:my_app),
    % Tracer = opentelemetry:get_tracer(pgo),
    % ot_tracer:with_span(Tracer, <<"pgo:query/3">>, fun() -> ... end).

    trace_exporter:create_span(Project, TraceId, SpanId, Body),



    %
    trace_exporter_example_sup:start_link().

stop(_State) ->
    ok = cowboy:stop_listener(http).

%% internal functions
