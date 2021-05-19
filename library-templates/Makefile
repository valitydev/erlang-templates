REBAR := $(shell which rebar3 2>/dev/null || which ./rebar3)

.PHONY: all get_deps ensure_elvis compile lint check_format \
		format test xref clean distclean dialyze plt_update shell

all: compile

get_deps:
	$(REBAR) get-deps

compile:
	$(REBAR) compile

shell: submodules
	$(REBAR) shell

lint:
	$(REBAR) lint

check_format:
	$(REBAR) fmt -c

format:
	$(REBAR) fmt -w

test:
	$(REBAR) do eunit, proper

xref:
	$(REBAR) xref

clean:
	$(REBAR) clean

distclean:
	$(REBAR) clean -a
	rm -rfv _build

dialyze:
	$(REBAR) dialyzer

plt_update:
	$(REBAR) dialyzer -u true -s false
