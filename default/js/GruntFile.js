module.exports = function(grunt) {

  grunt.initConfig({
      handlebars: {
          build: {
              files: {
                  'build/templates.js': ['src/templates/*.hb','src/templates/*.hbs']
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
        build: {
                src: ['build/templates.js'],
                dest: 'build/templates.js',
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
          build:{
            options: {
              separator: ';',
            },
            files:{
              'dist/mura.js': [
                  'external/polyfill.js',
                  'external/handlebars.runtime-v4.0.5.js',
                  'src/mura.js',
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
                  'build/templates.js'
              ],
              'dist/mura.handlebars.js': [
                  'external/polyfill.js',
                  'external/handlebars-v4.0.5.js',
                  'src/mura.js',
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
                  'build/templates.js'
              ]
           }
        },
    },
    uglify: {
        dist:{
          options: {
             beautify:{
              keep_quoted_props:true
             },
             screwIE8:false,
             compress: {
                 properties:false
             }
          },
          files: {
              'dist/mura.min.js': ['dist/mura.js'],
              'dist/mura.handlebars.min.js': ['dist/mura.handlebars.js'],
          }
        }
    },
    copy: {
      dist: {
        files:[
             {expand: true, flatten: true,src: ['dist/mura.js','dist/mura.min.js'], dest: '../../admin/assets/js'}
        ],
      },
    }
  });

  grunt.loadNpmTasks('grunt-text-replace');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-handlebars');
  grunt.registerTask('default',['handlebars:build','replace:build','concat:build','uglify:dist','copy:dist']);


};
