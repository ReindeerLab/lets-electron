var gulp = require('gulp')
var browserify = require('browserify')
var del = require('del')
var electron = require('electron-connect').server.create()
var notify = require('gulp-notify')
var plumber = require('gulp-plumber')
var sass = require('gulp-sass')
var uglify = require('gulp-uglify')
var sourcemaps = require('gulp-sourcemaps')
var buffer = require('vinyl-buffer')
var source = require('vinyl-source-stream')
var watchify = require('watchify')

gulp.task('default', [])

gulp.task('build', ['sass', 'browserify'])

var errorHandler = function() {
  notify.onError({
    title: 'Compile error (browserify)',
    message: '<%= error %>'
  }).apply(this, Array.prototype.slice.call(arguments))
  this.emit('end')
}

var getBundler = function(watch) {
  var bundler = browserify({
    entries: './src/renderer/scripts/index.coffee',
    extensions: ['.js', '.coffee'],
    transform: ['coffeeify'],
    debug: true
  })
  if (watch) bundler = watchify(bundler, {debug: true})
  return bundler
}

// build for distribution
gulp.task('browserify', function() {
  getBundler()
    .bundle()
    .on('error', errorHandler)
    .pipe(source('bundle.js'))
    .pipe(buffer())
    .pipe(sourcemaps.init({loadMaps: true}))
    .pipe(uglify({preserveComments: 'some'}))
    .piep(sourcemaps.write('./'))
    .pipe(gulp.dest('./dist/renderer/scripts'))
})

// build for development
gulp.task('watchify', function() {
  var bundler = getBundler(true)
  var bundle = function() {
    bundler
      .bundle()
      .on('error', errorHandler)
      .pipe(source('bundle.js'))
      .pipe(gulp.dest('./src/renderer/scripts'))
  }
  bundler.on('update', bundle)
  bundle()
})

gulp.task('sass', function() {
  gulp.src('./src/renderer/styles/*.scss')
    .pipe(plumber({errorHandler: notify.onError({title: 'Error(sass)', message: '<%= error.message %>'})}))
    .pipe(sass({outputStyle: 'compressed', includePaths: []}))
    .pipe(gulp.dest('./src/renderer/styles'))
})

gulp.task('watch', ['watchify', 'sass'], function() {
  // compile tasks
  gulp.watch('./src/renderer/styles/*.scss', ['sass'])
  // electron watch tasks
  gulp.watch(['./src/browser/**/*.js'], electron.restart)
  gulp.watch(['./src/renderer/index.html', './src/**/*.js', './src/**/*.css'], electron.reload)
  electron.start()
})

gulp.task('serve', ['watch'])
