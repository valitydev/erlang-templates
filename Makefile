SANITIZE_FIND_ARGS := service-templates/ library-templates/ -name "*.erl" -o -name "*.hrl"

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
