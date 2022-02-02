SANITIZE_FIND_ARGS := service-templates/ library-templates/ -name "*.erl" -o -name "*.hrl"

.PHONY: format

format:
	find $(SANITIZE_FIND_ARGS) | xargs sed -i 's/{{\(\w\+\)}}/___\1___/g'
	rebar3 fmt -w
	find $(SANITIZE_FIND_ARGS) | xargs sed -i 's/___\(\w\+[^_]\)___/{{\1}}/g'
