module.exports = function(grunt) {

  grunt.initConfig({
      concat: {
        options: {
          separator: ';',
        },
        dist: {
          src: [
          //'src/es5.polyfill.js',
          //'src/es6.promise.polyfill.js',
          //'src/json3.js',
          'src/loader.js',
          'src/mura.selectionwrapper.js',
          'src/mura.js',
          //'src/sizzle.js'
          ],
          dest: 'dist/mura.js',
        },
    },
    uglify: {
      my_target: {
        files: {
          'global.min.js': ['global.js'],
          'dist/mura.min.js': ['dist/mura.js']
        }
      }
    }
});

  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-concat');

  grunt.registerTask('default', ['concat','uglify']);
   

};