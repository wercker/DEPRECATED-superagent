
TESTS = test/node/*.js
REPORTER = dot

all: superagent.js

test:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--require should \
		--reporter $(REPORTER) \
		--timeout 5000 \
		--growl \
		$(TESTS)

test-browser: superagent.js
	@./node_modules/.bin/zuul \
		--local 18080 \
		-- test/index.js

test-phantom: superagent.js
	@./node_modules/.bin/zuul \
		-- phantom \
		-- test/index.js

test-sauce: superagent.js
	@./node_modules/.bin/zuul \
		-- test/index.js

test-cov: lib-cov
	SUPERAGENT_COV=1 $(MAKE) test REPORTER=html-cov > coverage.html

lib-cov:
	jscoverage lib lib-cov

superagent.js: components
	@./node_modules/.bin/component build \
	  --standalone superagent \
	  --out . --name superagent

components:
	@./node_modules/.bin/component install

docs: test-docs

test-docs:
	make test REPORTER=doc \
		| cat docs/head.html - docs/tail.html \
		> docs/test.html

clean:
	rm -fr superagent.js components

.PHONY: test-cov test docs test-docs clean test-browser
