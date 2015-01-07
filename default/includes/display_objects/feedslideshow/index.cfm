<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without
Mura CMS under the license of your choice, provided that you follow these specific guidelines:

Your custom code

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->

<cfswitch expression="#variables.$.getJsLib()#">
<cfcase value="jquery">
	<cfoutput>
	<script src="#event.getSite().getAssetPath()#/includes/display_objects/feedslideshow/js/jquery.cycle2.min.js" type="text/javascript"></script>

	<!--- iOS6 swipe fix per: http://jquery.malsup.com/cycle2/demo/swipe.php --->
	<script>
		<!--- Conditional for iOS6. Is this more appropriate? https://gist.github.com/kTmnh/3798925/#comment-592093 --->
		if(/(iPhone|iPad|iPod)\sOS\s6/.test(navigator.userAgent)) {
	    
		    (function (window) {
		    // This library re-implements setTimeout, setInterval, clearTimeout, clearInterval for iOS6.
		    // iOS6 suffers from a bug that kills timers that are created while a page is scrolling.
		    // This library fixes that problem by recreating timers after scrolling finishes (with interval correction).
		    // This code is free to use by anyone (MIT, blabla).
		    // Original Author: rkorving@wizcorp.jp
		    var timeouts = {};
		    var intervals = {};
		    var orgSetTimeout = window.setTimeout;
		    var orgSetInterval = window.setInterval;
		    var orgClearTimeout = window.clearTimeout;
		    var orgClearInterval = window.clearInterval;
		    // To prevent errors if loaded on older IE.
		    if (!window.addEventListener) return false;
		    function createTimer(set, map, args) {
		        var id, cb = args[0],
		            repeat = (set === orgSetInterval);
		
		        function callback() {
		            if (cb) {
		                cb.apply(window, arguments);
		                if (!repeat) {
		                    delete map[id];
		                    cb = null;
		                }
		            }
		        }
		        args[0] = callback;
		        id = set.apply(window, args);
		        map[id] = {
		            args: args,
		            created: Date.now(),
		            cb: cb,
		            id: id
		        };
		        return id;
		    }
		
		    function resetTimer(set, clear, map, virtualId, correctInterval) {
		        var timer = map[virtualId];
		        if (!timer) {
		            return;
		        }
		        var repeat = (set === orgSetInterval);
		        // cleanup
		        clear(timer.id);
		        // reduce the interval (arg 1 in the args array)
		        if (!repeat) {
		            var interval = timer.args[1];
		            var reduction = Date.now() - timer.created;
		            if (reduction < 0) {
		                reduction = 0;
		            }
		            interval -= reduction;
		            if (interval < 0) {
		                interval = 0;
		            }
		            timer.args[1] = interval;
		        }
		        // recreate
		        function callback() {
		            if (timer.cb) {
		                timer.cb.apply(window, arguments);
		                if (!repeat) {
		                    delete map[virtualId];
		                    timer.cb = null;
		                }
		            }
		        }
		        timer.args[0] = callback;
		        timer.created = Date.now();
		        timer.id = set.apply(window, timer.args);
		    }
		    window.setTimeout = function () {
		        return createTimer(orgSetTimeout, timeouts, arguments);
		    };
		    window.setInterval = function () {
		        return createTimer(orgSetInterval, intervals, arguments);
		    };
		    window.clearTimeout = function (id) {
		        var timer = timeouts[id];
		        if (timer) {
		            delete timeouts[id];
		            orgClearTimeout(timer.id);
		        }
		    };
		    window.clearInterval = function (id) {
		        var timer = intervals[id];
		        if (timer) {
		            delete intervals[id];
		            orgClearInterval(timer.id);
		        }
		    };
		    //check and add listener on the top window if loaded on frameset/iframe
		    var win = window;
		    while (win.location != win.parent.location) {
		        win = win.parent;
		    }
		    win.addEventListener('scroll', function () {
		        // recreate the timers using adjusted intervals
		        // we cannot know how long the scroll-freeze lasted, so we cannot take that into account
		        var virtualId;
		        for (virtualId in timeouts) {
		            resetTimer(orgSetTimeout, orgClearTimeout, timeouts, virtualId);
		        }
		        for (virtualId in intervals) {
		            resetTimer(orgSetInterval, orgClearInterval, intervals, virtualId);
		        }
		    });
		}(window));
	    
		}
	</script>
