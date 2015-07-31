#!/usr/bin/env bash

# Run from project root.

template=Elementary/template-coffee/
cp -v bower_components/dat-gui/build/dat.gui.min.js $template
cp -v bower_components/coffeescript/extras/coffee-script.js $template
cp -v bower_components/Processing.js/processing.js $template
cp -v bower_components/underscore/underscore-min.js $template
