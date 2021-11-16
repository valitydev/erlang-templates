%%% @doc Public API, supervisor and application startup.
%%% @end

-module({{name}}).
-behaviour(supervisor).
-behaviour(application).

%% API
-export([start/0]).
-export([stop/0]).

%% Supervisor callbacks
-export([init/1]).

%% Application callbacks
-export([start/2]).
-export([stop/1]).

%% Conf functions
-export([woody_event_handlers/0]).

-define(DEFAULT_PORT, 8080).
-define(DEFAULT_HANDLING_TIMEOUT, 60_000).

-type cowboy_route_path() :: {Path :: iodata(), Handler :: module(), Opts :: any()}.

%%
%% API
%%
-spec start() -> {ok, _}.
start() ->
    application:ensure_all_started({{name}}).

-spec stop() -> ok.
stop() ->
    application:stop({{name}}).

%%
%% Supervisor callbacks
%%
-spec init([]) -> {ok, {supervisor:sup_flags(), [supervisor:child_spec()]}}.
init([]) ->
    WoodyHandlerOpts = #{
        default_handling_timeout =>
            genlib_app:env({{name}}, default_woody_handling_timeout, ?DEFAULT_HANDLING_TIMEOUT)
    },
    HealthCheckConfig = genlib_app:env(?MODULE, health_check, #{}),

    WoodyServerSpec =
        woody_server:child_spec(
            ?MODULE,
            #{
                ip => parse_ip(genlib_app:env(?MODULE, ip, "::")),
                port => genlib_app:env(?MODULE, port, ?DEFAULT_PORT),
                transport_opts => genlib_app:env(?MODULE, transport_opts, #{}),
                protocol_opts => genlib_app:env(?MODULE, protocol_opts, #{}),
                event_handler => woody_event_handlers(),
                %% Woody services to call are to be placed here
                handlers => construct_service_handlers(WoodyHandlerOpts, [
                    {sample_service, {{name}}_sample_service_handler}
                ]),
                additional_routes =>
                    (get_health_routes(HealthCheckConfig) ++
                        get_prometheus_routes()),
                shutdown_timeout => genlib_app:env(?MODULE, shutdown_timeout, 0)
            }
        ),
    {ok,
        {
            #{
                strategy => one_for_all,
                intensity => 0,
                period => 1
            },
            [WoodyServerSpec]
        }}.

%%
%% Application callbacks
%%
-spec start(normal, any()) -> {ok, pid()} | {error, any()}.
start(_StartType, _StartArgs) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

-spec stop(any()) -> ok.
stop(_State) ->
    ok.

-spec parse_ip(string()) -> inet:ip_address().
parse_ip(IpStr) ->
    {ok, Ip} = inet:parse_address(IpStr),
    Ip.

-spec get_health_routes(erl_health:check()) -> [cowboy_route_path()].
get_health_routes(Checks) ->
    EvHandler = {erl_health_event_handler, []},
    HealthCheck = maps:map(fun(_, V = {_, _, _}) -> #{runner => V, event_handler => EvHandler} end, Checks),
    [erl_health_handle:get_route(HealthCheck)].

-spec get_prometheus_routes() -> [cowboy_route_path()].
get_prometheus_routes() ->
    [{"/metrics/[:registry]", prometheus_cowboy2_handler, []}].

construct_service_handlers(Opts, Specs) ->
    lists:map(
        fun
            ({Name, Module}) ->
                construct_service_handler(Name, Module, Opts);
            ({Name, Module, ExtraOpts}) ->
                construct_service_handler(Name, Module, maps:merge(Opts, ExtraOpts))
        end,
        Specs
    ).

construct_service_handler(Name, Module, Opts) ->
    FullOpts = maps:merge(#{handler => Module}, Opts),
    {Path, Service} = {{name}}_proto:get_service_spec(Name),
    {Path, {Service, {{{name}}_woody_wrapper, FullOpts}}}.

-spec woody_event_handlers() -> woody:ev_handlers().
woody_event_handlers() ->
    [
        {scoper_woody_event_handler, genlib_app:env(?MODULE, scoper_event_handler_options, #{})}
    ].
