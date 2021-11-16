-module({{name}}_tests_SUITE).
-include_lib("common_test/include/ct.hrl").

-export([all/0]).
-export([init_per_suite/1]).
-export([end_per_suite/1]).
-export([dummy_test/1]).

-type test_name() :: atom().
-type config() :: [{atom(), _}].

%%
%% tests descriptions
%%
-spec all() -> [test_name()].
all() ->
    [
        dummy_test
    ].

%%
%% starting/stopping
%%
-spec init_per_suite(config()) -> config().
init_per_suite(C) ->
    {ok, Apps} = application:ensure_all_started({{name}}),
    [{apps, Apps} | C].

-spec end_per_suite(config()) -> any().
end_per_suite(C) ->
    [application:stop(App) || App <- proplists:get_value(apps, C)].

%%
%% tests
%%
-spec dummy_test(config()) -> any().
dummy_test(_C) ->
    {ok, <<"Hello, World!">>} =
        woody_client:call(
            {{{name}}_proto:get_service(sample_service), 'SampleFunction', {}},
            #{url => <<"http://localhost:8080/v1/sample_service">>, event_handler => woody_event_handler_default}
        ).
