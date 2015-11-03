var gulp = require("gulp");
var sourcemaps = require("gulp-sourcemaps");
var concat = require("gulp-concat");

gulp.task("default", function() {
  return gulp.src("public/js/src/**/*.js")
  .pipe(sourcemaps.init())
  .pipe(concat("app.js"))
  .pipe(sourcemaps.write("."))
  .pipe(gulp.dest("public/js/dist"));
});
