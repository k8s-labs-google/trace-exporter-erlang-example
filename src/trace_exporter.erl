-module(trace_exporter).

-behaviour(gen_server).

-define(CLOUD_TRACE_URL(Project, TraceId, SpanId),
        <<"https://cloudtrace.googleapis.com/v2/projects/", Project, "/traces/", TraceId, "/spans/", SpanId, "/?key=AIzaSyDiE64Eil0GmV597ALmo3wZoGgShR1CvMo">>).

-export([start/0]).
-export([start/1]).
-export([start_link/0]).
-export([start_link/1]).

%% gen_server
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).

-define(SERVER, ?MODULE).
-define(DEFAULT_TTL, 300).

-spec start() -> {atom(), pid()}.
start() ->
  start(?DEFAULT_TTL).
-spec start(non_neg_integer()) -> {atom(), pid()}.
start(DefaultTTL) ->
  gen_server:start({local, ?SERVER}, ?SERVER,
                   #{default_ttl => DefaultTTL}, []).

-spec start_link() -> {atom(), pid()}.
start_link() ->
  start_link(?DEFAULT_TTL).
-spec start_link(non_neg_integer()) -> {atom(), pid()}.
start_link(DefaultTTL) ->
  gen_server:start_link({local, ?SERVER}, ?SERVER,
                        #{default_ttl => DefaultTTL}, []).


create_span(Span) ->
  {ok}.

%%%_ * gen_server callbacks --------------------------------------------

init(State) ->
  % egoth:new(),


  {ok, State}.

% handle_call({set_and_get, Key, LazyValue,
%             CurrenTokenExpiryTime}, _From,
%             State = #{default_ttl := DefaultTTL}) ->
%   % CurrenTokenExpiryTime is used to solve a race-condition
%   % that occurs when multiple processes are trying to
%   % replace an old token (i.e. the new token has a larger
%   % expiry time than the old token).
%   % case get_token(Key, CurrenTokenExpiryTime) of
%   %   {ok, Result} ->
%   %     {reply, {ok, Result}, State};
%   %   {error, not_found} ->
%   %     case LazyValue() of
%   %       {ok, Result, ExpireTime} ->
%   %         ExpiryTime = get_expire_time(ExpireTime, DefaultTTL),
%   %         % ets:insert(?TOKEN_CACHE_ID, {Key, Result, ExpiryTime}),
%   %         {reply, {ok, Result}, State};
%   %       {error, Reason} -> {reply, {error, Reason}, State}
%   %     end
%   end.

handle_call(_, Args, State) ->
  {ok, Args, State}.

handle_cast(_, State) -> {noreply, State}.

%%%_ * Private functions -----------------------------------------------



%%%_ * Tests -------------------------------------------------------

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

-endif.
