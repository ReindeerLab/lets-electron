var del = require('del');
var electron = require('electron-connect').server.create();
var gulp = require('gulp');
var notify = require('gulp-notify');
var plumber = require('gulp-plumber');
var sass = require('gulp-sass');

gulp.task('default', ['serve']);

gulp.task('build', [
  'sass'
]);

gulp.task('sass', function() {
  gulp.src('./src/renderer/styles/*.scss')
    .pipe(plumber({errorHandler: notify.onError({title: 'Error(sass)', message: '<%= error.message %>'})}))
    .pipe(sass({outputStyle: 'compressed', includePaths: []}))
    .pipe(gulp.dest('./src/renderer/styles'));
});

gulp.task('watch', ['build'], function() {
  gulp.watch('./src/renderer/styles/*.scss', ['sass']);
  gulp.watch(['./src/browser/**/*.js'], electron.restart);
  gulp.watch(['./src/**/*.{html,css}'], electron.reload);
});

gulp.task('serve', ['watch'], electron.start);