</cfoutput>
	<cf_CacheOMatic key="#arguments.object##arguments.objectid#" nocache="#variables.$.event('nocache')#">
	<cfsilent>
	<cfparam name="hasSummary" default="true"/>
	<cfif isValid("UUID",arguments.objectID)>
		<cfset variables.feedBean = variables.$.getBean("feed").loadBy(feedID=arguments.objectID,siteID=arguments.siteID)>
  	<cfelse>
		<cfset variables.feedBean = variables.$.getBean("feed").loadBy(name=arguments.objectID,siteID=arguments.siteID)>
  	</cfif>

	<cfif not structIsEmpty(objectparams)>
		<cfset variables.feedBean.set(objectparams)>
	<cfelse>
		<cfset variables.feedBean.setImageSize("medium")>
		<cfif not arguments.hasSummary>
			<cfset variables.contentListFields=listDeleteAt(variables.feedBean.getDisplayList(),listFindNoCase(variables.feedBean.getDisplayList(),"Summary"))>
			<cfset variables.feedBean.setDisplayList(variables.contentListFields)>
		</cfif>
	</cfif>
</cfsilent>

	<cfif variables.feedBean.getIsActive()>
		<cfset variables.cssID=variables.$.createCSSid(variables.feedBean.renderName())>
      	<cfsilent>
			<cfset variables.rsPreFeed=application.feedManager.getFeed(variables.feedBean,request.tag) />
			<cfif variables.$.siteConfig('Extranet') eq 1 and variables.$.event('r').restrict eq 1>
				<cfset variables.rs=variables.$.queryPermFilter(variables.rsPreFeed)/>
			<cfelse>
				<cfset variables.rs=variables.rsPreFeed />
			</cfif>

			<cfset variables.iterator=variables.$.getBean("contentIterator")>
			<cfset variables.iterator.setQuery(variables.rs,variables.feedBean.getNextN())>


			<cfset variables.nextN=variables.$.getBean('utility').getNextN(variables.rs,variables.feedBean.getNextN(),request.StartRow)>
			<cfset variables.checkMeta=feedBean.getDisplayRatings() or variables.feedBean.getDisplayComments()>
			<cfset variables.doMeta=0 />
		  </cfsilent>
	  	<cfif variables.iterator.hasNext()>
	  	<cfoutput>
	  	<div class="svSlideshow mura-slideshow <cfif this.generalWrapperClass neq "">#this.generalWrapperClass#</cfif>" id="#variables.cssID#">
		 	<cfif variables.feedBean.getDisplayName()>
		       <#variables.$.getHeaderTag('subHead1')#>#HTMLEditFormat(variables.feedBean.renderName())#</#variables.$.getHeaderTag('subHead1')#>
			</cfif>
	  		<div class="svSlides mura-slides cycle-slideshow" data-cycle-slides="dl" data-cycle-pager=".mura-pager" data-cycle-pager-template="<li><a href='##'>{{slideNum}}</a></li>" data-cycle-swipe="true" data-cycle-pause-on-hover="true"<cfif listFindNoCase(variables.feedBean.getDisplayList(),"image")> style="#variables.$.generateListImageStyles(size=variables.feedBean.getImageSize(),height=variables.feedBean.getImageHeight(),setWidth=false)#"</cfif>>

				#variables.$.dspObject_Include(
					thefile='dsp_content_list.cfm',
					fields=variables.feedBean.getDisplayList(),
					type="Feed",
					iterator= variables.iterator,
					imageSize=variables.feedBean.getImageSize(),
					imageHeight=variables.feedBean.getImageHeight(),
					imageWidth=variables.feedBean.getImageWidth()
					)#

			</div>
			<ol class="mura-pager"></ol>
		</div>
		</cfoutput>
		<cfelse>
			<!-- Empty Collection '<cfoutput>#feedBean.getName()#</cfoutput>'  -->
		</cfif>

	<cfelse>
		<!-- Inactive Feed '<cfoutput>#feedBean.getName()#</cfoutput>' -->
	 </cfif>
	</cf_CacheOMatic>
 </cfcase>
<cfdefaultcase>
		 <!-- The Prototype js library is not currently support for the slide show functionality  -->
</cfdefaultcase>
</cfswitch>

