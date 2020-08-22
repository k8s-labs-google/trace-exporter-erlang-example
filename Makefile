deps:
	rebar3 deps get

compile: deps
	rebar3 compile

test: compile
	rebar3 as test do dialyzer,eunit,cover

refresh:
	rm -rf _build
	rm rebar.lock
	rebar3 deps get
	rebar3 compile
	rebar3 shell

elvis:
ifdef ELVIS_IN_PATH
	elvis git-branch origin/HEAD -V
else ifdef ELVIS_LOCAL
	.elvis/_build/default/bin/elvis git-branch origin/HEAD -V
else
	$(MAKE) compile_elvis
	.elvis/_build/default/bin/elvis git-branch origin/HEAD -V
endif

elvis_rock:
ifdef ELVIS_IN_PATH
	elvis rock
else ifdef ELVIS_LOCAL
	.elvis/_build/default/bin/elvis rock
else
	$(MAKE) compile_elvis
	.elvis/_build/default/bin/elvis rock
endif

compile_elvis:
	git clone https://github.com/inaka/elvis.git .elvis && \
	cd .elvis && \
	rebar3 compile && \
	rebar3 escriptize && \
	cd ..
