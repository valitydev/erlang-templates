REBAR := $(shell which rebar3 2>/dev/null || which ./rebar3)
DOCKER := $(shell which docker 2>/dev/null)
PACKER := $(shell which packer 2>/dev/null)
RELNAME = {{name}}

BASE_DIR := $(shell pwd)

.PHONY: all compile devrel start test clean distclean dialyze lint release containerize

all: compile

compile:
	$(REBAR) compile

rebar-update:
	$(REBAR) update

devrel:
	$(REBAR) release

start: devrel
	$(REBAR) run

test:
	$(REBAR) ct

xref:
	$(REBAR) xref

clean:
	$(REBAR) clean

distclean:
	$(REBAR) clean -a
	rm -rfv _build _builds _cache _steps _temp

dialyze:
	$(REBAR) dialyzer

lint:
	elvis rock

release: $(DOCKER) ~/.docker/config.json distclean
	$(DOCKER) run --rm -v $(BASE_DIR):$(BASE_DIR) --workdir $(BASE_DIR) rbkmoney/build_erlang rebar3 as prod release

containerize: $(PACKER) release ./packer.json
	$(PACKER) build packer.json

~/.docker/config.json:
	test -f ~/.docker/config.json || (echo "Please run: docker login" ; exit 1)

