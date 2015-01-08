###CHANGELOG

####Version 1.3.1 Released (December 27, 2014)
Add a conditional check to load only the jQuery library if it's not already loaded to boost performance and avoid overriding jQuery bindings with other 3rd-party plugins.

####Version 1.3 Released (December 27, 2014)
The user could now specify if the map should be responsive. The widget should now work also for both http and https protocols. Installation guide now includes some notes regarding markup filtering.
> In the Options tab of the Dialog window, there's now a 'Responsive Map' checkbox option.

> - Assuming you have a responsive site theme or page styling, this will make the map to have 100% width with the typical 16:9 aspect ratio.
> - Responsive behavior will override the widget alignment settings since it will always be centered.
> - The width and height will also be auto-computed depending on the dimensions of the device's screen.
> - The map's responsive behavior will not have effect if you have don't have a responsive site theme or page styling.

> Handle HTTPS/Secured Protocol

> - The widget should now work for both http or https protocols.

> Add notes in **Installation Guide** about possible issues in markup filtering.

> - Some systems like Drupal blocks IFRAME tag by default and discard any inline styling. See the workarounds in [IV. CAVEATS AND SURPRISES](https://github.com/ranelpadon/ckeditor-leaflet/blob/master/Installation%20Guide.txt/)

####Version 1.2 Released (August 9, 2014):

The user could now specify the marker's popup text.
