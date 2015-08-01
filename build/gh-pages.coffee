grunt = require 'grunt'

module.exports =

  'gh-pages': 
    options:
      base: 'gh-pages'
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
          'sketches/**/web-export-coffee/*'
          '!sketches/**/{code,template-coffee}/*'
          'README.md'
        ]
        dest: 'gh-pages/'
        filter: 'isFile'
      }
      {
        expand: yes
        cwd: 'node_modules/merlot'
        src: [
          'images/*'
          'stylesheets/*.{css,map}'
          'template.jst.html'
        ]
        dest: 'gh-pages/'
        filter: 'isFile'
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
        githubPath: 'hlfcoding/drawing-catalog-1'
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
