-module({{name}}_sample_service_handler).

-behaviour({{name}}_woody_wrapper).

-export([handle_function/3]).

-spec handle_function(woody:func(), woody:args(), {{name}}_woody_wrapper:context()) -> term() | no_return().
handle_function('SampleFunction', _Args, _Context = #{woody_context := _}) ->
    <<"Hello, World!">>.
