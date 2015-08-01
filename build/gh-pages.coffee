grunt = require 'grunt'

module.exports =

  'gh-pages': 
    options:
      base: 'gh-pages'
      add: yes
    src: [
      '**'
      '!template.jst.html'
    ]

  clean: [
    'gh-pages/*'
    '!gh-pages/.gitignore'
    '!gh-pages/template.jst.html'
  ]

  copy:
    nonull: yes
    files: [
      {
        expand: yes
        src: [
          'docs/**/*'
          'sketches/**/*'
          'README.md'
        ]
        dest: 'gh-pages/'
      }
      {
        src: 'node_modules/merlot/template.jst.html'
        dest: 'gh-pages/'
      }
    ]

  markdown:
    options:
      markdownOptions:
        gfm: yes
        highlight: 'auto'
      template: 'gh-pages/template.jst.html'
      templateContext:
        githubAuthor: 'hlfcoding'
        githubPath: 'hlfcoding/hlf-jquery'
        headline: 'Drawing Catalog #1'
        pageTitle: 'Drawing Catalog #1 by hlfcoding'
        subHeadline: 'CoffeeScript Processing Sketches'

    src: 'gh-pages/README.md'
    dest: 'gh-pages/index.html'

  task: ->
    grunt.registerTask 'pages', [
      'docs'
      'clean:gh-pages'
      'copy:gh-pages'
      'markdown:gh-pages'
      'gh-pages:gh-pages'
    ]
