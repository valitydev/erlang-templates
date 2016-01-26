%% @doc Top level supervisor.
%% @end

-module({{name}}_sup).
-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%%

-spec start_link() -> {ok, pid()} | {error, {already_started, pid()}}.

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%%

init([]) ->
    {ok, {
        {one_for_all, 0, 1}, []
    }}.
