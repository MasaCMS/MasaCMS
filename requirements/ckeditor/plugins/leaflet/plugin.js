 /**
 * @fileOverview Leaflet Map Widget.
 */
(function() {
  /* Flow of Control for CKEditor and Widget components:
      Loading the page:
      CKEditor init()
      Widget upcast()

      Creating new widgets:
      Widget init()
      Widget data()
      Dialog select element's items()
      Dialog onShow()
      Dialog setup()
      Dialog commit()

      When editing existing widgets:
      Dialog onShow()
      Dialog setup()
      Dialog commit()
      Widget data()

      When saving page or clicking the CKEditor's Source button:
      Widget downcast()
   */

  // Add a new CKEditor plugin. Note that widgets are subclass of plugins.
  CKEDITOR.plugins.add('leaflet', {
    // Declare dependencies.
    requires: 'widget',

    // Declare the supported languages.
    lang: 'de,en,eu,ru',

    init: function(editor) {
      var config = editor.config;

      // Dummy global method for quick workaround of asynchronous document.write()
      // issue of Google APIs with respect to CKEditor.
      // See the Google APIs URL below for the query string usage of this dummy().
      // Using this hack, the document.write(...) requirement of Google APIs
      // will be replaced by the more 'gentle' combination of
      // document.createElement(...) and document.body.appendChild(...).
      window.dummy = function() {
        // Do nothing.
      }

      // Check if jQuery is already loaded to avoid redundancy and overriding
      // existing 3rd-party jQuery plugins' bindings to jQuery prototype.
      if (typeof jQuery == 'undefined') {
        // This is asynchronous loading.
        // See also CKEDITOR.scriptLoader.queue.
        CKEDITOR.scriptLoader.load('//code.jquery.com/jquery-1.12.4.min.js');
      }

      // Access the current translation file.
      var pluginTranslation = editor.lang.leaflet;

      // Declare a new Dialog for interactive selection of
      // map parameters. It's still not bound to any widget at this moment.
      CKEDITOR.dialog.add('leaflet', this.path + 'dialogs/leaflet.js');

      // For reusability, declare a global variable pointing to the map script path
      // that will build and render the map.
      // In JavaScript, relative path must include the leading slash.
      mapParserPath = CKEDITOR.getUrl(this.path + 'scripts/mapParser.html');

      // Declare a new widget.
      editor.widgets.add('leaflet', {
        // Bind the widget to the Dialog command.
        dialog: 'leaflet',

        // Declare the elements to be upcasted back.
        // Otherwise, the widget's code will be ignored.
        // Basically, we will allow all divs with 'leaflet_div' class,
        // including their alignment classes, and all iframes with
        // 'leaflet_iframe' class, and then include
        // all their attributes.
        // Read more about the Advanced Content Filter here:
        // * http://docs.ckeditor.com/#!/guide/dev_advanced_content_filter
        // * http://docs.ckeditor.com/#!/guide/plugin_sdk_integration_with_acf
        allowedContent: 'div(!leaflet_div,align-left,align-right,align-center,responsive-map)[*];'
                            + 'iframe(!leaflet_iframe,responsive-map-iframe)[*];',

        // Declare the widget template/structure, containing the
        // important elements/attributes. This is a required property of widget.
        template:
          '<div id="" class="leaflet_div" data-lat="" data-lon="" data-width="" data-height="" ' +
          'data-zoom="" data-popup-text="" data-tile="" data-minimap="" data-alignment="" data-responsive=""></div>',

        // This will be executed when going from the View Mode to Source Mode.
        // This is usually used as the function to convert the widget to a
        // dummy, simpler, or equivalent textual representation.
        downcast: function(element) {
          // Get the id of the div element.
          var divId = element.attributes["id"];

          // Get the numeric part of divId: leaflet_div-1399121271748.
          // We'll use that number for quick fetching of target iframe.
          var iframeId = "leaflet_iframe-" + divId.substring(12);

          // The current user might have changed the map's zoom level
          // via mouse events/zoom bar. The marker might have been
          // dragged also which means its lat/lon had changed.
          var mapContainer = editor.document.$.getElementById(iframeId).contentDocument.getElementById("map_container");

          // Get the current map states.
          var currentZoom = mapContainer.getAttribute("data-zoom");
          var currentLat = mapContainer.getAttribute("data-lat");
          var currentLon = mapContainer.getAttribute("data-lon");

          // Update the saved corresponding values in data attributes.
          element.attributes["data-zoom"] = currentZoom;
          element.attributes["data-lat"] = currentLat;
          element.attributes["data-lon"] = currentLon;

          // Fetch the other data attributes needed for
          // updating the full path of the map.
          var width = element.attributes["data-width"];
          var height = element.attributes["data-height"];
          var popUpText = element.attributes["data-popup-text"];
          var tile = element.attributes["data-tile"];
          var minimap = element.attributes["data-minimap"];
          var responsive = element.attributes["data-responsive"];

          // Build the updated full path to the map renderer.
          var mapParserPathFull = mapParserPath + "?lat=" + currentLat + "&lon=" + currentLon + "&width=" + width + "&height=" + height + "&zoom=" + currentZoom + "&text=" + popUpText + "&tile=" + tile + "&minimap=" + minimap + "&responsive=" + responsive;

          // Update also the iframe's 'src' attributes.
          // Updating 'data-cke-saved-src' is also required for
          // internal use of CKEditor.
          element.children[0].attributes["src"] = mapParserPathFull;
          element.children[0].attributes["data-cke-saved-src"] = mapParserPathFull;

          // Return the DOM's textual representation.
          return element;
        },

        // Required property also for widgets, used when switching
        // from CKEditor's Source Mode to View Mode.
        // The reverse of downcast() method.
        upcast: function(element) {
          // If we encounter a div with a class of 'leaflet_div',
          // it means that it's a widget and we need to convert it properly
          // to its original structure.
          // Basically, it says to CKEditor which div is a valid widget.
          if (element.name == 'div' && element.hasClass('leaflet_div')) {
            return element;
          }
        },
      });

      // Add the widget button in the toolbar and bind the widget command,
      // which is also bound to the Dialog command.
      // Apparently, this is required just like their plugin counterpart.
      editor.ui.addButton('leaflet', {
        label : pluginTranslation.buttonLabel,
        command : 'leaflet',
        icon : this.path + 'icons/leaflet.png',
        toolbar: 'insert,1'
      });

      // Append the widget's styles when in the CKEditor edit page,
      // added for better user experience.
      // Assign or append the widget's styles depending on the existing setup.
      if (typeof config.contentsCss == 'object') {
          config.contentsCss.push(CKEDITOR.getUrl(this.path + 'css/contents.css'));
      }

      else {
        config.contentsCss = [config.contentsCss, CKEDITOR.getUrl(this.path + 'css/contents.css')];
      }
    },
  });
})();
