UTILS_PATH := build_utils
TEMPLATES_PATH := .

SERVICE_NAME := service-erlang

#ToDo: Use the latest build image tag
BUILD_IMAGE_NAME := build-erlang
BUILD_IMAGE_TAG := 785d48cbfa7e7f355300c08ba9edc6f0e78810cb

CALL_W_CONTAINER := all gen_service gen_library submodules clean

SANITIZE_FIND_ARGS := service-templates/ library-templates/ -name "*.erl" -o -name "*.hrl"

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

format:
	find $(SANITIZE_FIND_ARGS) | xargs sed -i 's/{{\(\w\+\)}}/___\1___/g'
	rebar3 fmt -w
	find $(SANITIZE_FIND_ARGS) | xargs sed -i 's/___\(\w\+[^_]\)___/{{\1}}/g'

clean:
	rm Dockerfile
