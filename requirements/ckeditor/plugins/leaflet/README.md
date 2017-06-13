ckeditor-leaflet
================
<strong>OVERVIEW</strong>:<br>
This CKEditor <a href="http://ckeditor.com/addon/leaflet">Leaflet Maps</a> plugin has three workhorse files:
<ul>
  <li><a href="https://github.com/ranelpadon/ckeditor-leaflet/blob/master/plugin.js">Plugin Core</a>: Defines the plugin and attaches the plugin to the CKEditor toolbar.</li>
  <li><a href="https://github.com/ranelpadon/ckeditor-leaflet/blob/master/dialogs/leaflet.js">Dialog Script</a>: Displays the map options when creating and editing existing maps.</li>
  <li><a href="https://github.com/ranelpadon/ckeditor-leaflet/blob/master/scripts/mapParser.html">Map Renderer</a>: Parses the map options via URL and renders the map accordingly.</li>
</ul>

This plugin utilizes the following technologies/libraries: <br>
<ul>
  <li><a href="http://docs.ckeditor.com/#!/api/CKEDITOR.plugins.widget">CKEditor's Widget API</a></li>
  <li><a href="https://developers.google.com/maps/documentation/javascript/places-autocomplete">Google's Places Library/Type-Ahead Search</a></li>
  <li><a href="https://developers.google.com/maps/documentation/geocoding/">Google's Geocoding API</a></li>
  <li><a href="http://leafletjs.com/">Leaflet JS</a></li>
  <li><a href="https://github.com/leaflet-extras/leaflet-providers">Leaflet - Tile Providers</a></li>
  <li><a href="https://github.com/Norkart/Leaflet-MiniMap">Leaflet - MiniMap</a></li>
</ul>

Main features/highlights: <br>
<ul>
  <li>Auto-searching of map coordinates using Google Search with Geocoding.</li>
  <li>10 available map tiles, featuring OpenStreetMap.</li>
  <li>Map could include a minimap/overview map for better map context.</li>
  <li>Map could be responsive (100% width).</li>
  <li>Map could be customized with the specified width and height dimensions.</li>
  <li>Map could be aligned to the left or right, or be placed at the center of the page.</li>
  <li>Map zoom level could be changed using the mouse wheel, zoom buttons, or zoom dialog options.</li>
  <li>Map zoom level could be customized per map and saved.</li>
  <li>Marker's popup text could be customized.</li>
  <li>Marker could be dragged and its last position will be saved.</li>
  <li>Map re-centers the view on-the-fly as the user drags the marker,  for better UX.</li>
  <li>Supports both http and https protocols.</li>
  <li>Supports English, Russian, and Basque languages/translations</li>
  <li>Bundles a stand-alone demo page that fetches the CDN-hosted CKEditor files (including the dependencies and languages). It also includes a handy language switcher for demonstrating the various translations of the plugin.</li>
</ul>

<strong>LIVE DEMO PAGE</strong>:
<br>Demo page could be found [here](http://www.ranelpadon.com/sites/all/libraries/ckeditor/plugins/leaflet/demo/index.html). It is comprehensive and showcases the various translations and map options, including the draggable marker, customizable pop-up text, and responsive behavior (see the bottom map example in the demo).

<strong>PROJECTS INTEGRATING THIS PLUGIN</strong>: <br>
<ul>
  <li><a href="https://www.drupal.org/project/lightning">Lightning Drupal Distribution</a> installs this plugin by <a href="https://github.com/acquia/lightning/tree/7.x-1.x">default</a>. This topnotch distro is curated by <a href="https://www.acquia.com/">Acquia</a>.</li>
  <li><a href="http://www.getmura.com/">Mura CMS</a> bundles this plugin by <a href="http://www.getmura.com/blog/announcing-release-of-mura-cms-6-2/">default</a>. Mura CMS is an open-source, semi-commercial, and ColdFusion-based CMS. Check out their <a href="http://docs.getmura.com/v6/content-managers/contact-us/embed-a-map/">Leaflet Maps user guide<a>.</li>
  <li><a href="http://zikula.org/">Zikula PHP Framework</a> could install this <a href="https://github.com/zikula-modules/Scribite/tree/master/plugins/CKEditor/vendor/ckeditor/plugins/leaflet">plugin</a> through the <a href="https://github.com/zikula-modules/Scribite">Scribite module</a> with its <a href="https://github.com/zikula-modules/Scribite/tree/master/plugins/CKEditor/vendor/ckeditor">CKEditor integration</a>.
</li>
  <li><a href="http://smartcore.ru/">SmartCore</a>'s home-grown, Russian CMS integrates this <a href="http://adminpanel.smartcore.ru/help/credits">plugin</a>.</li>
 </ul>

<p><strong>INSTALLATION</strong>:
<br>Kindly refer to <a href="https://github.com/ranelpadon/ckeditor-leaflet/blob/master/Installation%20Guide.txt">Installation Guide</a>.</p>

<p><strong>HOW TO USE</strong>:
<br>Kindly refer to <a href="https://github.com/ranelpadon/ckeditor-leaflet/blob/master/Creating%20and%20Editing%20Leaflet%20Maps.txt">How to Create and Edit Leaflet Maps</a>.</p>

<p><strong>CHANGELOG</strong>:
<br>Kindly refer to the <a href="https://github.com/ranelpadon/ckeditor-leaflet/blob/master/CHANGELOG.md">Release Notes</a>.</p>

<strong>ROAD MAP</strong> (Planned stuff to do):<br><ul>
<li>IFRAME-less implementation for faster rendering in pages with lots of maps.</li>
<li>Render widget only on demand or as the page scrolls for optimal page performance.</li>
<li>Integration with Inline/In-Place Editing.</li>
<li>Option to show the cursor's map coordinates and scale bar.</li>
<li>State of the panned map's view must be saved.</li>
<li>Ability to add map caption/annotation
<li>Display the map preview in the Dialog window.</li>
<li>Handle multiple markers.</li>
<li>Add and delete markers.</li>
<li>Has option to add Panoromio (panoramio.com) layer.</li>
<li>Add other tile providers.</li>
<li>R&D other Leaflet plugins that might be useful.</li>
</ul>

<strong>LICENSE and CREDITS</strong>:<br>

License: <a href="https://www.gnu.org/licenses/lgpl-2.1.txt">LGPLv2.1</a> or later should apply. Note that LGPLv2.1+ is also compatible with <a href="https://www.drupal.org/node/1475972#gplv2-compatible-licenses">GPLv2</a>.<br>
Copyright 2016 by Engr. Ranel O. Padon<br>
ranel.padon@gmail.com<br>

Plugin's icon is a property of <a href="http://simpleicon.com/">simpleicon</a>.
As indicated in their website, use of their icon is allowed as long as it includes proper credit and backlink.

Thanks to CKEditor, Leaflet, and other great open-source softwares and their unsung developers.<br>

Special thanks also to the insights, guidance, and collaborative support of our <a href="http://travel.cnn.com">CNN Travel</a> team:<br>
Senior Web Development Manager:<br>
Brent A. Deverman<br>

Senior Software Engineer:<br>
Adrian Christopher B. Cruz<br>

Senior QA Analyst:<br>
Jonathan A. Jacinto<br>

=======================================================
