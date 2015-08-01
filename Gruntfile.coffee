matchdep = require 'matchdep'

aspects = {} # Like an aspect of work. Somewhat maps to directories and tasks.

aspects[name] = require "./build/#{name}" for name in [
  'docs', 'gh-pages', 'lib'
]

module.exports = (grunt) ->

  config =
    pkg: grunt.file.readJSON 'package.json'

    bower:
      lib: aspects.lib.bower

    clean:
      docs: aspects.docs.clean
      'gh-pages': aspects['gh-pages'].clean
      lib: aspects.lib.clean

    copy:
      'gh-pages': aspects['gh-pages'].copy
      lib: aspects.lib.copy

    'gh-pages':
      'gh-pages': aspects['gh-pages']['gh-pages']
      
    groc:
      docs: aspects.docs.groc

    markdown:
      'gh-pages': aspects['gh-pages'].markdown

  grunt.initConfig config

  grunt.loadNpmTasks plugin for plugin in matchdep.filterDev 'grunt-*'

  aspect.task() for name, aspect of aspects
