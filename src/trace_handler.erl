-module(trace_handler).

-export([init/2]).


init(Req0, Opts) ->
  Req = cowboy_req:reply(200, #{
      <<"content-type">> => <<"text/plain">>
  }, <<"Hello World!">>, Req0),
  {ok, Req, Opts}.

%%%_ * Private functions -----------------------------------------------



%%%_ * Tests -------------------------------------------------------

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

-endif.
