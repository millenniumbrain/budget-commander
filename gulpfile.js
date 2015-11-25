var gulp = require("gulp");
var coffee = require("gulp-coffee");
var sourcemaps = require("gulp-sourcemaps");
var concat = require("gulp-concat");
var gutil = require('gulp-util');
var uglify = require('gulp-uglify');

gulp.task("default", function() {
  return gulp.src("public/js/src/**/*.coffee")
  .pipe(coffee({bare: true}).on('error', gutil.log))
  .pipe(sourcemaps.init())
  .pipe(uglify())
  .pipe(concat("app.js"))
  .pipe(sourcemaps.write("."))
  .pipe(gulp.dest("public/js/dist"));
});
