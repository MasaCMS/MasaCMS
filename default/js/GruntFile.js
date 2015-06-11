module.exports = function(grunt) {

  grunt.initConfig({
      concat: {
        options: {
          separator: ';',
        },
        dist: {
          src: [
          'src/es5.polyfill.js',
          'src/es6.promise.polyfill.js',
          'src/json3.js',
          'src/loader.js',
          'src/muraSelectionWrapper.js',
          'src/mura.js'
          ],
          dest: 'global.js',
        },
    },
    uglify: {
      my_target: {
        files: {
          'global.min.js': ['global.js']
        }
      }
    }
});

  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-concat');

  grunt.registerTask('default', ['concat','uglify']);
   

};