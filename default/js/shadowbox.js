/**
 * A media-viewer script for web pages that allows content to be viewed without
 * navigating away from the original linking page.
 *
 * This file is part of Shadowbox.
 *
 * Shadowbox is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option)
 * any later version.
 *
 * Shadowbox is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for
 * more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Shadowbox. If not, see <http://www.gnu.org/licenses/>.
 *
 * @author      Michael J. I. Jackson <mjijackson@gmail.com>
 * @copyright   2007 Michael J. I. Jackson
 * @license     http://www.gnu.org/licenses/lgpl-3.0.txt GNU LGPL 3.0
 * @version     SVN: $Id: shadowbox.js 75 2008-02-21 16:51:29Z mjijackson $
 */

if(typeof Shadowbox == 'undefined'){
    throw 'Unable to load Shadowbox, no base library adapter found.';
}

/**
 * The Shadowbox class. Used to display different media on a web page using a
 * Lightbox-like effect.
 *
 * Useful resources:
 * - http://www.alistapart.com/articles/byebyeembed
 * - http://www.w3.org/TR/html401/struct/objects.html
 * - http://www.dyn-web.com/dhtml/iframes/
 * - http://support.microsoft.com/kb/316992
 * - http://www.apple.com/quicktime/player/specs.html
 * - http://www.howtocreate.co.uk/wrongWithIE/?chapter=navigator.plugins
 *
 * @class       Shadowbox
 * @author      Michael J. I. Jackson <mjijackson@gmail.com>
 * @singleton
 */


