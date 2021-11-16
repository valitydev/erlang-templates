REBAR := $(shell which rebar3 2>/dev/null || which ./rebar3)
SUBMODULES = build_utils
SUBTARGETS = $(patsubst %,%/.git,$(SUBMODULES))

UTILS_PATH := build_utils
TEMPLATES_PATH := .

# Name of the service
SERVICE_NAME := {{name}}
# Service image default tag
SERVICE_IMAGE_TAG ?= $(shell git rev-parse HEAD)
# The tag for service image to be pushed with
SERVICE_IMAGE_PUSH_TAG ?= $(SERVICE_IMAGE_TAG)

# Base image for the service
BASE_IMAGE_NAME := service-erlang
BASE_IMAGE_TAG := $(BASE_IMAGE_TAG) # Replace with the current version (tag) for service-erlang image!

# Build image tag to be used
BUILD_IMAGE_NAME := build-erlang
BUILD_IMAGE_TAG := $(BUILD_IMAGE_TAG) # Replace with the current version (tag) for build image!

CALL_ANYWHERE := all submodules compile xref lint dialyze test \
                 shell release clean distclean format check_format

# Hint: 'test' might be a candidate for CALL_W_CONTAINER-only target
CALL_W_CONTAINER := $(CALL_ANYWHERE)

.PHONY: $(CALL_W_CONTAINER)

all: compile

-include $(UTILS_PATH)/make_lib/utils_container.mk
-include $(UTILS_PATH)/make_lib/utils_image.mk

$(SUBTARGETS): %/.git: %
	git submodule update --init $<
	touch $@

submodules: $(SUBTARGETS)

compile: submodules
	$(REBAR) compile

shell: submodules
	$(REBAR) shell

lint:
    # TODO: Fix to this as soon as prometheus_cowboy has plugins fixed
    # $(REBAR) lint
	elvis rock -V

check_format:
	$(REBAR) fmt -c

format:
	$(REBAR) fmt -w

test: submodules
	$(REBAR) do eunit, ct

xref: submodules
	$(REBAR) xref

clean:
	$(REBAR) clean

distclean:
	$(REBAR) clean -a
	rm -rfv _build

dialyze:
	$(REBAR) as test dialyzer

release: submodules
	$(REBAR) as prod release
