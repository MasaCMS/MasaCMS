'use strict';

const { series, parallel, src, dest, watch } = require('gulp');
const path = require('path');
const minify = require('gulp-minify');
const less = require('gulp-less');
const cleanCSS = require('gulp-clean-css');
const rename = require("gulp-rename");
const sourcemaps = require('gulp-sourcemaps');

const config = {
    adminJSDirectory: 'admin/assets/js/'
    , adminLessDirectory: 'admin/assets/less/'
    , adminCssDirectory: 'admin/assets/css/'
    , coreJSDirectory: 'core/modules/v1/core_assets/js/'
    , coreLessDirectory: 'core/modules/v1/core_assets/css/less/'
    , coreCssDirectory: 'core/modules/v1/core_assets/css/'
    , jsMinifyOptions: {
        noSource: true,
        ext: {
            min:'.min.js'
        },
        ignoreFiles: ['*.min.js'],
        preserveComments: 'some'
    }
    , lessOptions: {
        paths: [ path.join(__dirname, 'less', 'includes') ]
    }
    , cleanCssOptions: {
        compatibility: 'ie8'
    }
};

function buildAdminJS() {
    // create sourcemaps for the Administrator JS files
    return src(`${config.adminJSDirectory}**/*.js`)
        .pipe(minify(config.jsMinifyOptions))
        .pipe(dest(config.adminJSDirectory))
}

function compileAdminLESS() {
    // build the LESS files
    return src([
            `${config.adminLessDirectory}admin-frontend.less`
            , `${config.adminLessDirectory}admin.less`
            , `${config.adminLessDirectory}ie.less`
        ])
        .pipe(sourcemaps.init())
        .pipe(less(config.lessOptions))
        .pipe(sourcemaps.write('.'))
        .pipe(dest(config.adminCssDirectory));
}

function cleanAdminCSS() {
    // clean the CSS files
    return src([
            `${config.adminCssDirectory}*.css`
            , `!${config.adminCssDirectory}*.min.css`
        ])
        .pipe(sourcemaps.init())
        .pipe(cleanCSS(config.cleanCssOptions))
        .pipe(rename({ suffix: ".min" }))
        .pipe(sourcemaps.write('.'))
        .pipe(dest(config.adminCssDirectory));
}

function buildCoreJS() {
    // create sourcemaps for the Administrator JS files
    return src(`${config.coreJSDirectory}**/*.js`)
        .pipe(minify(config.jsMinifyOptions))
        .pipe(dest(config.coreJSDirectory))
}

function compileCoreLESS() {
    // build the LESS files
    return src([
            `${config.coreLessDirectory}mura.7.0.less`
            , `${config.coreLessDirectory}mura.7.0.skin.less`
            , `${config.coreLessDirectory}mura.7.1.less`
            , `${config.coreLessDirectory}mura.7.3.less`
            , `${config.coreLessDirectory}mura.7.3.skin.less`
            , `${config.coreLessDirectory}mura.7.4.less`
            , `${config.coreLessDirectory}mura.7.4.skin.less`
        ])
        .pipe(sourcemaps.init())
        .pipe(less(config.lessOptions))
        .pipe(sourcemaps.write('.'))
        .pipe(dest(config.coreCssDirectory));
}

function cleanCoreCSS() {
    // clean the CSS files
    return src([
            `${config.coreCssDirectory}*.css`
            , `!${config.coreCssDirectory}*.min.css`
        ])
        .pipe(sourcemaps.init())
        .pipe(cleanCSS(config.cleanCssOptions))
        .pipe(rename({ suffix: ".min" }))
        .pipe(sourcemaps.write('.'))
        .pipe(dest(config.coreCssDirectory));
}

function watchChanges() {
    watch(`${config.adminJSDirectory}*.js`, exports.buildAdminJS);
    watch(`${config.adminLessDirectory}*.less`, exports.buildAdminCSS);
    watch(`${config.coreLessDirectory}*.less`, exports.buildCoreCSS);
};

exports.buildAdminCSS = series(compileAdminLESS, cleanAdminCSS);
exports.buildCoreCSS = series(compileCoreLESS, cleanCoreCSS);
exports.buildAdminJS = buildAdminJS;
exports.buildCoreJS = buildCoreJS;
exports.compileAdminLESS = compileAdminLESS;
exports.cleanAdminCSS = cleanAdminCSS;
exports.compileCoreLESS = compileCoreLESS;
exports.cleanCoreCSS = cleanCoreCSS;
exports.watch = watchChanges;

exports.default = parallel(
    buildAdminJS
    , series(compileAdminLESS, cleanAdminCSS)
    , series(compileCoreLESS, cleanCoreCSS)
)