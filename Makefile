UTILS_PATH := build_utils
TEMPLATES_PATH := .

SERVICE_NAME := service_erlang

#ToDo: Use the latest build image tag
BUILD_IMAGE_NAME := build-erlang
BUILD_IMAGE_TAG := 61a001bbb48128895735a3ac35b0858484fdb2eb

CALL_W_CONTAINER := all gen_service gen_library submodules clean

all: gen

-include $(UTILS_PATH)/make_lib/utils_container.mk

.PHONY: $(CALL_W_CONTAINER) add_template

$(SUBTARGETS): %/.git: %
	git submodule update --init $<
	touch $@

submodules: $(SUBTARGETS)

~/.config/rebar3/templates:
	mkdir -p ~/.config/rebar3/templates
	cp -rv ./* ~/.config/rebar3/templates

add_template: ~/.config/rebar3/templates

gen_service: add_template
	rebar3 new erlang-service name=snakeoil

gen_library: add_template
	rebar3 new erlang-service name=trickster

clean:
	rm Dockerfile
