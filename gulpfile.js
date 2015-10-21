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

// デフォルト
gulp.task('default', [])

// パッケージ用タスク
gulp.task('build', ['sass', 'browserify'])

// 開発用タスク
gulp.task('serve', ['watch'])

// browserify用エラーハンドラ
var errorHandler = function() {
  notify.onError({
    title: 'Compile error (browserify)',
    message: '<%= error %>'
  }).apply(this, Array.prototype.slice.call(arguments))
  this.emit('end')
}

// browserifyオブジェクト取得
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

// パッケージング用ビルド
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

// 開発用ビルド
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

// Sassコンパイル
gulp.task('sass', function() {
  gulp.src('./src/renderer/styles/*.scss')
    .pipe(plumber({errorHandler: notify.onError({title: 'Compile error (Sass)', message: '<%= error.message %>'})}))
    .pipe(sass({outputStyle: 'compressed', includePaths: []}))
    .pipe(gulp.dest('./src/renderer/styles'))
})

// ファイル監視
gulp.task('watch', ['watchify', 'sass'], function() {
  // compile tasks
  gulp.watch('./src/renderer/styles/*.scss', ['sass'])
  // start electron
  electron.start()
  // electron watch tasks
  gulp.watch(['./src/browser/**/*.js'], electron.restart)
  gulp.watch(['./src/renderer/**/*.{html,css,js}'], electron.reload)
})
