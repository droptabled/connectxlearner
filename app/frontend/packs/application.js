import 'bootstrap'
require('stylesheets/application')
require("@rails/ujs").start()
require("@rails/activestorage").start()
window.jQuery = require("jquery")

// Support component names relative to this directory:
var componentRequireContext = require.context("components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);
