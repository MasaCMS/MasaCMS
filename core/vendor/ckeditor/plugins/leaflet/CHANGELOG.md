###CHANGELOG

####Version 1.7 Released (August 13, 2016)

 - Fix issue in autocomplete feature not working on some website domains due to the Google's recent policy changes regarding access keys, effective since June 22, 2016. See their [official announcement](http://googlegeodevelopers.blogspot.com.au/2016/06/building-for-scale-updates-to-google.html). Thanks to [@smartcorestudio](https://github.com/smartcorestudio) for bringing this up.
 - Refactor the code to load the Google Maps JS API script only when the plugin's dialog window pops-out to minimize the Google Maps JS API key usage. Thanks to [@smartcorestudio](https://github.com/smartcorestudio) for the suggestion.
 - Update [Installation Guide](https://github.com/ranelpadon/ckeditor-leaflet/blob/master/Installation%20Guide.txt) regarding the usage/integration of Google Maps JS API key and how to [create your own key](https://developers.google.com/maps/documentation/javascript/get-api-key). Make sure to enable the **Google Maps JavaScript API** in your **Google API Console** to activate your key.
 - Update the demo page to illustrate the use of the Google Maps JS API key.
 - Implement **dynamic language switcher mechanism** in the [demo page](http://www.ranelpadon.com/sites/all/libraries/ckeditor/plugins/leaflet/demo/index.html) to showcase the translation support and the available translation files.
 - Add the German language support/translation, thanks to Stefan Berger (stefan@berger.net).
 - Utilize the CKEditor's native translation strings for **Alignment**, **Align Right**, **Align Left**, and **Center** for more accurate translation and smaller plugin's translation files.

####Version 1.6 Released (August 9, 2016)

 - Remove **MapQuest** from the available map tiles since it now requires access key and the previous setup causes rendering errors. Thanks to [@howellcc](https://github.com/howellcc) for bringing it up.
 - Make the *existing* **MapQuest** tiles auto-redirect to **OpenStreetMap.Mapnik** tiles for back compatibility and prevent manual conversion of MapQuest tiles.
 - Make the **OpenStreetMap.Mapnik** as the default map tile provider for *new* widgets.
 - Include a demo page featuring the latest CDN-hosted `ckeditor.js` file. The **Leaflet Maps** plugin folder is all you need now to render the bundled demo page since all dependencies (including languages) will be pulled from the CDN-hosted files. Note that you need to put the plugin folder in a web server context (e.g. localhost or virtual host setup) to render the demo page properly; opening the **demo/index.html** file directly in a browser as a regular file will not work.
 - Update the default jQuery version to the latest 1.x version (1.12.4)
 - Prevent unnecessary loading of external scripts when the plugin is already disabled via `config.removePlugins`. Thanks to [@SDKiller](https://github.com/SDKiller) for bringing this up.

####Version 1.5 Released (February 12, 2016)

 - Integrate language localization mechanisms.
	 - Bundle the Russian and Basque versions/translations.
		 - Thanks to [@smartcorestudio](https://github.com/smartcorestudio) for the Russian translation.
		 - Thanks to [@aldatsa](https://github.com/aldatsa) for the Basque translation.
	 - Set default plugin language to English (will be automatically overriden depending on the user's locale and if the user's localization is available in the plugin).

####Version 1.4 Released (December 30, 2015)

 - Implement draggable marker so that the latitude and longitude of a  place could be
   more precise and refined, especially when the Google's predicted location is not in
   has saved the page or when the user opens the widget's dialog options and then
   clicked the OK button (w/ or w/out changing any of the dialog options).

 - Recenter the map (and with panning animation) for better UX
   if the user drags the marker to a new position

 - Update Leaflet's JS/CSS files to the latest stable build, version [0.7.7](http://leafletjs.com/download.html),
 which was released on October 26, 2015.

 - Remove the unnecessary files (especially the files/assets in the **leaflet/scripts** folder)
    so that the plugin's folder is as lean as possible.

####Version 1.3.3 Released (December 25, 2015)
Same as Version 1.3.2, but re-uploaded in CKEditor.com just to indicate compatibility with CKEditor 4.5.x on its plugin page. Not a significant release actually.

####Version 1.3.2 Released (December 13, 2015)
Update the Leaflet Maps installation documentation with respect to version 7.x-1.16 of Drupal's CKEditor module. Adjust the plugin's license for compatibility with GPLv2+ open-source projects.

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
