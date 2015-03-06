# MuraBootstrap3 CSS

Below is a description of each directory found under **css/**. You should edit the *.less* files, and use a preprocessor such as CodeKit or Prepros to preprocess and minify your files as specified below.

* **editor/editor.css**:
  This file is used by CKEditor for styles within the body area.

* **ie/ie.less**:
  This file is used by `templates/inc/html_head.cfm`. Minify as `ie.min.css`

* **mobile/mobile.less**:
  This file is used by `templates/mobile.cfm`. Minify as `mobile.min.css`

* **theme/theme.less**:
  This file is used by `templates/inc/html_head.cfm`. It includes all of the files located under `theme/responsive` as well as the file located under `variables/variables.less`. Minify as `theme.min.css*`.

* **variables/variables.less**:
  This file is used by `theme/theme.less`. There is no need to minify this file as it merely contains variables used by the theme.less file.