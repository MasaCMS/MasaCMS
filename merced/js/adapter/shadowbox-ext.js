/**
 * An adapter for the Shadowbox media viewer and the Yahoo! User Interface (YUI)
 * JavaScript library.
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
 * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
 * more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Shadowbox.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @author      Michael J. I. Jackson <mjijackson@gmail.com>
 * @copyright   2007 Michael J. I. Jackson
 * @license     http://www.gnu.org/licenses/lgpl-3.0.txt GNU LGPL 3.0
 * @version     SVN: $Id: shadowbox-ext.js 48 2008-01-26 09:58:25Z mjijackson $
 */

if(typeof Ext == 'undefined'){
    throw 'Unable to load Shadowbox, Ext framework not found.';
}

// create the Shadowbox object first
var Shadowbox = {};

Shadowbox.lib = function(){

    var E = Ext.lib.Event;

    return {

        /**
         * Gets the value of the style on the given element.
         *
         * @param   {HTMLElement}   el      The DOM element
         * @param   {String}        style   The name of the style (e.g. margin-top)
         * @return  {mixed}                 The value of the given style
         * @public
         */
        getStyle: function(el, style){
            return Ext.get(el).getStyle(style);
        },

        /**
         * Sets the style on the given element to the given value. May be an
         * object to specify multiple values.
         *
         * @param   {HTMLElement}   el      The DOM element
         * @param   {String/Object} style   The name of the style to set if a
         *                                  string, or an object of name =>
         *                                  value pairs
         * @param   {String}        value   The value to set the given style to
         * @return  void
         * @public
         */
        setStyle: function(el, style, value){
            Ext.get(el).setStyle(style, value);
        },

        /**
         * Gets a reference to the given element.
         *
         * @param   {String/HTMLElement}    el      The element to fetch
         * @return  {HTMLElement}                   A reference to the element
         * @public
         */
        get: function(el){
            return Ext.getDom(el);
        },

        /**
         * Removes an element from the DOM.
         *
         * @param   {HTMLElement}           el      The element to remove
         * @return  void
         * @public
         */
        remove: function(el){
            Ext.get(el).remove();
        },

        /**
         * Gets the target of the given event. The event object passed will be
         * the same object that is passed to listeners registered with
         * addEvent().
         *
         * @param   {mixed}                 e       The event object
         * @return  {HTMLElement}                   The event's target element
         * @public
         */
        getTarget: function(e){
            return E.getTarget(e);
        },

        /**
         * Prevents the event's default behavior. The event object passed will
         * be the same object that is passed to listeners registered with
         * addEvent().
         *
         * @param   {mixed}                 e       The event object
         * @return  void
         * @public
         */
        preventDefault: function(e){
            E.preventDefault(e);
        },

        /**
         * Adds an event listener to the given element. It is expected that this
         * function will be passed the event as its first argument.
         *
         * @param   {HTMLElement}   el          The DOM element to listen to
         * @param   {String}        name        The name of the event to register
         *                                      (i.e. 'click', 'scroll', etc.)
         * @param   {Function}      handler     The event handler function
         * @return  void
         * @public
         */
        addEvent: function(el, name, handler){
            E.addListener(el, name, handler);
        },

        /**
         * Removes an event listener from the given element.
         *
         * @param   {HTMLElement}   el          The DOM element to stop listening to
         * @param   {String}        name        The name of the event to stop
         *                                      listening for (i.e. 'click')
         * @param   {Function}      handler     The event handler function
         * @return  void
         * @public
         */
        removeEvent: function(el, name, handler){
            E.removeListener(el, name, handler);
        },

        /**
         * Animates numerous styles of the given element. The second parameter
         * of this function will be an object of the type that is expected by
         * YAHOO.util.Anim. See http://developer.yahoo.com/yui/docs/YAHOO.util.Anim.html
         * for more information.
         *
         * @param   {HTMLElement}   el          The DOM element to animate
         * @param   {Object}        obj         The animation attributes/parameters
         * @param   {Number}        duration    The duration of the animation
         *                                      (in seconds)
         * @param   {Function}      callback    A callback function to call when
         *                                      the animation completes
         * @return  void
         * @public
         */
        animate: function(el, obj, duration, callback){
            var anim = new Ext.lib.AnimBase(el, obj, duration, Ext.lib.Easing.easeOut);
            anim.animateX(callback);
        }

    };

}();
