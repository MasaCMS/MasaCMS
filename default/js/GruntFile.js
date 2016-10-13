module.exports = function(grunt) {

  grunt.initConfig({
      handlebars: {
          all: {
              files: {
                  'src/templates/compiled.js': ['src/templates/*.hb','src/templates/*.hbs']
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
                src: ['src/templates/compiled.js'],
                dest: 'src/templates/compiled.js',
                options: {
                  processTemplates: false
                },
                replacements: [{
                      from: 'Handlebars',
                      to: function () {
                        return "this.mura.Handlebars";
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
          'external/polyfill.js',
          'external/handlebars.runtime-v4.0.5.js',
          'src/mura.js',
          //'src/mura.purl.js',
          //'src/mura.ua-parser.js',
          'src/mura.loader.js',
          'src/mura.core.js',
          'src/mura.cache.js',
          'src/mura.domselection.js',
          'src/mura.entity.js',
          'src/mura.entitycollection.js',
          'src/mura.feed.js',
          'src/mura.templates.js',
          'src/mura.ui.js',
          'src/mura.displayobject.form.js',
          'src/mura.init.js',
          'src/templates/compiled.js'
          ],
          dest: 'dist/mura.js',
        },
    },
    uglify: {
      my_target: {
        files: {
          'dist/mura.min.js': ['dist/mura.js']
        }
      }
    },
    copy: {
      main: {
        files:[
             {expand: true, flatten: true,src: ['dist/**'], dest: '../../admin/assets/js'}
        ],
      },
    }
  });

  grunt.loadNpmTasks('grunt-text-replace');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-handlebars');
  grunt.registerTask('default',['handlebars','replace','concat','uglify','copy']);


};
