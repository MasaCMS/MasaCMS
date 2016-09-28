module.exports = function(grunt) {

  grunt.initConfig({
      handlebars: {
          all: {
              files: {
                  'src/templates/compiled.js': ['src/templates/*.hbs']
              },
              options: {
                   namespace: 'mura.templates',
                   processName: function(filePath) {
                    var name=filePath.split('/');
                    name=name[name.length-1];
                    name=name.split('.');
                    return name[0].toLowerCase();
                    }
              }
          }
      },
      replace: {
        prevent_templates_example: {
                src: ['src/templates.js'],
                dest: 'src/templates.js',
                options: {
                  processTemplates: false
                },
                replacements: [{
                      from: 'Handlebars',
                      to: function () {
                        return "window.mura.Handlebars";
                      }
                }]
            }
        },
    concat: {
          options: {
            separator: ';',
          },
          dist: {
            src: [
            'src/templates.js',
            'src/theme.js'
            ],
            dest: 'theme.js',
          },
    },
    uglify: {
      my_target: {
        files: {
          'theme.min.js': ['theme.js']
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-text-replace');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-handlebars');
  grunt.registerTask('default',['handlebars','replace','concat','uglify']);


};
