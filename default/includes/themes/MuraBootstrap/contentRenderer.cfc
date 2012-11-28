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

<cfcomponent extends="mura.cfobject">

	<!--- Add theme-specific methods here --->
	<cffunction name="dspCarouselByFeedName" output="false">
		<cfargument name="feedName" type="string" default="Slideshow" />
		<cfargument name="showCaption" type="boolean" default="true" />
		<cfargument name="cssID" type="string" default="myCarousel" />
		<cfargument name="width" type="numeric" default="1280" />
		<cfargument name="height" type="numeric" default="600" />
		<cfargument name="interval" type="any" default="2000" />
		<cfset var local = {} />
		<cfsavecontent variable="local.str"><cfoutput>
			<!--- BEGIN: Bootstrap Carousel --->
			<!--- IMPORTANT: This will only output items that have associated images --->
			<cfset local.feed = variables.$.getBean('feed').loadBy(name=arguments.feedName)>
			<cfset local.iterator = local.feed.getIterator()>
			<cfif local.iterator.hasNext()>
				<div id="#arguments.cssID#" class="carousel slide" data-interval="false">
					<!--- Carousel items --->
					<div class="carousel-inner">
						<cfset local.idx = 0>
						<cfloop condition="local.iterator.hasNext()">
							<cfset local.item=iterator.next()>
							<cfif ListFindNoCase('jpg,jpeg,gif,png', ListLast(local.item.getImageURL(), '.'))>
								<cfset local.idx++>
								<div class="item<cfif local.idx eq 1> active</cfif>">
									<img src="#local.item.getImageURL(width=Val(arguments.width),height=Val(arguments.height))#" alt="#HTMLEditFormat(local.item.getTitle())#">
									<cfif arguments.showCaption>
										<div class="carousel-caption">
											<h4><a href="#local.item.getURL()#">#HTMLEditFormat(local.item.getTitle())#</a></h4>
											#local.item.getSummary()#
										</div>
									</cfif>
								</div>
							</cfif>
						</cfloop>
					</div>
					<cfif local.idx>
						<!--- Carousel nav --->
						<cfif local.idx gt 1>
							<a class="left carousel-control" href="###arguments.cssID#" data-slide="prev">&lsaquo;</a>
							<a class="right carousel-control" href="###arguments.cssID#" data-slide="next">&rsaquo;</a>
						</cfif>
					<cfelse>
						<div class="alert alert-info alert-block">
							<button type="button" class="close" data-dismiss="alert"><i class="icon-remove"></i></button>
							<h4>Oh snap!</h4>
							Your feed has no items <em>with images</em>.
						</div>
					</cfif>
				</div>
			<cfelse>
				<div class="alert alert-info alert-block">
					<button type="button" class="close" data-dismiss="alert"><i class="icon-remove"></i></button>
					<h4>Heads up!</h4>
					Your feed has no items.
				</div>
			</cfif>
			<!--- // END: Bootstrap Carousel --->
		</cfoutput></cfsavecontent>
		<cfreturn local.str />
	</cffunction>

	<cffunction name="getMBUseFluid" output="false">
		<cfscript>
			var local = {};

			try {
				local.useFluid = YesNoFormat(variables.$.siteConfig('mbUseFluid'));
			} catch(any e) {
				return false;
			};

			if ( local.useFluid ) {
				return true;
			} else {
				return false;
			};
		</cfscript>
	</cffunction>

	<cffunction name="getMBContainerClass" output="false">
		<cfreturn IIF(getMBUseFluid(), DE('container-fluid'), DE('container'))>
	</cffunction>

	<cffunction name="getMBRowClass" output="false">
		<cfreturn IIF(getMBUseFluid(), DE('row-fluid'), DE('row'))>
	</cffunction>

</cfcomponent>