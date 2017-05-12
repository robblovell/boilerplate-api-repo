# Gulp stuff.
gulp = require('gulp')
clean = require('gulp-clean')
gutil = require('gulp-util')
coffee = require('gulp-coffee')
sourcemaps = require('gulp-sourcemaps')
touch = require('touch')
path = require('path')
tap = require('gulp-tap')
sh = require('shelljs')
jade = require('gulp-jade')
stylus = require('gulp-stylus')
parallelize = require("concurrent-transform")
mocha = require('gulp-mocha')
runSequence = require('run-sequence')

threads = 100
useSourceMaps = true

coffeeFiles = ['app.coffee', 'bin/**/*.coffee','config/**/*.coffee','resources/**/*.coffee',
'routes/**/*.coffee','source/**/*.coffee','test/**/*.coffee','test_ci/**/*.coffee',
'test_functional/**/*.coffee','test_integration/**/*.coffee']

javascriptFiles = ['app.js, app.map, bin/**/*.js','config/**/*.js','resources/**/*.js',
'routes/**/*.js','source/**/*.js','test/**/*.js',
'test_functional/**/*.js','test_integration/**/*.js',
'bin/**/*.map','config/**/*.map','resources/**/*.map',
'routes/**/*.map','source/**/*.map','test/**/*.map','test_ci/**/*.map',
'test_functional/**/*.map','test_integration/**/*.map']

handleError = (err) ->
    console.log(err.toString())
    @emit('end')

gulp.task('touch', () ->
    gulp.src(coffeeFiles)
    .pipe(
        tap((file, t) ->
            touch(file.path)
        )
    )
)

gulp.task('coffeescripts', () ->
    gulp.src(coffeeFiles)
    .pipe(sourcemaps.init())
    .pipe(parallelize(coffee({bare: true}).on('error', gutil.log), threads))
    .pipe(parallelize(sourcemaps.write('./'), threads))
    .pipe(parallelize(gulp.dest((file) -> return file.base), threads))
)

gulp.task('one',  () ->
    return gulp.src('./css/one.styl')
    .pipe(stylus())
    .pipe(gulp.dest('./css/build'))
)

gulp.task('watch', () ->
    gulp.watch(coffeeFiles, ['compile-and-test'])
)

gulp.task('unit-tests', () ->
    return gulp.src('./test/*.js', {read:false})
    .pipe(mocha())
)

gulp.task('integration-tests', () ->
    return gulp.src('./test_integration/*.js', {read:false})
    .pipe(mocha())
)

gulp.task('functional-tests', () ->
    return gulp.src('./test_functional/*.js', {read:false})
    .pipe(mocha())
)

gulp.task('clean', () ->
    return gulp.src(javascriptFiles, {read: false})
        .pipe(clean())
)

gulp.task('compile-and-test', (done) ->
    runSequence('coffeescripts', 'unit-tests', done)
)

gulp.task('build', ['coffeescripts']) # ,'jadescripts','stylusscripts'])

gulp.task('default', ['watch', 'coffeescripts'])

gulp.task('done', (() -> ))