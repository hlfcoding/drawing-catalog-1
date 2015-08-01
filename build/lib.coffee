grunt = require 'grunt'

module.exports =

  bower: # The rest is in Bower.json.
    options:
      cleanBowerDir: yes
      cleanTargetDir: no
      copy: yes
      install: yes
      layout: (type, component) -> type # Just the file.
      targetDir: './lib'
      verbose: yes

  copy:
    nonull: yes
    files: [
      {
        expand: yes
        cwd: 'lib'
        src: '*'
        dest: 'sketches/Elementary/template-coffee/'
      }
    ]

  clean: ['lib/*', '!lib/.gitignore']

  task: -> grunt.registerTask 'lib', ['clean:lib', 'bower:lib', 'copy:lib']

