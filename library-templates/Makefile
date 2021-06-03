REBAR := $(shell which rebar3 2>/dev/null || which ./rebar3)

CALL_ANYWHERE := all submodules compile xref lint dialyze test \
shell clean distclean format check_format

# build_utils-only required part
SUBMODULES = build_utils
SUBTARGETS = $(patsubst %,%/.git,$(SUBMODULES))

ifneq ("$(wildcard $(SUBTARGETS))","")

SERVICE_NAME := {{name}}
SERVICE_IMAGE_TAG ?= $(shell git rev-parse HEAD)
SERVICE_IMAGE_PUSH_TAG ?= $(SERVICE_IMAGE_TAG)

UTILS_PATH := build_utils
TEMPLATES_PATH := .

# Build image tag to be used
BUILD_IMAGE_NAME := build-erlang
BUILD_IMAGE_TAG := $(BUILD_IMAGE_TAG) # Replace with the current version (tag) for build image!

CALL_W_CONTAINER := $(CALL_ANYWHERE)

-include $(UTILS_PATH)/make_lib/utils_container.mk
-include $(UTILS_PATH)/make_lib/utils_image.mk

endif

.PHONY: $(CALL_ANYWHERE) get_deps $(CALL_W_CONTAINER)

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
	$(REBAR) as test dialyzer
