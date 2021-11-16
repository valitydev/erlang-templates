-module(observability_SUITE).
-include_lib("common_test/include/ct.hrl").

-export([all/0]).
-export([init_per_suite/1]).
-export([end_per_suite/1]).
-export([health_check_works_test/1, prometheus_works_test/1]).

-type test_name() :: atom().
-type config() :: [{atom(), _}].

%%
%% tests descriptions
%%
-spec all() -> [test_name()].
all() ->
    [
        health_check_works_test,
        prometheus_works_test
    ].

%%
%% starting/stopping
%%
-spec init_per_suite(config()) -> config().
init_per_suite(C) ->
    application:set_env({{name}}, health_check, #{service => {erl_health, service, [<<"{{name}}">>]}}),
    {ok, Apps} = application:ensure_all_started({{name}}),
    [{apps, Apps} | C].

-spec end_per_suite(config()) -> any().
end_per_suite(C) ->
    [application:stop(App) || App <- proplists:get_value(apps, C)].

%%
%% tests
%%

-spec health_check_works_test(config()) -> any().
health_check_works_test(_) ->
    {ok, {Status, Headers, Body}} = httpc:request("http://localhost:8080/health"),
    {_, 200, "OK"} = Status,
    "application/json" = proplists:get_value("content-type", Headers),
    true = nomatch /= string:find(Body, "\"service\":\"{{name}}\"").

-spec prometheus_works_test(config()) -> any().
prometheus_works_test(_) ->
    {ok, {Status, Headers, Body}} = httpc:request("http://localhost:8080/metrics"),
    {_, 200, "OK"} = Status,
    true =
        nomatch /=
            string:prefix(
                proplists:get_value("content-type", Headers),
                "text/plain"
            ),
    true = nomatch /= string:find(Body, "erlang_vm_memory_bytes_total{kind=\"system\"}").
