-module({{name}}_tests_SUITE).
-include_lib("common_test/include/ct.hrl").

-export([all           /0]).
-export([init_per_suite/1]).
-export([end_per_suite /1]).
-export([dummy_test    /1]).

-type test_name() :: atom().
-type config() :: [{atom(), _}].

%%
%% tests descriptions
%%
-spec all() ->
    [test_name()].
all() ->
    [
        dummy_test
    ].

%%
%% starting/stopping
%%
-spec init_per_suite(config()) ->
    config().
init_per_suite(C) ->
    {ok, Apps} = application:ensure_all_started({{name}}),
    [{apps, Apps}|C].

-spec end_per_suite(config()) ->
    any().
end_per_suite(C) ->
    [application_stop(App) || App <- proplists:get_value(apps, C)].

application_stop(App=sasl) ->
    %% hack for preventing sasl deadlock
    %% http://erlang.org/pipermail/erlang-questions/2014-May/079012.html
    error_logger:delete_report_handler(cth_log_redirect),
    application:stop(App),
    error_logger:add_report_handler(cth_log_redirect),
    ok;
application_stop(App) ->
    application:stop(App).

%%
%% tests
%%
-spec dummy_test(config()) ->
    any().
dummy_test(_C) ->
    ok.
