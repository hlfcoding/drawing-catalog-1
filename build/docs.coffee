grunt = require 'grunt'

# For working docs generation, disable automatic trailing whitespace trimming.

module.exports =

  clean: [
    'docs/*'
    'docs/*/**'
    '!docs/.gitignore'
    '!docs/languages.coffee'
  ],

  groc:
    src: [
      'README.md'
      'sketches/**/*.pde'
      '!sketches/**/web-export-coffee/*.pde'
    ]
    options:
      index: 'README.md'
      out: 'docs/'
      languages: 'docs/languages.coffee'

  task: -> grunt.registerTask 'docs', ['clean:docs', 'groc:docs']
