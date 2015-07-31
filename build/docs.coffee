grunt = require 'grunt'

# For working docs generation, disable automatic trailing whitespace trimming.

src = [
  'sketches/**/*.pde'
  'docs/README.md'
]

module.exports =

  clean: [
    'docs/*/**'
    '!docs/.gitignore'
    '!docs/README.md'
  ],

  groc:
    src: src
    options:
      index: 'docs/README.md'
      out: 'docs/'

  task: -> grunt.registerTask 'docs', ['clean:docs', 'groc:docs']
