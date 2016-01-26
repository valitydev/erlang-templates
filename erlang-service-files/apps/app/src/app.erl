%% @doc Public API and application startup.
%% @end

-module({{name}}).
-behaviour(application).

%% Application callbacks
-export([start/2]).
-export([stop/1]).

%%

-spec start(normal, any()) -> {ok, pid()} | {error, any()}.

start(_StartType, _StartArgs) ->
    {{name}}_sup:start_link().

-spec stop(any()) -> ok.

stop(_State) ->
    ok.
