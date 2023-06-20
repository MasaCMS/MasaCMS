<cfcomponent extends="mura.cfobject" output="false" name="catNav">
	<cfscript>
	function getCatNav(siteid,categoryid) {
		var m = application.serviceFactory.getBean('$').init(arguments.siteid);
		var navblock = [];

		var cats=m.getBean('categoryFeed')
			.addParam(
				column="parentid",
				condition="EQUALS",
				criteria='#arguments.categoryid#');

		var catit = cats.getIterator();

		while(catit.hasNext()) {
			var it = catit.next();
			var nav = m.getBean('feed');
			nav.setCategoryID(it.getCategoryID());
			var navitem = {};
			navitem.cat = it;
			navitem.nav = nav;
			navblock.append(navitem);
		}

		return navblock;
	}
	</cfscript>

	<cffunction name="renderCategoryNav">
		<cfargument name="siteid" type="any" required="yes" />
		<cfargument name="categoryid" type="any" required="yes" />
		<cfargument name="depth" type="number" default="0" />

		<cfset var categorynav = getCatNav(arguments.siteid,arguments.categoryid)>
		<cfset var renderContent = "">

		<cfif not arrayLen(categorynav)>
			<cfreturn "" />
		</cfif>

		<cfsavecontent variable="renderContent">
		<cfoutput>
		<ul class="nav flex-column">
			<cfloop from="1" to="#arrayLen(categorynav)#" index="ct">
				<cfset it = categorynav[ct].nav.getIterator() />
				<cfset cat = categorynav[ct].cat />
				<cfif it.hasNext()>
				<li class="nav-item nav-section <cfif arguments.depth gt 0>ml-5 bl-1</cfif><cfif ct eq 1> first</cfif>">
					#HTMLEditFormat(cat.getName())#
					<ul class="nav flex-column">
					<cfloop condition="#it.hasNext()#">
						<cfset item = it.next() />
						<li <cfif (it.getCurrentIndex() EQ 1)> class="nav-item first"<cfelseif (it.getCurrentIndex() EQ it.getRecordCount())> class="nav-item last"</cfif>>
							<a href="#item.getURL()#">
								#HTMLEditFormat(item.getMenuTitle())#
							</a>
						</li>
					</cfloop>
					</ul>
					#renderCategoryNav(arguments.siteid,cat.getCategoryID(),arguments.depth+1)#
				</li>
				<cfelse>
					#renderCategoryNav(arguments.siteid,cat.getCategoryID(),arguments.depth)#
				</cfif>
			</cfloop>
		</ul>
		</cfoutput>
		</cfsavecontent>

		<cfreturn renderContent>
	</cffunction>
</cfcomponent>
