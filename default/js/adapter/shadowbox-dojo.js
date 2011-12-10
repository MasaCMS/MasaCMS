/**
 * An adapter for the Shadowbox media viewer and the Dojo Toolkit.
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
 * @author      Peter Higgins <dante@dojotoolkit.org>
 * @copyright   2008 Peter Higgins
 * @license     AFL/BSD
 */

if(typeof dojo == 'undefined'){
    throw 'Unable to load Shadowbox, Dojo Toolkit not found.';
}

// create the Shadowbox object first
var Shadowbox = {};

Shadowbox.lib = {

    /**
     * Gets the value of the style on the given element.
     *
     * @param   {HTMLElement}   el      The DOM element
     * @param   {String}        style   The name of the style (e.g. margin-top)
     * @return  {mixed}                 The value of the given style
     * @public
     */
    getStyle: function(el, style){
        // may need additional checks
        return dojo.style(el,style);
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
        if(typeof style == 'object'){
            for(var i in style){
                dojo.style(el,i,style[i]);
            }
        }else{
            dojo.style(el,style,value);
        }
    },

    /**
     * Gets a reference to the given element.
     *
     * @param   {String/HTMLElement}    el      The element to fetch
     * @return  {HTMLElement}                   A reference to the element
     * @public
     */
    get: function(el){
        return dojo.byId(el);
    },

    /**
     * Removes an element from the DOM.
     *
     * @param   {HTMLElement}           el      The element to remove
     * @return  void
     * @public
     */
    remove: function(el){
        dojo._destroyElement(el);
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
        return e.target;
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
        e.preventDefault();
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
        var t = dojo.connect(el, name, handler);
        // we need to store a handle to later disconnect
        Shadowbox.lib._dojoEvents.push({
            el: el,
            name: name,
            handle: t
        });
    },

    _dojoEvents: [],

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
        // probably a quicker way to match this
        dojo.forEach(Shadowbox.lib._dojoEvents, function(ev, idx){
            if(ev && ev.el == el && ev.name == name){
                dojo.disconnect(ev.handle);
                Shadowbox.lib._dojoEvents[idx] = null;
            }
        });
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
        var props = {};
        for(var i in obj){
            props[i] = { end: obj[i].to };
        }
        dojo.animateProperty({
            node:       el,
            properties: props,
            duration:   duration * 1000,
            onEnd:      callback
        }).play(1);
    }

};
