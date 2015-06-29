module.exports = function(grunt) {

  grunt.initConfig({
      concat: {
        options: {
          separator: ';',
        },
        dist: {
          src: [
          'external/polyfill.js',
          'src/mura.js',
          'src/mura.loader.js',
          'src/mura.domselection.js',
          'src/mura.entity.js',
          'src/mura.entitycollection.js'
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