(function(){

    /**
     * The current version of Shadowbox.
     *
     * @property    {String}    version
     * @private
     */
    var version = '1.0';

    /**
     * Contains the default options for Shadowbox. This object is almost
     * entirely customizable.
     *
     * @property    {Object}    options
     * @private
     */
    var options = {

        /**
         * A base URL that will be prepended to the loadingImage, flvPlayer, and
         * overlayBgImage options to save on typing.
         *
         * @var     {String}    assetURL
         */
        assetURL:        mura.context +  '/default/images/shadowbox/',

        /**
         * The path to the image to display while loading.
         *
         * @var     {String}    loadingImage
         */
        loadingImage:       'loading.gif',

        /**
         * Enable animations.
         *
         * @var     {Boolean}   animate
         */
        animate:            true,

        /**
         * Specifies the sequence of the height and width animations. May be
         * 'wh' (width then height), 'hw' (height then width), or 'sync' (both
         * at the same time). Of course this will only work if animate is true.
         *
         * @var     {String}    animSequence
         */
        animSequence:       'wh',

        /**
         * The path to flvplayer.swf.
         *
         * @var     {String}    flvPlayer
         */
        flvPlayer:          'flvplayer.swf',

        /**
         * The background color and opacity of the overlay. Note: When viewing
         * movie files on FF Mac, the default background image will be used
         * because that browser has problems displaying movies above layers
         * that aren't 100% opaque.
         *
         * @var     {String}    overlayColor
         */
        overlayColor:       '#000',

        /**
         * The background opacity to use for the overlay.
         *
         * @var     {Number}    overlayOpacity
         */
        overlayOpacity:     0.8,

        /**
         * A background image to use for browsers such as FF Mac that don't
         * support displaying movie content over backgrounds that aren't 100%
         * opaque.
         *
         * @var     {String}    overlayBgImage
         */
        overlayBgImage:     'overlay-85.png',

        /**
         * Listen to the overlay for clicks. If the user clicks the overlay,
         * it will trigger Shadowbox.close().
         *
         * @var     {Boolean}   listenOverlay
         */
        listenOverlay:      false,

        /**
         * Automatically play movies.
         *
         * @var     {Boolean}   autoplayMovies
         */
        autoplayMovies:     true,

        /**
         * Enable movie controllers on movie players.
         *
         * @var     {Boolean}   showMovieControls
         */
        showMovieControls:  true,

        /**
         * The duration of the resizing animations (in seconds).
         *
         * @var     {Number}    resizeDuration
         */
        resizeDuration:     0.35,

        /**
         * The duration of the overlay fade animation (in seconds).
         *
         * @var     {Number}    fadeDuration
         */
        fadeDuration:       0.35,

        /**
         * Show the navigation controls.
         *
         * @var     {Boolean}   displayNav
         */
        displayNav:         true,

        /**
         * Enable continuous galleries. When this is true, users will be able
         * to skip to the first gallery image from the last using next and vice
         * versa.
         *
         * @var     {Boolean}   continuous
         */
        continuous:         false,

        /**
         * Display the gallery counter.
         *
         * @var     {Boolean}   displayCounter
         */
        displayCounter:     true,

        /**
         * This option may be either 'default' or 'skip'. The default counter is
         * a simple '1 of 5' message. The skip counter displays a link for each
         * piece in the gallery that enables a user to skip directly to any
         * piece.
         *
         * @var     {String}    counterType
         */
        counterType:        'default',

        /**
         * The amount of padding to maintain around the viewport edge (in
         * pixels). This only applies when the image is very large and takes up
         * the entire viewport.
         *
         * @var     {Number}    viewportPadding
         */
        viewportPadding:    40,

        /**
         * How to handle images that are too large for the viewport. 'resize'
         * will resize the image while preserving aspect ratio and display it at
         * the smaller resolution. 'drag' will display the image at its native
         * resolution but it will be draggable within the Shadowbox. 'none' will
         * display the image at its native resolution but it may be cropped.
         *
         * @var     {String}    handleLgImages
         */
        handleLgImages:     'resize',

        /**
         * The initial height of Shadowbox (in pixels).
         *
         * @var     {Number}    initialHeight
         */
        initialHeight:      160,

        /**
         * The initial width of Shadowbox (in pixels).
         *
         * @var     {Number}    initialWidth
         */
        initialWidth:       320,

        /**
         * Enable keyboard control. Note: If you disable the keys, you may want
         * to change the visual styles for the navigation elements that suggest
         * keyboard shortcuts.
         *
         * @var     {Boolean}   enableKeys
         */
        enableKeys:         true,

        /**
         * The keys used to control Shadowbox. Note: In order to use these,
         * enableKeys must be true. Key values or key codes may be used.
         *
         * @var     {Array}
         */
        keysClose:          ['c', 'q', 27], // c, q, or esc
        keysNext:           ['n', 39],      // n or right arrow
        keysPrev:           ['p', 37],      // p or left arrow

        /**
         * A hook function to be fired when Shadowbox opens. The single argument
         * will be the current gallery element.
         *
         * @var     {Function}
         */
        onOpen:             null,

        /**
         * A hook function to be fired when Shadowbox finishes loading its
         * content. The single argument will be the current gallery element on
         * display.
         *
         * @var     {Function}
         */
        onFinish:           null,

        /**
         * A hook function to be fired when Shadowbox changes from one gallery
         * element to the next. The single argument will be the current gallery
         * element that is about to be displayed.
         *
         * @var     {Function}
         */
        onChange:           null,

        /**
         * A hook function that will be fired when Shadowbox closes. The single
         * argument will be the gallery element most recently displayed.
         *
         * @var     {Function}
         */
        onClose:            null,

        /**
         * The mode to use when handling unsupported media. May be either
         * 'remove' or 'link'. If it is 'remove', the unsupported gallery item
         * will merely be removed from the gallery. If it is the only item in
         * the gallery, the link will simply be followed. If it is 'link', a
         * link will be provided to the appropriate plugin page in place of the
         * gallery element.
         *
         * @var     {String}    handleUnsupported
         */
        handleUnsupported:  'link',

        /**
         * Skips calling Shadowbox.setup() in init(). This means that it must
         * be called later manually.
         *
         * @var     {Boolean}   skipSetup
         */
        skipSetup:          false,

        /**
         * Text messages to use for Shadowbox. These are provided so they may be
         * translated into different languages.
         *
         * @var     {Object}    text
         */
        text:           {

            cancel:     'Cancel',

            loading:    'Loading',

            close:      '<span class="shortcut">C</span>lose',

            next:       '<span class="shortcut">N</span>ext',

            prev:       '<span class="shortcut">P</span>revious',

            errors:     {
                single: 'You must install the <a href="{0}">{1}</a> browser plugin to view this content.',
                shared: 'You must install both the <a href="{0}">{1}</a> and <a href="{2}">{3}</a> browser plugins to view this content.',
                either: 'You must install either the <a href="{0}">{1}</a> or the <a href="{2}">{3}</a> browser plugin to view this content.'
            }

        },

        /**
         * An object containing names of plugins and links to their respective
         * download pages.
         *
         * @var     {Object}    errors
         */
        errors:         {

            fla:        {
                name:   'Flash',
                url:    'http://www.adobe.com/products/flashplayer/'
            },

            qt:         {
                name:   'QuickTime',
                url:    'http://www.apple.com/quicktime/download/'
            },

            wmp:        {
                name:   'Windows Media Player',
                url:    'http://www.microsoft.com/windows/windowsmedia/'
            },

            f4m:        {
                name:   'Flip4Mac',
                url:    'http://www.flip4mac.com/wmv_download.htm'
            }

        },

        /**
         * The HTML markup to use for Shadowbox. Note: The script depends on
         * most of these elements being present, so don't modify this variable
         * unless you know what you're doing.
         *
         * @var     {Object}    skin
         */
        skin:           {

            main:       '<div id="shadowbox_overlay"></div>' +
                        '<div id="shadowbox_container">' +
                            '<div id="shadowbox">' +
                                '<div id="shadowbox_title">' +
                                    '<div id="shadowbox_title_inner"></div>' +
                                '</div>' +
                                '<div id="shadowbox_body">' +
                                    '<div id="shadowbox_body_inner"></div>' +
                                    '<div id="shadowbox_loading"></div>' +
                                '</div>' +
                                '<div id="shadowbox_toolbar">' +
                                    '<div id="shadowbox_toolbar_inner"></div>' +
                                '</div>' +
                            '</div>' +
                        '</div>',

            loading:    '<img src="{0}" alt="{1}" />' +
                        '<span><a href="javascript:Shadowbox.close();">{2}</a></span>',

            counter:    '<div id="shadowbox_counter">{0}</div>',

            close:      '<div id="shadowbox_nav_close">' +
                            '<a href="javascript:Shadowbox.close();">{0}</a>' +
                        '</div>',

            next:       '<div id="shadowbox_nav_next">' +
                            '<a href="javascript:Shadowbox.next();">{0}</a>' +
                        '</div>',

            prev:       '<div id="shadowbox_nav_previous">' +
                            '<a href="javascript:Shadowbox.previous();">{0}</a>' +
                        '</div>'

        },

        /**
         * An object containing arrays of all supported file extensions. Each
         * property of this object contains an array. If this object is to be
         * modified, it must be done before calling init().
         *
         * - img: Supported image file extensions
         * - qt: Movie file extensions supported by QuickTime
         * - wmp: Movie file extensions supported by Windows Media Player
         * - qtwmp: Movie file extensions supported by both QuickTime and Windows Media Player
         * - iframe: File extensions that will be display in an iframe
         *
         * @var     {Object}    ext
         */
        ext:     {
            img:        ['png', 'jpg', 'jpeg', 'gif', 'bmp'],
            qt:         ['dv', 'mov', 'moov', 'movie', 'mp4'],
            wmp:        ['asf', 'wm', 'wmv'],
            qtwmp:      ['avi', 'mpg', 'mpeg'],
            iframe:     ['asp', 'aspx', 'cgi', 'cfm', 'htm', 'html', 'pl', 'php',
                        'php3', 'php4', 'php5', 'phtml', 'rb', 'rhtml', 'shtml',
                        'txt', 'vbs']
        }

    };

    /**
     * Stores the default set of options in case a custom set of options is used
     * on a link-by-link basis so we can restore them later.
     *
     * @property    {Object}    default_options
     * @private
     */
    var default_options = null;

    /**
     * Shorthand for Shadowbox.lib.
     *
     * @property    {Object}        SL
     * @private
     */
    var SL = Shadowbox.lib;

    /**
     * An object containing some regular expressions we'll need later. Compiled
     * up front for speed.
     *
     * @property    {Object}        RE
     * @private
     */
    var RE = {
        resize:         /(img|swf|flv)/, // file types to resize
        overlay:        /(img|iframe|html|inline)/, // content types to not use an overlay image for on FF Mac
        swf:            /\.swf\s*$/i, // swf file extension
        flv:            /\.flv\s*$/i, // flv file extension
        domain:         /:\/\/(.*?)[:\/]/, // domain prefix
        inline:         /#(.+)$/, // inline element id
        rel:            /^(light|shadow)box/i, // rel attribute format
        gallery:        /^(light|shadow)box\[(.*?)\]/i, // rel attribute format for gallery link
        unsupported:    /^unsupported-(\w+)/, // unsupported media type
        param:          /\s*([a-z_]*?)\s*=\s*(.+)\s*/, // rel string parameter
        empty:          /^(?:br|frame|hr|img|input|link|meta|range|spacer|wbr|area|param|col)$/i // elements that don't have children
    };

    /**
     * A cache of options for links that have been set up for use with
     * Shadowbox.
     *
     * @property    {Array}         cache
     * @private
     */
    var cache = [];

    /**
     * An array of pieces currently being viewed. In the case of non-gallery
     * pieces, this will only hold one object.
     *
     * @property    {Array}         current_gallery
     * @private
     */
    var current_gallery;

    /**
     * The array index of the current_gallery that is currently being viewed.
     *
     * @property    {Number}        current
     * @private
     */
    var current;

    /**
     * Keeps track of the current optimal height of the box. We use this so that
     * if the user resizes the browser window to get a better view, and we're
     * currently at a size smaller than the optimal, we can resize easily.
     *
     * @see         resizeContent()
     * @property    {Number}        optimal_height
     * @private
     */
    var optimal_height = options.initialHeight;

    /**
     * Keeps track of the current optimal width of the box. See optimal_height
     * explanation (above).
     *
     * @property    {Number}        optimal_width
     * @private
     */
    var optimal_width = options.initialWidth;

    /**
     * Keeps track of the current height of the box. This is useful in drag
     * calculations.
     *
     * @property    {Number}        current_height
     * @private
     */
    var current_height = 0;

    /**
     * Keeps track of the current width of the box. Useful in drag calculations.
     *
     * @property    {Number}        current_width
     * @private
     */
    var current_width = 0;

    /**
     * Resource used to preload images. It's class-level so that when a new
     * image is requested, the same resource can be reassigned, cancelling
     * the original's callback.
     *
     * @property    {HTMLElement}   preloader
     * @private
     */
    var preloader;

    /**
     * Keeps track of whether or not Shadowbox has been initialized. We never
     * want to initialize twice.
     *
     * @property    {Boolean}       initialized
     * @private
     */
    var initialized = false;

    /**
     * Keeps track of whether or not Shadowbox is activated.
     *
     * @property    {Boolean}       activated
     * @private
     */
    var activated = false;

    /**
     * Keeps track of 4 floating values (x, y, start_x, & start_y) that are used
     * in the drag calculations.
     *
     * @property    {Object}        drag
     * @private
     */
    var drag;

    /**
     * Holds the draggable element so we don't have to fetch it every time
     * the mouse moves.
     *
     * @property    {HTMLElement}   draggable
     * @private
     */
    var draggable;

    /**
     * Keeps track of whether or not we're currently using the overlay
     * background image to display the current gallery. We do this because we
     * use different methods for fading the overlay in and out. The color fill
     * overlay fades in and out nicely, but the image overlay stutters. By
     * keeping track of the type of overlay in use, we don't have to check again
     * what type of overlay we're using when it's time to get rid of it later.
     *
     * @property    {Boolean}       overlay_img_needed
     * @private
     */
    var overlay_img_needed;

    /**
     * These parameters for simple browser detection. Used in Ext.js.
     *
     * @ignore
     */
    var ua = navigator.userAgent.toLowerCase();
    var isStrict = document.compatMode == 'CSS1Compat',
        isOpera = ua.indexOf("opera") > -1,
        isIE = ua.indexOf('msie') > -1,
        isIE7 = ua.indexOf('msie 7') > -1,
        isIE9 = ua.indexOf('msie 9') > -1,
        isBorderBox = isIE && !isStrict,
        isSafari = (/webkit|khtml/).test(ua),
        isSafari3 = isSafari && !!(document.evaluate),
        isGecko = !isSafari && ua.indexOf('gecko') > -1,
        isWindows = (ua.indexOf('windows') != -1 || ua.indexOf('win32') != -1),
        isMac = (ua.indexOf('macintosh') != -1 || ua.indexOf('mac os x') != -1),
        isLinux = (ua.indexOf('linux') != -1);

    /**
     * Do we need to hack the position to make Shadowbox appear fixed? We could
     * hack this using CSS, but let's just get over all the hacks and let IE6
     * users get what they deserve! Down with hacks! Hmm...now that I think
     * about it, I should just flash all kinds of alerts and annoying popups on
     * their screens, and then redirect them to some foreign spyware site that
     * will upload a nasty virus...
     *
     * @property    {Boolean}   absolute_pos
     * @private
     */
    var absolute_pos = isIE && !isIE7;

    /**
     * Contains plugin support information. Each property of this object is a
     * boolean indicating whether that plugin is supported.
     *
     * - fla: Flash player
     * - qt: QuickTime player
     * - wmp: Windows Media player
     * - f4m: Flip4Mac plugin
     *
     * @property    {Object}    plugins
     * @private
     */
    var plugins = null;

    // detect plugin support
    if(navigator.plugins && navigator.plugins.length){
        var detectPlugin = function(plugin_name){
            var detected = false;
            for (var i = 0, len = navigator.plugins.length; i < len; ++i){
                if(navigator.plugins[i].name.indexOf(plugin_name) > -1){
                    detected = true;
                    break;
                }
            }
            return detected;
        };
        var f4m = detectPlugin('Flip4Mac');
        var plugins = {
            fla:    detectPlugin('Shockwave Flash'),
            qt:     detectPlugin('QuickTime'),
            wmp:    !f4m && detectPlugin('Windows Media'), // if it's Flip4Mac, it's not really WMP
            f4m:    f4m
        };
    }else{
        var detectPlugin = function(plugin_name){
            var detected = false;
            try {
                var axo = new ActiveXObject(plugin_name);
                if(axo){
                    detected = true;
                }
            } catch (e) {}
            return detected;
        };
        var plugins = {
            fla:    detectPlugin('ShockwaveFlash.ShockwaveFlash'),
            qt:     detectPlugin('QuickTime.QuickTime'),
            wmp:    detectPlugin('wmplayer.ocx'),
            f4m:    false
        };
    }

    /**
     * Applies all properties of e to o. This function is recursive so that if
     * any properties of e are themselves objects, those objects will be applied
     * to objects with the same key that may exist in o.
     *
     * @param   {Object}    o       The original object
     * @param   {Object}    e       The extension object
     * @return  {Object}            The original object with all properties
     *                              of the extension object applied (deep)
     * @private
     */
    var apply = function(o, e){
        for(var p in e) o[p] = e[p];
        return o;
    };

    /**
     * Determines if the given object is an anchor/area element.
     *
     * @param   {mixed}     el      The object to check
     * @return  {Boolean}           True if the object is a link element
     * @private
     */
    var isLink = function(el){
        return typeof el.tagName == 'string' && (el.tagName.toUpperCase() == 'A' || el.tagName.toUpperCase() == 'AREA');
    };

    /**
     * Gets the height of the viewport in pixels. Note: This function includes
     * scrollbars in Safari 3.
     *
     * @return  {Number}        The height of the viewport
     * @public
     * @static
     */
    SL.getViewportHeight = function(){
        var height = window.innerHeight; // Safari
        var mode = document.compatMode;
        if((mode || isIE) && !isOpera){
            height = isStrict ? document.documentElement.clientHeight : document.body.clientHeight;
        }
        return height;
    };

    /**
     * Gets the width of the viewport in pixels. Note: This function includes
     * scrollbars in Safari 3.
     *
     * @return  {Number}        The width of the viewport
     * @public
     * @static
     */
    SL.getViewportWidth = function(){
        var width = window.innerWidth; // Safari
        var mode = document.compatMode;
        if(mode || isIE){
            width = isStrict ? document.documentElement.clientWidth : document.body.clientWidth;
        }
        return width;
    };

    /**
     * Gets the height of the document (body and its margins) in pixels.
     *
     * @return  {Number}        The height of the document
     * @public
     * @static
     */
    SL.getDocumentHeight = function(){
        var scrollHeight = isStrict ? document.documentElement.scrollHeight : document.body.scrollHeight;
        return Math.max(scrollHeight, SL.getViewportHeight());
    };

    /**
     * Gets the width of the document (body and its margins) in pixels.
     *
     * @return  {Number}        The width of the document
     * @public
     * @static
     */
    SL.getDocumentWidth = function(){
        var scrollWidth = isStrict ? document.documentElement.scrollWidth : document.body.scrollWidth;
        return Math.max(scrollWidth, SL.getViewportWidth());
    };

    /**
     * A utility function used by the fade functions to clear the opacity
     * style setting of the given element. Required in some cases for IE.
     * Based on Ext.Element's clearOpacity.
     *
     * @param   {HTMLElement}   el      The DOM element
     * @return  void
     * @private
     */
    var clearOpacity = function(el){
        if(isIE && !isIE9){
            if(typeof el.style.filter == 'string' && (/alpha/i).test(el.style.filter)){
                el.style.filter = '';
            }
        }else{
            el.style.opacity = '';
            el.style['-moz-opacity'] = '';
            el.style['-khtml-opacity'] = '';
        }
    };

    /**
     * Fades the given element from 0 to the specified opacity.
     *
     * @param   {HTMLElement}   el              The DOM element to fade
     * @param   {Number}        endingOpacity   The final opacity to animate to
     * @param   {Number}        duration        The duration of the animation
     *                                          (in seconds)
     * @param   {Function}      callback        A callback function to call
     *                                          when the animation completes
     * @return  void
     * @private
     */
    var fadeIn = function(el, endingOpacity, duration, callback){
        if(options.animate){
            SL.setStyle(el, 'opacity', 0);
            el.style.visibility = 'visible';
            SL.animate(el, {
                opacity: { to: endingOpacity }
            }, duration, function(){
                if(endingOpacity == 1) clearOpacity(el);
                if(typeof callback == 'function') callback();
            });
        }else{
            if(endingOpacity == 1){
                clearOpacity(el);
            }else{
                SL.setStyle(el, 'opacity', endingOpacity);
            }
            el.style.visibility = 'visible';
            if(typeof callback == 'function') callback();
        }
    };

    /**
     * Fades the given element from its current opacity to 0.
     *
     * @param   {HTMLElement}   el          The DOM element to fade
     * @param   {Number}        duration    The duration of the fade animation
     * @param   {Function}      callback    A callback function to call when
     *                                      the animation completes
     * @return  void
     * @private
     */
    var fadeOut = function(el, duration, callback){
        var cb = function(){
            el.style.visibility = 'hidden';
            clearOpacity(el);
            if(typeof callback == 'function') callback();
        };
        if(options.animate){
            SL.animate(el, {
                opacity: { to: 0 }
            }, duration, cb);
        }else{
            cb();
        }
    };

    /**
     * Appends an HTML fragment to the given element.
     *
     * @param   {String/HTMLElement}    el      The element to append to
     * @param   {String}                html    The HTML fragment to use
     * @return  {HTMLElement}                   The newly appended element
     * @private
     */
    var appendHTML = function(el, html){
        el = SL.get(el);
        if(el.insertAdjacentHTML){
            el.insertAdjacentHTML('BeforeEnd', html);
            return el.lastChild;
        }
        if(el.lastChild){
            var range = el.ownerDocument.createRange();
            range.setStartAfter(el.lastChild);
            var frag = range.createContextualFragment(html);
            el.appendChild(frag);
            return el.lastChild;
        }else{
            el.innerHTML = html;
            return el.lastChild;
        }
    };

    /**
     * Overwrites the HTML of the given element.
     *
     * @param   {String/HTMLElement}    el      The element to overwrite
     * @param   {String}                html    The new HTML to use
     * @return  {HTMLElement}                   The new firstChild element
     * @private
     */
    var overwriteHTML = function(el, html){
        el = SL.get(el);
        el.innerHTML = html;
        return el.firstChild;
    };

    /**
     * Gets either the offsetHeight or the height of the given element plus
     * padding and borders (when offsetHeight is not available). Based on
     * Ext.Element's getComputedHeight.
     *
     * @return  {Number}            The computed height of the element
     * @private
     */
    var getComputedHeight = function(el){
        var h = Math.max(el.offsetHeight, el.clientHeight);
        if(!h){
            h = parseInt(SL.getStyle(el, 'height'), 10) || 0;
            if(!isBorderBox){
                h += parseInt(SL.getStyle(el, 'padding-top'), 10)
                    + parseInt(SL.getStyle(el, 'padding-bottom'), 10)
                    + parseInt(SL.getStyle(el, 'border-top-width'), 10)
                    + parseInt(SL.getStyle(el, 'border-bottom-width'), 10);
            }
        }
        return h;
    };

    /**
     * Gets either the offsetWidth or the width of the given element plus
     * padding and borders (when offsetWidth is not available). Based on
     * Ext.Element's getComputedWidth.
     *
     * @return  {Number}            The computed width of the element
     * @private
     */
    var getComputedWidth = function(el){
        var w = Math.max(el.offsetWidth, el.clientWidth);
        if(!w){
            w = parseInt(SL.getStyle(el, 'width'), 10) || 0;
            if(!isBorderBox){
                w += parseInt(SL.getStyle(el, 'padding-left'), 10)
                    + parseInt(SL.getStyle(el, 'padding-right'), 10)
                    + parseInt(SL.getStyle(el, 'border-left-width'), 10)
                    + parseInt(SL.getStyle(el, 'border-right-width'), 10);
            }
        }
        return w;
    };

    /**
     * Determines the player needed to display the file at the given URL. If
     * the file type is not supported, the return value will be 'unsupported'.
     * If the file type is not supported but the correct player can be
     * determined, the return value will be 'unsupported-*' where * will be the
     * player abbreviation (e.g. 'qt' = QuickTime).
     *
     * @param   {String}        url     The url of the file
     * @return  {String}                The name of the player to use
     * @private
     */
    var getPlayerType = function(url){
        if(RE.img.test(url)) return 'img';
        var match = url.match(RE.domain);
        var this_domain = match ? document.domain == match[1] : false;
        if(url.indexOf('#') > -1 && this_domain) return 'inline';
        var q_index = url.indexOf('?');
        if(q_index > -1) url = url.substring(0, q_index); // strip query string for player detection purposes
        if(RE.swf.test(url)) return plugins.fla ? 'swf' : 'unsupported-swf';
        if(RE.flv.test(url)) return plugins.fla ? 'flv' : 'unsupported-flv';
        if(RE.qt.test(url)) return plugins.qt ? 'qt' : 'unsupported-qt';
        if(RE.wmp.test(url)){
            if(plugins.wmp){
                return 'wmp';
            }else if(plugins.f4m){
                return 'qt';
            }else{
                return isMac ? (plugins.qt ? 'unsupported-f4m' : 'unsupported-qtf4m') : 'unsupported-wmp';
            }
        }else if(RE.qtwmp.test(url)){
            if(plugins.qt){
                return 'qt';
            }else if(plugins.wmp){
                return 'wmp';
            }else{
                return isMac ? 'unsupported-qt' : 'unsupported-qtwmp';
            }
        }else if(!this_domain || RE.iframe.test(url)){
            return 'iframe';
        }
        return 'iframe';
    };

    /**
     * Handles all clicks on links that have been set up to work with Shadowbox
     * and cancels the default event behavior when appropriate.
     *
     * @param   {Event}         ev          The click event object
     * @return  void
     * @private
     */
    var handleClick = function(ev){
        // get anchor/area element
        var link;
        if(isLink(this)){
            link = this; // jQuery, Prototype, YUI
        }else{
            link = SL.getTarget(ev); // Ext
            while(!isLink(link) && link.parentNode){
                link = link.parentNode;
            }
        }

        Shadowbox.open(link);
        if(current_gallery.length) SL.preventDefault(ev);
    };

    /**
     * Sets up the current gallery for the given object. Modifies the current
     * and current_gallery variables to contain the appropriate information.
     * Also, checks to see if there are any gallery pieces that are not
     * supported by the client's browser/plugins. If there are, they will be
     * handled according to the handleUnsupported option.
     *
     * @param   {Object}    obj         The content to get the gallery for
     * @return  void
     * @private
     */
    var setupGallery = function(obj){
        // create a copy so it doesn't get modified later
        var copy = apply({}, obj);

        // is it part of a gallery?
        if(!obj.gallery){ // single item, no gallery
            current_gallery = [copy];
            current = 0;
        }else{
            current_gallery = []; // clear the current gallery
            var index, ci;
            for(var i = 0, len = cache.length; i < len; ++i){
                ci = cache[i];
                if(ci.gallery){
                    if(ci.content == obj.content
                        && ci.gallery == obj.gallery
                        && ci.title == obj.title){ // compare content, gallery, & title
                            index = current_gallery.length; // key element found
                    }
                    if(ci.gallery == obj.gallery){
                        current_gallery.push(apply({}, ci));
                    }
                }
            }
            // if not found in cache, prepend to front of gallery
            if(index == null){
                current_gallery.unshift(copy);
                index = 0;
            }
            current = index;
        }

        // are any media in the current gallery supported?
        var match, r;
        for(var i = 0, len = current_gallery.length; i < len; ++i){
            r = false;
            if(current_gallery[i].type == 'unsupported'){ // don't support this at all
                r = true;
            }else if(match = RE.unsupported.exec(current_gallery[i].type)){ // handle unsupported elements
                if(options.handleUnsupported == 'link'){
                    current_gallery[i].type = 'html';
                    // generate a link to the appropriate plugin download page(s)
                    var m;
                    switch(match[1]){
                        case 'qtwmp':
                            m = String.format(options.text.errors.either,
                                options.errors.qt.url, options.errors.qt.name,
                                options.errors.wmp.url, options.errors.wmp.name);
                        break;
                        case 'qtf4m':
                            m = String.format(options.text.errors.shared,
                                options.errors.qt.url, options.errors.qt.name,
                                options.errors.f4m.url, options.errors.f4m.name);
                        break;
                        default:
                            if(match[1] == 'swf' || match[1] == 'flv') match[1] = 'fla';
                            m = String.format(options.text.errors.single,
                                options.errors[match[1]].url, options.errors[match[1]].name);
                    }
                    current_gallery[i] = apply(current_gallery[i], {
                        height:     160, // error messages are short so they
                        width:      320, // only need a small box to display properly
                        content:    '<div class="shadowbox_message">' + m + '</div>'
                    });
                }else{
                    r = true;
                }
            }else if(current_gallery[i].type == 'inline'){ // handle inline elements
                // retrieve the innerHTML of the inline element
                var match = RE.inline.exec(current_gallery[i].content);
                if(match){
                    var el;
                    if(el = SL.get(match[1])){
                        current_gallery[i].content = el.innerHTML;
                    }else{
                        throw 'No element found with id ' + match[1];
                    }
                }else{
                    throw 'No element id found for inline content';
                }
            }
            if(r){
                // remove the element from the gallery
                current_gallery.splice(i, 1);
                if(i < current) --current;
                --i;
            }
        }
    };

    /**
     * Hides the title bar and toolbar and populates them with the proper
     * content.
     *
     * @return  void
     * @private
     */
    var buildBars = function(){
        var link = current_gallery[current];
        if(!link) return; // nothing to build

        // build the title
        var title_i = SL.get('shadowbox_title_inner');
        title_i.innerHTML = (link.title) ? link.title : '';
        // empty the toolbar
        var tool_i = SL.get('shadowbox_toolbar_inner');
        tool_i.innerHTML = '';

        // build the nav
        if(options.displayNav){
            tool_i.innerHTML = String.format(options.skin.close, options.text.close);
            if(current_gallery.length > 1){
                if(options.continuous){
                    // show both
                    appendHTML(tool_i, String.format(options.skin.next, options.text.next));
                    appendHTML(tool_i, String.format(options.skin.prev, options.text.prev));
                }else{
                    // not last in the gallery, show the next link
                    if((current_gallery.length - 1) > current){
                        appendHTML(tool_i, String.format(options.skin.next, options.text.next));
                    }
                    // not first in the gallery, show the previous link
                    if(current > 0){
                        appendHTML(tool_i, String.format(options.skin.prev, options.text.prev));
                    }
                }
            }
        }

        // build the counter
        if(current_gallery.length > 1 && options.displayCounter){
            // append the counter div
            var counter = '';
            if(options.counterType == 'skip'){
                for(var i = 0, len = current_gallery.length; i < len; ++i){
                    counter += '<a href="javascript:Shadowbox.change(' + i + ');"';
                    if(i == current){
                        counter += ' class="shadowbox_counter_current"';
                    }
                    counter += '>' + (i + 1) + '</a>';
                }
            }else{
                counter = (current + 1) + ' of ' + current_gallery.length;
            }
            appendHTML(tool_i, String.format(options.skin.counter, counter));
        }
    };

    /**
     * Hides the title and tool bars.
     *
     * @param   {Function}  callback        A function to call on finish
     * @return  void
     * @private
     */
    var hideBars = function(callback){
        var title_m = getComputedHeight(SL.get('shadowbox_title'));
        var tool_m = 0 - getComputedHeight(SL.get('shadowbox_toolbar'));
        var title_i = SL.get('shadowbox_title_inner');
        var tool_i = SL.get('shadowbox_toolbar_inner');

        if(options.animate && callback){
            // animate the transition
            SL.animate(title_i, {
                marginTop: { to: title_m }
            }, 0.2);
            SL.animate(tool_i, {
                marginTop: { to: tool_m }
            }, 0.2, callback);
        }else{
            SL.setStyle(title_i, 'marginTop', title_m + 'px');
            SL.setStyle(tool_i, 'marginTop', tool_m + 'px');
        }
    };

    /**
     * Shows the title and tool bars.
     *
     * @param   {Function}  callback        A callback function to execute after
     *                                      the animation completes
     * @return  void
     * @private
     */
    var showBars = function(callback){
        var title_i = SL.get('shadowbox_title_inner');
        if(options.animate){
            if(title_i.innerHTML != ''){
                SL.animate(title_i, { marginTop: { to: 0 } }, 0.35);
            }
            SL.animate(SL.get('shadowbox_toolbar_inner'), {
                marginTop: { to: 0 }
            }, 0.35, callback);
        }else{
            if(title_i.innerHTML != ''){
                SL.setStyle(title_i, 'margin-top', '0px');
            }
            SL.setStyle(SL.get('shadowbox_toolbar_inner'), 'margin-top', '0px');
            callback();
        }
    };

    /**
     * Resets the class drag variable.
     *
     * @return  void
     * @private
     */
    var resetDrag = function(){
        drag = {
            x:          0,
            y:          0,
            start_x:    null,
            start_y:    null
        };
    };

    /**
     * Toggles the drag function on and off.
     *
     * @param   {Boolean}   on      True to toggle on, false to toggle off
     * @return  void
     * @private
     */
    var toggleDrag = function(on){
        if(on){
            resetDrag();
            // add drag layer to prevent browser dragging of actual image
            var styles = [
                'position:absolute',
                'cursor:' + (isGecko ? '-moz-grab' : 'move')
            ];
            // make drag layer transparent
            styles.push(isIE ? 'background-color:#fff;filter:alpha(opacity=0)' : 'background-color:transparent');
            appendHTML('shadowbox_body_inner', '<div id="shadowbox_drag_layer" style="' + styles.join(';') + '"></div>');
            SL.addEvent(SL.get('shadowbox_drag_layer'), 'mousedown', listenDrag);
        }else{
            var d = SL.get('shadowbox_drag_layer');
            if(d){
                SL.removeEvent(d, 'mousedown', listenDrag);
                SL.remove(d);
            }
        }
    };

    /**
     * Sets up a drag listener on the document. Called when the mouse button is
     * pressed (mousedown).
     *
     * @param   {mixed}     ev      The mousedown event
     * @return  void
     * @private
     */
    var listenDrag = function(ev){
        drag.start_x = ev.clientX;
        drag.start_y = ev.clientY;
        draggable = SL.get('shadowbox_content');
        SL.addEvent(document, 'mousemove', positionDrag);
        SL.addEvent(document, 'mouseup', unlistenDrag);
        if(isGecko) SL.setStyle(SL.get('shadowbox_drag_layer'), 'cursor', '-moz-grabbing');
    };

    /**
     * Removes the drag listener. Called when the mouse button is released
     * (mouseup).
     *
     * @return  void
     * @private
     */
    var unlistenDrag = function(){
        SL.removeEvent(document, 'mousemove', positionDrag);
        SL.removeEvent(document, 'mouseup', unlistenDrag); // clean up
        if(isGecko) SL.setStyle(SL.get('shadowbox_drag_layer'), 'cursor', '-moz-grab');
    };

    /**
     * Positions an oversized image on drag.
     *
     * @param   {mixed}     ev      The drag event
     * @return  void
     * @private
     */
    var positionDrag = function(ev){
        var move_y = ev.clientY - drag.start_y;
        drag.start_y = drag.start_y + move_y;
        drag.y = Math.max(Math.min(0, drag.y + move_y), current_height - optimal_height); // y boundaries
        SL.setStyle(draggable, 'top', drag.y + 'px');
        var move_x = ev.clientX - drag.start_x;
        drag.start_x = drag.start_x + move_x;
        drag.x = Math.max(Math.min(0, drag.x + move_x), current_width - optimal_width); // x boundaries
        SL.setStyle(draggable, 'left', drag.x + 'px');
    };

    /**
     * Loads the Shadowbox with the current piece.
     *
     * @return  void
     * @private
     */
    var loadContent = function(){
        var obj = current_gallery[current];
        if(!obj) return; // invalid

        buildBars();

        switch(obj.type){
            case 'img':
                // preload the image
                preloader = new Image();
                preloader.onload = function(){
                    // images default to image height and width
                    var h = obj.height ? parseInt(obj.height, 10) : preloader.height;
                    var w = obj.width ? parseInt(obj.width, 10) : preloader.width;
                    resizeContent(h, w, function(dims){
                        showBars(function(){
                            setContent({
                                tag:    'img',
                                height: dims.i_height,
                                width:  dims.i_width,
                                src:    obj.content,
                                style:  'position:absolute'
                            });
                            if(dims.enableDrag && options.handleLgImages == 'drag'){
                                // listen for drag
                                toggleDrag(true);
                                SL.setStyle(SL.get('shadowbox_drag_layer'), {
                                    height:     dims.i_height + 'px',
                                    width:      dims.i_width + 'px'
                                });
                            }
                            finishContent();
                        });
                    });

                    preloader.onload = function(){}; // clear onload for IE
                };
                preloader.src = obj.content;
            break;

            case 'swf':
            case 'flv':
            case 'qt':
            case 'wmp':
                var markup = Shadowbox.movieMarkup(obj);
                resizeContent(markup.height, markup.width, function(){
                    showBars(function(){
                        setContent(markup);
                        finishContent();
                    });
                });
            break;

            case 'iframe':
                // iframes default to full viewport height and width
                var h = obj.height ? parseInt(obj.height, 10) : SL.getViewportHeight();
                var w = obj.width ? parseInt(obj.width, 10) : SL.getViewportWidth();
                var content = {
                    tag:            'iframe',
                    name:           'shadowbox_content',
                    height:         '100%',
                    width:          '100%',
                    frameborder:    '0',
                    marginwidth:    '0',
                    marginheight:   '0',
                    scrolling:      'auto'
                };

                resizeContent(h, w, function(dims){
                    showBars(function(){
                        setContent(content);
                        var win = (isIE)
                            ? SL.get('shadowbox_content').contentWindow
                            : window.frames['shadowbox_content'];
                        win.location = obj.content;
                        finishContent();
                    });
                });
            break;

            case 'html':
            case 'inline':
                // HTML content defaults to full viewport height and width
                var h = obj.height ? parseInt(obj.height, 10) : SL.getViewportHeight();
                var w = obj.width ? parseInt(obj.width, 10) : SL.getViewportWidth();
                var content = {
                    tag:    'div',
                    cls:    'html', /* give special class to make scrollable */
                    html:   obj.content
                };
                resizeContent(h, w, function(){
                    showBars(function(){
                        setContent(content);
                        finishContent();
                    });
                });
            break;

            default:
                // should never happen
                throw 'Shadowbox cannot open content of type ' + obj.type;
        }

        // preload neighboring images
        if(current_gallery.length > 0){
            var next = current_gallery[current + 1];
            if(!next){
                next = current_gallery[0];
            }
            if(next.type == 'img'){
                var preload_next = new Image();
                preload_next.src = next.content;
            }

            var prev = current_gallery[current - 1];
            if(!prev){
                prev = current_gallery[current_gallery.length - 1];
            }
            if(prev.type == 'img'){
                var preload_prev = new Image();
                preload_prev.src = prev.content;
            }
        }
    };

    /**
     * Removes old content and sets the new content of the Shadowbox.
     *
     * @param   {Object}        obj     The content to set (appropriate to pass
     *                                  directly to Shadowbox.createHTML())
     * @return  {HTMLElement}           The newly appended element (or null if
     *                                  none is provided)
     * @private
     */
    var setContent = function(obj){
        var id = 'shadowbox_content';
        var content = SL.get(id);
        if(content){
            // remove old content first
            switch(content.tagName.toUpperCase()){
                case 'OBJECT':
                    // if we're in a gallery (i.e. changing and there's a new
                    // object) we want the LAST link object
                    var link = current_gallery[(obj ? current - 1 : current)];
                    if(link.type == 'wmp' && isIE){
                        try{
                            shadowbox_content.controls.stop(); // stop the movie
                            shadowbox_content.URL = 'non-existent.wmv'; // force player refresh
                            window.shadowbox_content = function(){}; // remove from window
                        }catch(e){}
                    }else if(link.type == 'qt' && isSafari){
                        try{
                            document.shadowbox_content.Stop(); // stop QT movie
                        }catch(e){}
                        // stop QT audio stream for movies that have not yet loaded
                        content.innerHTML = '';
                        // console.log(document.shadowbox_content);
                    }
                    setTimeout(function(){ // using setTimeout prevents browser crashes with WMP
                        SL.remove(content);
                    }, 10);
                break;
                case 'IFRAME':
                    SL.remove(content);
                    if(isGecko) delete window.frames[id]; // needed for Firefox
                break;
                default:
                    SL.remove(content);
            }
        }
        if(obj){
            if(!obj.id) obj.id = id;
            return appendHTML('shadowbox_body_inner', Shadowbox.createHTML(obj));
        }
        return null;
    };

    /**
     * This function is used as the callback after the Shadowbox has been
     * positioned, resized, and loaded with content.
     *
     * @return  void
     * @private
     */
    var finishContent = function(){
        var obj = current_gallery[current];
        if(!obj) return; // invalid
        hideLoading(function(){
            listenKeyboard(true);
            // fire onFinish handler
            if(options.onFinish && typeof options.onFinish == 'function'){
                options.onFinish(obj);
            }
        });
    };

    /**
     * Resizes and positions the content box using the given height and width.
     * If the callback parameter is missing, the transition will not be
     * animated. If the callback parameter is present, it will be passed the
     * new calculated dimensions object as its first parameter. Note: the height
     * and width here should represent the optimal height and width of the box.
     *
     * @param   {Function}  callback    A callback function to use when the
     *                                  resize completes
     * @return  void
     * @private
     */
    var resizeContent = function(height, width, callback){
        // update optimal height and width
        optimal_height = height;
        optimal_width = width;
        var resizable = RE.resize.test(current_gallery[current].type);
        var dims = getDimensions(optimal_height, optimal_width, resizable);
        if(callback){
            var cb = function(){ callback(dims); };
            switch(options.animSequence){
                case 'hw':
                    adjustHeight(dims.height, dims.top, true, function(){
                        adjustWidth(dims.width, true, cb);
                    });
                break;
                case 'wh':
                    adjustWidth(dims.width, true, function(){
                        adjustHeight(dims.height, dims.top, true, cb);
                    });
                break;
                default: // sync
                    adjustWidth(dims.width, true);
                    adjustHeight(dims.height, dims.top, true, cb);
            }
        }else{ // window resize
            adjustWidth(dims.width, false);
            adjustHeight(dims.height, dims.top, false);
            // resize content images & flash in 'resize' mode
            if(options.handleLgImages == 'resize' && resizable){
                var content = SL.get('shadowbox_content');
                if(content){ // may be animating, not present
                    content.height = dims.i_height;
                    content.width = dims.i_width;
                }
            }
        }
    };

    /**
     * Calculates the dimensions for Shadowbox, taking into account the borders,
     * margins, and surrounding elements of the shadowbox_body. If the image
     * is still to large for Shadowbox, and options.handleLgImages is 'resize',
     * the resized dimensions will be returned (preserving the original aspect
     * ratio). Otherwise, the originally calculated dimensions will be returned.
     * The returned object will have the following properties:
     *
     * - height: The height to use for shadowbox_body_inner
     * - width: The width to use for shadowbox
     * - i_height: The height to use for resizable content
     * - i_width: The width to use for resizable content
     * - top: The top to use for shadowbox
     * - enableDrag: True if dragging should be enabled (image is oversized)
     *
     * @param   {Number}    o_height    The optimal height
     * @param   {Number}    o_width     The optimal width
     * @param   {Boolean}   resizable   True if the content is able to be
     *                                  resized. Defaults to false.
     * @return  {Object}                The resize dimensions (see above)
     * @private
     */
    var getDimensions = function(o_height, o_width, resizable){
        if(typeof resizable == 'undefined') resizable = false;

        var height = o_height = parseInt(o_height);
        var width = o_width = parseInt(o_width);
        var shadowbox_b = SL.get('shadowbox_body');

        // calculate the max height
        var view_height = SL.getViewportHeight();
        var extra_height = parseInt(SL.getStyle(shadowbox_b, 'border-top-width'), 10)
            + parseInt(SL.getStyle(shadowbox_b, 'border-bottom-width'), 10)
            + parseInt(SL.getStyle(shadowbox_b, 'margin-top'), 10)
            + parseInt(SL.getStyle(shadowbox_b, 'margin-bottom'), 10)
            + getComputedHeight(SL.get('shadowbox_title'))
            + getComputedHeight(SL.get('shadowbox_toolbar'))
            + (2 * options.viewportPadding);
        if((height + extra_height) >= view_height){
            height = view_height - extra_height;
        }

        // calculate the max width
        var view_width = SL.getViewportWidth();
        var extra_body_width = parseInt(SL.getStyle(shadowbox_b, 'border-left-width'), 10)
            + parseInt(SL.getStyle(shadowbox_b, 'border-right-width'), 10)
            + parseInt(SL.getStyle(shadowbox_b, 'margin-left'), 10)
            + parseInt(SL.getStyle(shadowbox_b, 'margin-right'), 10);
        var extra_width = extra_body_width + (2 * options.viewportPadding);
        if((width + extra_width) >= view_width){
            width = view_width - extra_width;
        }

        // handle oversized images & flash
        var enableDrag = false;
        var i_height = o_height;
        var i_width = o_width;
        var handle = options.handleLgImages;
        if(resizable && (handle == 'resize' || handle == 'drag')){
            var change_h = (o_height - height) / o_height;
            var change_w = (o_width - width) / o_width;
            if(handle == 'resize'){
                if(change_h > change_w){
                    width = Math.round((o_width / o_height) * height);
                }else if(change_w > change_h){
                    height = Math.round((o_height / o_width) * width);
                }
                // adjust image height or width accordingly
                i_width = width;
                i_height = height;
            }else{
                // drag on oversized images only
                var link = current_gallery[current];
                if(link) enableDrag = link.type == 'img' && (change_h > 0 || change_w > 0);
            }
        }

        return {
            height: height,
            width: width + extra_body_width,
            i_height: i_height,
            i_width: i_width,
            top: ((view_height - (height + extra_height)) / 2) + options.viewportPadding,
            enableDrag: enableDrag
        };
    };

    /**
     * Centers Shadowbox vertically in the viewport. Needs to be called on
     * scroll in IE6 because it does not support fixed positioning.
     *
     * @return  void
     * @private
     */
    var centerVertically = function(){
        var shadowbox = SL.get('shadowbox');
        var scroll = document.documentElement.scrollTop;
        var s_top = scroll + Math.round((SL.getViewportHeight() - (shadowbox.offsetHeight || 0)) / 2);
        SL.setStyle(shadowbox, 'top', s_top + 'px');
    };

    /**
     * Adjusts the height of shadowbox_body_inner and centers Shadowbox
     * vertically in the viewport.
     *
     * @param   {Number}    height      The height of shadowbox_body_inner
     * @param   {Number}    top         The top of the Shadowbox
     * @param   {Boolean}   animate     True to animate the transition
     * @param   {Function}  callback    A callback to use when the animation completes
     * @return  void
     * @private
     */
    var adjustHeight = function(height, top, animate, callback){
        height = parseInt(height);

        // update current_height
        current_height = height;

        // adjust the height
        var sbi = SL.get('shadowbox_body_inner');
        if(animate && options.animate){
            SL.animate(sbi, {
                height: { to: height }
            }, options.resizeDuration, callback);
        }else{
            SL.setStyle(sbi, 'height', height + 'px');
            if(typeof callback == 'function') callback();
        }

        // manually adjust the top because we're using fixed positioning in IE6
        if(absolute_pos){
            // listen for scroll so we can adjust
            centerVertically();
            SL.addEvent(window, 'scroll', centerVertically);

            // add scroll to top
            top += document.documentElement.scrollTop;
        }

        // adjust the top
        var shadowbox = SL.get('shadowbox');
        if(animate && options.animate){
            SL.animate(shadowbox, {
                top: { to: top }
            }, options.resizeDuration);
        }else{
            SL.setStyle(shadowbox, 'top', top + 'px');
        }
    };

    /**
     * Adjusts the width of shadowbox.
     *
     * @param   {Number}    width       The width to use
     * @param   {Boolean}   animate     True to animate the transition
     * @param   {Function}  callback    A callback to use when the animation completes
     * @return  void
     * @private
     */
    var adjustWidth = function(width, animate, callback){
        width = parseInt(width);

        // update current_width
        current_width = width;

        var shadowbox = SL.get('shadowbox');
        if(animate && options.animate){
            SL.animate(shadowbox, {
                width: { to: width }
            }, options.resizeDuration, callback);
        }else{
            SL.setStyle(shadowbox, 'width', width + 'px');
            if(typeof callback == 'function') callback();
        }
    };

    /**
     * Sets up a listener on the document for keystrokes.
     *
     * @param   {Boolean}   on      True to enable the listner, false to turn
     *                              it off
     * @return  void
     * @private
     */
    var listenKeyboard = function(on){
        if(!options.enableKeys) return;
        if(on){
            document.onkeydown = handleKey;
        }else{
            document.onkeydown = '';
        }
    };

    /**
     * Asserts the given key or code is present in the array of valid keys.
     *
     * @param   {Array}     valid       An array of valid keys and codes
     * @param   {String}    key         The character that was pressed
     * @param   {Number}    code        The key code that was pressed
     * @return  {Boolean}               True if the key is valid
     * @private
     */
    var assertKey = function(valid, key, code){
        return (valid.indexOf(key) != -1 || valid.indexOf(code) != -1);
    };

    /**
     * A listener function that will act on a key pressed.
     *
     * @param   {Event}     e       The event object
     * @return  void
     * @private
     */
    var handleKey = function(e){
        var code = e ? e.which : event.keyCode;
        var key = String.fromCharCode(code).toLowerCase();
        if(assertKey(options.keysClose, key, code)){
            Shadowbox.close();
        }else if(assertKey(options.keysPrev, key, code)){
            Shadowbox.previous();
        }else if(assertKey(options.keysNext, key, code)){
            Shadowbox.next();
        }
    };

    /**
     * Shows and hides elements that are troublesome for modal overlays.
     *
     * @param   {Boolean}   on      True to show the elements, false otherwise
     * @return  void
     * @private
     */
    var toggleTroubleElements = function(on){
        var vis = (on ? 'visible' : 'hidden');
        var selects = document.getElementsByTagName('select');
        for(i = 0, len = selects.length; i < len; ++i){
            selects[i].style.visibility = vis;
        }
        var objects = document.getElementsByTagName('object');
        for(i = 0, len = objects.length; i < len; ++i){
            objects[i].style.visibility = vis;
        }
        var embeds = document.getElementsByTagName('embed');
        for(i = 0, len = embeds.length; i < len; ++i){
            embeds[i].style.visibility = vis;
        }
    };

    /**
     * Fills the Shadowbox with the loading skin.
     *
     * @return  void
     * @private
     */
    var showLoading = function(){
        var loading = SL.get('shadowbox_loading');
        overwriteHTML(loading, String.format(options.skin.loading,
            options.assetURL + options.loadingImage,
            options.text.loading,
            options.text.cancel));
        loading.style.visibility = 'visible';
    };

    /**
     * Hides the Shadowbox loading skin.
     *
     * @param   {Function}  callback        The callback function to call after
     *                                      hiding the loading skin
     * @return  void
     * @private
     */
    var hideLoading = function(callback){
        var t = current_gallery[current].type;
        var anim = (t == 'img' || t == 'html'); // fade on images & html
        var loading = SL.get('shadowbox_loading');
        if(anim){
            fadeOut(loading, 0.35, callback);
        }else{
            loading.style.visibility = 'hidden';
            callback();
        }
    };

    /**
     * Sets the size of the overlay to the size of the document.
     *
     * @return  void
     * @private
     */
    var resizeOverlay = function(){
        var overlay = SL.get('shadowbox_overlay');
        SL.setStyle(overlay, {
            height: '100%',
            width: '100%'
        });
        SL.setStyle(overlay, 'height', SL.getDocumentHeight() + 'px');
        if(!isSafari3){
            // Safari3 includes vertical scrollbar in SL.getDocumentWidth()!
            // Leave overlay width at 100% for now...
            SL.setStyle(overlay, 'width', SL.getDocumentWidth() + 'px');
        }
    };

    /**
     * Used to determine if the pre-made overlay background image is needed
     * instead of using the trasparent background overlay. A pre-made background
     * image is used for all but image pieces in FF Mac because it has problems
     * displaying correctly if the background layer is not 100% opaque. When
     * displaying a gallery, if any piece in the gallery meets these criteria,
     * the pre-made background image will be used.
     *
     * @return  {Boolean}       Whether or not an overlay image is needed
     * @private
     */
    var checkOverlayImgNeeded = function(){
        if(!(isGecko && isMac)) return false;
        for(var i = 0, len = current_gallery.length; i < len; ++i){
            if(!RE.overlay.exec(current_gallery[i].type)) return true;
        }
        return false;
    };

    /**
     * Activates (or deactivates) the Shadowbox overlay. If a callback function
     * is provided, we know we're activating. Otherwise, deactivate the overlay.
     *
     * @param   {Function}  callback    A callback to call after activation
     * @return  void
     * @private
     */
    var toggleOverlay = function(callback){
        var overlay = SL.get('shadowbox_overlay');
        if(overlay_img_needed == null){
            overlay_img_needed = checkOverlayImgNeeded();
        }

        if(callback){
            resizeOverlay(); // size the overlay before showing
            if(overlay_img_needed){
                SL.setStyle(overlay, {
                    visibility:         'visible',
                    backgroundColor:    'transparent',
                    backgroundImage:    'url(' + options.assetURL + options.overlayBgImage + ')',
                    backgroundRepeat:   'repeat',
                    opacity:            1
                });
                callback();
            }else{
                SL.setStyle(overlay, {
                    visibility:         'visible',
                    backgroundColor:    options.overlayColor,
                    backgroundImage:    'none'
                });
                fadeIn(overlay, options.overlayOpacity, options.fadeDuration,
                    callback);
            }
        }else{
            if(overlay_img_needed){
                SL.setStyle(overlay, 'visibility', 'hidden');
            }else{
                fadeOut(overlay, options.fadeDuration);
            }

            // reset for next time
            overlay_img_needed = null;
        }
    };

    /**
     * Initializes the Shadowbox environment. Appends Shadowbox' HTML to the
     * document and sets up listeners on the window and overlay element.
     *
     * @param   {Object}    opts    The default options to use
     * @return  void
     * @public
     * @static
     */
    Shadowbox.init = function(opts){
        if(initialized) return; // don't initialize twice
        options = apply(options, opts || {});

        // add markup
        appendHTML(document.body, options.skin.main);

        // compile file type regular expressions here for speed
        RE.img = new RegExp('\.(' + options.ext.img.join('|') + ')\s*$', 'i');
        RE.qt = new RegExp('\.(' + options.ext.qt.join('|') + ')\s*$', 'i');
        RE.wmp = new RegExp('\.(' + options.ext.wmp.join('|') + ')\s*$', 'i');
        RE.qtwmp = new RegExp('\.(' + options.ext.qtwmp.join('|') + ')\s*$', 'i');
        RE.iframe = new RegExp('\.(' + options.ext.iframe.join('|') + ')\s*$', 'i');

        // handle window resize events
        var id = null;
        var resize = function(){
            clearInterval(id);
            id = null;
            resizeOverlay();
            resizeContent(optimal_height, optimal_width);
        };
        SL.addEvent(window, 'resize', function(){
            if(activated){
                // use event buffering to prevent jerky window resizing
                if(id){
                    clearInterval(id);
                    id = null;
                }
                if(!id) id = setInterval(resize, 50);
            }
        });

        if(options.listenOverlay){
            // add a listener to the overlay
            SL.addEvent(SL.get('shadowbox_overlay'), 'click', Shadowbox.close);
        }

        // adjust some positioning if needed
        if(absolute_pos){
            // give the container absolute positioning
            SL.setStyle(SL.get('shadowbox_container'), 'position', 'absolute');
            // give shadowbox_body "layout"...whatever that is
            SL.setStyle('shadowbox_body', 'zoom', 1);
            // need to listen to the container element because it covers the top
            // half of the page
            SL.addEvent(SL.get('shadowbox_container'), 'click', function(e){
                var target = SL.getTarget(e);
                if(target.id && target.id == 'shadowbox_container') Shadowbox.close();
            });
        }

        // skip setup, will need to be done manually later
        if(!options.skipSetup) Shadowbox.setup();
        initialized = true;
    };

    /**
     * Sets up listeners on the given links that will trigger Shadowbox. If no
     * links are given, this method will set up every anchor element on the page
     * with the appropriate rel attribute. Note: Because AREA elements do not
     * support the rel attribute, they must be explicitly passed to this method.
     *
     * @param   {Array}     links       An array (or array-like) list of anchor
     *                                  and/or area elements to set up
     * @param   {Object}    opts        Some options to use for the given links
     * @return  void
     * @public
     * @static
     */
    Shadowbox.setup = function(links, opts){
        // get links if none specified
        if(!links){
            var links = [];
            var a = document.getElementsByTagName('a'), rel;
            for(var i = 0, len = a.length; i < len; ++i){
                rel = a[i].getAttribute('data\-rel');

                if(!rel){
                    rel = a[i].getAttribute('rel') ;
                }

                if(rel && RE.rel.test(rel)) links[links.length] = a[i];
            }
        }else if(!links.length){
            links = [links]; // one link
        }

        var link;
        for(var i = 0, len = links.length; i < len; ++i){
            link = links[i];
            if(typeof link.shadowboxCacheKey == 'undefined'){
                // assign cache key expando
                // use integer primitive to avoid memory leak in IE
                link.shadowboxCacheKey = cache.length;
                SL.addEvent(link, 'click', handleClick); // add listener
            }
            cache[link.shadowboxCacheKey] = this.buildCacheObj(link, opts);
        }
    };

    /**
     * Builds an object from the original link element data to store in cache.
     * These objects contain (most of) the following keys:
     *
     * - el: the link element
     * - title: the linked file title
     * - type: the linked file type
     * - content: the linked file's URL
     * - gallery: the gallery the file belongs to (optional)
     * - height: the height of the linked file (only necessary for movies)
     * - width: the width of the linked file (only necessary for movies)
     * - options: custom options to use (optional)
     *
     * @param   {HTMLElement}   link    The link element to process
     * @return  {Object}                An object representing the link
     * @public
     * @static
     */
    Shadowbox.buildCacheObj = function(link, opts){
        var href = link.href; // don't use getAttribute() here
        var o = {
            el:         link,
            title:      link.getAttribute('title'),
            type:       getPlayerType(href),
            options:    apply({}, opts || {}), // break the reference
            content:    href
        };

        // remove link-level options from top-level options
        var opt, l_opts = ['title', 'type', 'height', 'width', 'gallery'];
        for(var i = 0, len = l_opts.length; i < len; ++i){
            opt = l_opts[i];
            if(typeof o.options[opt] != 'undefined'){
                o[opt] = o.options[opt];
                delete o.options[opt];
            }
        }

        // HTML options always trump JavaScript options, so do these last
        var rel = link.getAttribute('data\-rel');

        if(!rel){
            rel = link.getAttribute('rel') ;
        }

        if(rel){
            // extract gallery name from shadowbox[name] format
            var match = rel.match(RE.gallery);
            if(match) o.gallery = escape(match[2]);

            // other parameters
            var params = rel.split(';');
            for(var i = 0, len = params.length; i < len; ++i){
                match = params[i].match(RE.param);
                if(match){
                    if(match[1] == 'options'){
                        eval('o.options = apply(o.options, ' + match[2] + ')');
                    }else{
                        o[match[1]] = match[2];
                    }
                }
            }
        }

        return o;
    };

    /**
     * Applies the given set of options to those currently in use. Note: Options
     * will be reset on Shadowbox.open() so this function is only useful after
     * it has already been called (while Shadowbox is open).
     *
     * @param   {Object}    opts        The options to apply
     * @return  void
     * @public
     * @static
     */
    Shadowbox.applyOptions = function(opts){
        if(opts){
            // use apply here to break references
            default_options = apply({}, options); // store default options
            options = apply(options, opts); // apply options
        }
    };

    /**
     * Reverts Shadowbox' options to the last default set in use before
     * Shadowbox.applyOptions() was called.
     *
     * @return  void
     * @public
     * @static
     */
    Shadowbox.revertOptions = function(){
        if(default_options){
            options = default_options; // revert to default options
            default_options = null; // erase for next time
        }
    };

    /**
     * Opens the given object in Shadowbox. This object may be either an
     * anchor/area element, or an object similar to the one created by
     * Shadowbox.buildCacheObj().
     *
     * @param   {mixed}     obj         The object or link element that defines
     *                                  what to display
     * @return  void
     * @public
     * @static
     */
    Shadowbox.open = function(obj, opts){
        if(activated) return; // already open
        activated = true;

        // is it a link?
        if(isLink(obj)){
            if(typeof obj.shadowboxCacheKey == 'undefined' || typeof cache[obj.shadowboxCacheKey] == 'undefined'){
                // link element that hasn't been set up before
                // create an object on-the-fly
                obj = this.buildCacheObj(obj, opts);
            }else{
                // link element that has been set up before, get from cache
                obj = cache[obj.shadowboxCacheKey];
            }
        }

        this.revertOptions();
        if(obj.options || opts){
            // use apply here to break references
            this.applyOptions(apply(apply({}, obj.options || {}), opts || {}));
        }

        // update current & current_gallery
        setupGallery(obj);

        // anything to display?
        if(current_gallery.length){
            // fire onOpen hook
            if(options.onOpen && typeof options.onOpen == 'function'){
                options.onOpen(obj);
            }
            document.body.style.overflow = "hidden";

            // display:block here helps with correct dimension calculations
            SL.setStyle(SL.get('shadowbox'), 'display', 'block');

            toggleTroubleElements(false);
            var dims = getDimensions(options.initialHeight, options.initialWidth);
            adjustHeight(dims.height, dims.top);
            adjustWidth(dims.width);
            hideBars(false);

            // show the overlay and load the content
            toggleOverlay(function(){
                SL.setStyle(SL.get('shadowbox'), 'visibility', 'visible');
                showLoading();
                loadContent();
            });
        }
    };

    /**
     * Jumps to the piece in the current gallery with index num.
     *
     * @param   {Number}    num     The gallery index to view
     * @return  void
     * @public
     * @static
     */
    Shadowbox.change = function(num){
        if(!current_gallery) return; // no current gallery
        if(!current_gallery[num]){ // index does not exist
            if(!options.continuous){
                return;
            }else{
                num = (num < 0) ? (current_gallery.length - 1) : 0; // loop
            }
        }

        // update current
        current = num;

        // stop listening for drag
        toggleDrag(false);
        // empty the content
        setContent(null);
        // turn this back on when done
        listenKeyboard(false);

        // fire onChange handler
        if(options.onChange && typeof options.onChange == 'function'){
            options.onChange(current_gallery[current]);
        }

        showLoading();
        hideBars(loadContent);
    };

    /**
     * Jumps to the next piece in the gallery.
     *
     * @return  {Boolean}       True if the gallery changed to next item, false
     *                          otherwise
     * @public
     * @static
     */
    Shadowbox.next = function(){
        return this.change(current + 1);
    };

    /**
     * Jumps to the previous piece in the gallery.
     *
     * @return  {Boolean}       True if the gallery changed to previous item,
     *                          false otherwise
     * @public
     * @static
     */
    Shadowbox.previous = function(){
        return this.change(current - 1);
    };

    /**
     * Deactivates Shadowbox.
     *
     * @return  void
     * @public
     * @static
     */
    Shadowbox.close = function(){
        if(!activated) return; // already closed

        // stop listening for keys
        listenKeyboard(false);
        // hide
        SL.setStyle(SL.get('shadowbox'), {
            display: 'none',
            visibility: 'hidden'
        });
        // stop listening for scroll on IE
        if(absolute_pos) SL.removeEvent(window, 'scroll', centerVertically);
        // stop listening for drag
        toggleDrag(false);
        // empty the content
        setContent(null);
        // prevent old image requests from loading
        if(preloader){
            preloader.onload = function(){};
            preloader = null;
        }
        // hide the overlay
        toggleOverlay(false);
        // turn on trouble elements
        toggleTroubleElements(true);

        // fire onClose handler
        if(options.onClose && typeof options.onClose == 'function'){
            options.onClose(current_gallery[current]);
        }
        document.body.style.overflow = "auto";

        activated = false;
    };

    /**
     * Clears Shadowbox' cache and removes listeners and expandos from all
     * cached link elements. May be used to completely reset Shadowbox in case
     * links on a page change.
     *
     * @return  void
     * @public
     * @static
     */
    Shadowbox.clearCache = function(){
        for(var i = 0, len = cache.length; i < len; ++i){
            if(cache[i].el){
                SL.removeEvent(cache[i].el, 'click', handleClick);
                delete cache[i].shadowboxCacheKey;
            }
        }
        cache = [];
    };

    /**
     * Generates the markup necessary to embed the movie file with the given
     * link element. This markup will be browser-specific. Useful for generating
     * the media test suite.
     *
     * @param   {HTMLElement}   link        The link to the media file
     * @return  {Object}                    The proper markup to use (see above)
     * @public
     * @static
     */
    Shadowbox.movieMarkup = function(obj){
        // movies default to 300x300 pixels
        var h = obj.height ? parseInt(obj.height, 10) : 300;
        var w = obj.width ? parseInt(obj.width, 10) : 300;

        var autoplay = options.autoplayMovies;
        var controls = options.showMovieControls;
        if(obj.options){
            if(obj.options.autoplayMovies != null){
                autoplay = obj.options.autoplayMovies;
            }
            if(obj.options.showMovieControls != null){
                controls = obj.options.showMovieControls;
            }
        }

        var markup = {
            tag:    'object',
            name:   'shadowbox_content'
        };

        switch(obj.type){
            case 'swf':
                var dims = getDimensions(h, w, true);
                h = dims.height;
                w = dims.width;
                markup.type = 'application/x-shockwave-flash';
                markup.data = obj.content;
                markup.children = [
                    { tag: 'param', name: 'movie', value: obj.content }
                ];
            break;
            case 'flv':
                autoplay = autoplay ? 'true' : 'false';
                var showicons = 'false';
                var a = h/w; // aspect ratio
                if(controls){
                    showicons = 'true';
                    h += 20; // height of JW FLV player controller
                }
                var dims = getDimensions(h, h/a, true); // resize
                h = dims.height;
                w = (h-(controls?20:0))/a; // maintain aspect ratio
                var flashvars = [
                    'file=' + obj.content,
                    'height=' + h,
                    'width=' + w,
                    'autostart=' + autoplay,
                    'displayheight=' + (h - (controls?20:0)),
                    'showicons=' + showicons,
                    'backcolor=0x000000&amp;frontcolor=0xCCCCCC&amp;lightcolor=0x557722'
                ];
                markup.type = 'application/x-shockwave-flash';
                markup.data = options.assetURL + options.flvPlayer;
                markup.children = [
                    { tag: 'param', name: 'movie', value: options.assetURL + options.flvPlayer },
                    { tag: 'param', name: 'flashvars', value: flashvars.join('&amp;') },
                    { tag: 'param', name: 'allowfullscreen', value: 'true' }
                ];
            break;
            case 'qt':
                autoplay = autoplay ? 'true' : 'false';
                if(controls){
                    controls = 'true';
                    h += 16; // height of QuickTime controller
                }else{
                    controls = 'false';
                }
                markup.children = [
                    { tag: 'param', name: 'src', value: obj.content },
                    { tag: 'param', name: 'scale', value: 'aspect' },
                    { tag: 'param', name: 'controller', value: controls },
                    { tag: 'param', name: 'autoplay', value: autoplay }
                ];
                if(isIE){
                    markup.classid = 'clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B';
                    markup.codebase = 'http://www.apple.com/qtactivex/qtplugin.cab#version=6,0,2,0';
                }else{
                    markup.type = 'video/quicktime';
                    markup.data = obj.content;
                }
            break;
            case 'wmp':
                autoplay = autoplay ? 1 : 0;
                markup.children = [
                    { tag: 'param', name: 'autostart', value: autoplay }
                ];
                if(isIE){
                    if(controls){
                        controls = 'full';
                        h += 70; // height of WMP controller in IE
                    }else{
                        controls = 'none';
                    }
                    // markup.type = 'application/x-oleobject';
                    markup.classid = 'clsid:6BF52A52-394A-11d3-B153-00C04F79FAA6';
                    markup.children[markup.children.length] = { tag: 'param', name: 'url', value: obj.content };
                    markup.children[markup.children.length] = { tag: 'param', name: 'uimode', value: controls };
                }else{
                    if(controls){
                        controls = 1;
                        h += 45; // height of WMP controller in non-IE
                    }else{
                        controls = 0;
                    }
                    markup.type = 'video/x-ms-wmv';
                    markup.data = obj.content;
                    markup.children[markup.children.length] = { tag: 'param', name: 'showcontrols', value: controls };
                }
            break;
        }

        markup.height = h; // new height includes controller
        markup.width = w;

        return markup;
    };

    /**
     * Creates an HTML string from an object representing HTML elements. Based
     * on Ext.DomHelper's createHtml.
     *
     * @param   {Object}    obj     The HTML definition object
     * @return  {String}            An HTML string
     * @public
     * @static
     */
    Shadowbox.createHTML = function(obj){
        var html = '<' + obj.tag;
        for(var attr in obj){
            if(attr == 'tag' || attr == 'html' || attr == 'children') continue;
            if(attr == 'cls'){
                html += ' class="' + obj['cls'] + '"';
            }else{
                html += ' ' + attr + '="' + obj[attr] + '"';
            }
        }
        if(RE.empty.test(obj.tag)){
            html += '/>\n';
        }else{
            html += '>\n';
            var cn = obj.children;
            if(cn){
                for(var i = 0, len = cn.length; i < len; ++i){
                    html += this.createHTML(cn[i]);
                }
            }
            if(obj.html) html += obj.html;
            html += '</' + obj.tag + '>\n';
        }
        return html;
    };

    /**
     * Gets an object that lists which plugins are supported by the client. The
     * keys of this object will be:
     *
     * - fla: Adobe Flash Player
     * - qt: QuickTime Player
     * - wmp: Windows Media Player
     * - f4m: Flip4Mac QuickTime Player
     *
     * @return  {Object}        The plugins object
     * @public
     * @static
     */
    Shadowbox.getPlugins = function(){
        return plugins;
    };

    /**
     * Gets the current options object in use.
     *
     * @return  {Object}        The options object
     * @public
     * @static
     */
    Shadowbox.getOptions = function(){
        return options;
    };

    /**
     * Gets the current gallery object.
     *
     * @return  {Object}        The current gallery item
     * @public
     * @static
     */
    Shadowbox.getCurrent = function(){
        return current_gallery[current];
    };

    /**
     * Gets the current version number of Shadowbox.
     *
     * @return  {String}        The current version
     * @public
     * @static
     */
    Shadowbox.getVersion = function(){
        return version;
    };

})();

/**
 * Finds the index of the given object in this array.
 *
 * @param   {mixed}     o   The object to search for
 * @return  {Number}        The index of the given object
 * @public
 */
Array.prototype.indexOf = Array.prototype.indexOf || function(o){
    for(var i = 0, len = this.length; i < len; ++i){
        if(this[i] == o) return i;
    }
    return -1;
};

/**
 * Formats a string with the given parameters. The string for format must have
 * placeholders that correspond to the numerical index of the arguments passed
 * in surrounded by curly braces (e.g. 'Some {0} string {1}').
 *
 * @param   {String}    format      The string to format
 * @param   ...                     The parameters to put inside the string
 * @return  {String}                The string with the specified parameters
 *                                  replaced
 * @public
 * @static
 */
String.format = String.format || function(format){
    var args = Array.prototype.slice.call(arguments, 1);
    return format.replace(/\{(\d+)\}/g, function(m, i){
        return args[i];
    });
};
