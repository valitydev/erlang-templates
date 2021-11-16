-module({{name}}_woody_wrapper).

%% Woody handler

-behaviour(woody_server_thrift_handler).

-export([handle_function/4]).

-export_type([handler_opts/0]).
-export_type([context/0]).
-export_type([client_opts/0]).

-type handler_opts() :: #{
    handler := module(),
    default_handling_timeout => timeout()
}.

-type context() :: #{
    woody_context => woody:context(),
    default_handling_timeout => timeout()
}.

-type client_opts() :: #{
    url := woody:url(),
    transport_opts => [{_, _}],
    deadline => woody:deadline()
}.

% 30 seconds
-define(DEFAULT_HANDLING_TIMEOUT, 30000).

%% Callbacks

-callback handle_function(woody:func(), woody:args(), context()) -> term() | no_return().

%% API

-export([call/4]).
-export([call/5]).

-export([get_service_options/1]).

-spec handle_function(woody:func(), woody:args(), woody_context:ctx(), handler_opts()) -> {ok, term()} | no_return().
handle_function(Func, Args, WoodyContext0, #{handler := Handler} = Opts) ->
    WoodyContext = ensure_woody_deadline_set(WoodyContext0, Opts),
    Context = maps:put(woody_context, WoodyContext, Opts),
    {ok, Handler:handle_function(Func, Args, Context)}.

-spec call(atom(), woody:func(), woody:args(), context()) -> term().
call(ServiceName, Function, Args, Context) ->
    Opts = get_service_options(ServiceName),
    call(ServiceName, Function, Args, Opts, Context).

-spec call(atom(), woody:func(), woody:args(), client_opts(), context()) -> term().
call(ServiceName, Function, Args, Opts, Context) ->
    Service = {{name}}_proto:get_service(ServiceName),
    WoodyContext = maps:get(woody_context, Context),
    Request = {Service, Function, Args},
    try
        woody_client:call(
            Request,
            Opts#{event_handler => {{name}}:woody_event_handlers()},
            WoodyContext
        )
    catch
        throw:Reason ->
            woody_error:raise(business, Reason)
    end.

-spec get_service_options(atom()) -> client_opts().
get_service_options(ServiceName) ->
    construct_opts(maps:get(ServiceName, genlib_app:env({{name}}, services))).

%% Internal functions
construct_opts(Opts = #{url := Url}) ->
    Opts#{url := genlib:to_binary(Url)};
construct_opts(Url) ->
    #{url => genlib:to_binary(Url)}.

-spec ensure_woody_deadline_set(woody_context:ctx(), handler_opts()) -> woody_context:ctx().
ensure_woody_deadline_set(WoodyContext, Opts) ->
    case woody_context:get_deadline(WoodyContext) of
        undefined ->
            DefaultTimeout = maps:get(default_handling_timeout, Opts, ?DEFAULT_HANDLING_TIMEOUT),
            Deadline = woody_deadline:from_timeout(DefaultTimeout),
            woody_context:set_deadline(Deadline, WoodyContext);
        _Other ->
            WoodyContext
    end.
