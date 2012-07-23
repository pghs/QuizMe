// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

if (!window.console) console = {log: function() {}}

function DummyMixpanel() {
	this.track = function() {};
	this.track_pageview = function() {};
	this.track_links = function() {};
	this.track_forms = function() {};
	this.register = function() {};
	this.register_once = function() {};
	this.unregister = function() {};
	this.identify = function() {};
	this.name_tag = function() {};
	this.set_config = function() {};
}