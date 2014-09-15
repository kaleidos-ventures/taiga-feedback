gulp = require("gulp")
jade = require("gulp-jade")
coffee = require("gulp-coffee")
concat = require("gulp-concat")
uglify = require("gulp-uglify")
plumber = require("gulp-plumber")
rename = require("gulp-rename")
minifyHTML = require("gulp-minify-html")
sass = require("gulp-ruby-sass")
minifyCSS = require("gulp-minify-css")
scsslint = require("gulp-scss-lint")
cache = require("gulp-cached")
jadeInheritance = require('gulp-jade-inheritance')

paths = {
    app: "app"
    dist: "dist"
    jade: "app/**/*.jade"
    distStylesPath: "dist/styles"
    sassStylesMain: "app/styles/main.scss"
    scssStyles: "app/styles/**/*.scss"
    images: "app/images/**/*"
    coffee: [
        "app/coffee/app.coffee"
        "app/coffee/*.coffee"
    ]
    vendorJsLibs: [
        "app/vendor/jquery/dist/jquery.js",
        "app/vendor/lodash/dist/lodash.js",
        "app/vendor/angular/angular.js",
        "app/vendor/angular-route/angular-route.js",
        "app/vendor/angular-sanitize/angular-sanitize.js",
        "app/vendor/angular-animate/angular-animate.js",
        "app/vendor/checksley/checksley.js"
    ]
}

gulp.task "scsslint", ->
    gulp.src([paths.scssStyles, '!app/styles/bourbon/**/*.scss'])
        .pipe(cache("scsslint"))
        .pipe(scsslint({
            config: "scsslint.yml"
        }))

gulp.task "jade", ->
    gulp.src(paths.jade)
        .pipe(plumber())
        .pipe(cache("jade"))
        .pipe(jadeInheritance({basedir: './app'}))
        .pipe(jade({pretty: true}))
        .pipe(gulp.dest("#{paths.dist}"))

gulp.task "sass", ["scsslint"], ->
    gulp.src(paths.sassStylesMain)
        .pipe(plumber())
        .pipe(sass())
        .pipe(rename("app.css"))
        .pipe(gulp.dest(paths.distStylesPath))

gulp.task "coffee", ->
    gulp.src(paths.coffee)
        .pipe(plumber())
        .pipe(coffee())
        .pipe(concat("app.js"))
        .pipe(gulp.dest("dist/js/"))

gulp.task "jslibs", ->
    gulp.src(paths.vendorJsLibs)
        .pipe(plumber())
        .pipe(concat("libs.js"))
        .pipe(gulp.dest("dist/js/"))

gulp.task "copy",  ->
    gulp.src("#{paths.app}/fonts/*")
        .pipe(gulp.dest("#{paths.dist}/fonts/"))

    gulp.src("#{paths.app}/images/**/*")
        .pipe(gulp.dest("#{paths.dist}/images/"))

gulp.task "express", ->
    express = require("express")
    app = express()

    app.use("/js", express.static("#{__dirname}/dist/js"))
    app.use("/styles", express.static("#{__dirname}/dist/styles"))
    app.use("/images", express.static("#{__dirname}/dist/images"))
    app.use("/partials", express.static("#{__dirname}/dist/partials"))
    app.use("/fonts", express.static("#{__dirname}/dist/fonts"))

    app.all "/*", (req, res, next) ->
        # Just send the index.html for other files to support HTML5Mode
        res.sendFile("index.html", {root: "#{__dirname}/dist/"})

    app.listen(9001)

gulp.task "watch", ->
    gulp.watch(paths.jade, ["jade"])
    gulp.watch(paths.scssStyles, ["sass"])
    gulp.watch(paths.coffee, ["coffee"])

gulp.task "default", [
    "copy",
    "jade",
    "sass",
    "coffee",
    "express",
    "jslibs",
    "watch"
]
