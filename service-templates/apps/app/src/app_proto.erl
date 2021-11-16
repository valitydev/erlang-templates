-module({{name}}_proto).

-export([get_service/1]).
-export([get_service_spec/1]).

-export_type([service/0]).
-export_type([service_spec/0]).

-define(VERSION_PREFIX, "/v1").

-type service() :: woody:service().
-type service_spec() :: {Path :: string(), service()}.

-spec get_service(Name :: atom()) -> service().
get_service(Name) ->
    {_Path, Service} = get_service_spec(Name),
    Service.

-spec get_service_spec(Name :: atom()) -> service_spec().
get_service_spec(sample_service) ->
    {?VERSION_PREFIX ++ "/sample_service", {{{name}}_sample_service_thrift, 'SampleService'}}.
