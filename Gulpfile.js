// Util
var gulp =require('gulp');
// Plugins
var compass = require('gulp-compass');
var coffee = require('gulp-coffee');

var p = {
  sass: {
    src:'public/sass/*.scss',
    dest:'public/css/'
  },
  scripts: {
    coffee: 'public/coffee/*.coffee',
    dest: 'public/js/',

  }
}

// Compass
gulp.task('compass', function() {
  gulp.src(p.sass.src)
    .pipe(compass({
      css: 'public/css',
      sass: 'public/sass',
      comments: false,
      sourcemap: false
    }))
    .on('error', function(err) {
      console.log(err) // plumber was not very good with compass
    })
    .pipe(gulp.dest(p.sass.dest))
})

// Coffee
gulp.task("coffee", function(){
  gulp.src(p.scripts.coffee)
  .pipe(coffee())
  .pipe(gulp.dest(p.scripts.dest))
});

// compile
gulp.task('default', ['compass', 'coffee'], function() {
  console.log('gulp compile!')
})
