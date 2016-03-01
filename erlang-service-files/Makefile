REBAR := $(shell which rebar3 2>/dev/null || which ./rebar3)
RELNAME = {{name}}

.PHONY: all compile devrel start test clean distclean dialyze

all: compile

compile:
	$(REBAR) compile

devrel:
	$(REBAR) release

start: devrel
	_build/default/rel/${RELNAME}/bin/${RELNAME} console

test:
	$(REBAR) ct

clean:
	$(REBAR) clean

distclean:
	$(REBAR) clean -a
	rm -rfv _build _builds _cache _steps _temp

dialyze:
	$(REBAR) dialyzer
