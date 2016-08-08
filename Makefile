UTILS_PATH := build_utils/make_lib
TEMPLATES_PATH := .

SERVICE_NAME := service_erlang
SERVICE_IMAGE_TAG ?= $(shell git rev-parse HEAD)
SERVICE_IMAGE_PUSH_TAG ?= $(SERVICE_IMAGE_TAG)

BASE_IMAGE_NAME := base
BASE_IMAGE_TAG := 6de9b3bc9276ec00ec1d40fe1cfbc4b377faa622

all: gen

-include $(UTILS_PATH)/utils_image.mk

.PHONY: all submodules add_template gen clean

$(SUBTARGETS): %/.git: %
	git submodule update --init $<
	touch $@

submodules: $(SUBTARGETS)

add_template:
	mkdir -p ~/.config/rebar3/templates
	cp -rv ./* ~/.config/rebar3/templates

gen: add_template
	rebar3 new erlang-service name=snakeoil

clean:
	rm Dockerfile

