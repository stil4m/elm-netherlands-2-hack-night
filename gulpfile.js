var gulp = require('gulp');
var runSequence = require('run-sequence');
var elm = require('gulp-elm');
var uglify = require('gulp-uglify');
var gulpif = require('gulp-if');

var config = {
  debug : true
};

gulp.task('elm-init', elm.init);

gulp.task('elm-bundle', ['elm-init'], function () {
  return gulp.src('src/App.elm')
    .pipe(elm.bundle('main.js'))
    .on('error', function(e) {
      console.log(config);
      if (!config.debug) {
        throw e;
      }
    })
    .pipe(gulpif(!config.debug, uglify()))
    .pipe(gulp.dest('dist/'));
});

gulp.task('copy-public', function () {
  return gulp.src(['public/**/*'])
    .pipe(gulp.dest('dist'));
})

gulp.task('default', ['copy-public', 'elm-bundle']);

gulp.task('watch', function() {
  gulp.watch('src/**/*.elm', function () { runSequence('elm-bundle');});
  gulp.watch('public/**/*', function () { runSequence('copy-public');});
})
gulp.task('dev', ['default', 'watch']);
