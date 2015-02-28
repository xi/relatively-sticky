
jquery.sticky-kit.min.js: jquery.sticky-kit.js
	uglifyjs --comments @license $< -o $@

jquery.sticky-kit.js: jquery.sticky-kit.coffee
	coffee -c $<
