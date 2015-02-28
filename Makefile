
jquery.relatively-sticky.min.js: jquery.relatively-sticky.js
	uglifyjs --comments @license $< -o $@

jquery.relatively-sticky.js: jquery.relatively-sticky.coffee
	coffee -c $<
