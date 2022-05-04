<cfsilent>
	<cfparam name="objectParams.infolist" default="">
	<cfset objectParams.render="server">
</cfsilent>
<cfoutput>
	<div class="masa-module-info">
		<ul class="list-unstyled">
		<cfif listContains(objectParams.infolist, 'author')>
			<li><span class="badge badge-primary">Author</span><span class="badge">#m.getBean('user').loadBy(userid=m.content('lastupdatebyid')).getFullName()#</span></li>
		</cfif>
		<cfif listContains(objectParams.infolist, 'credits')>
			<li><span class="badge badge-primary">Credits</span><span class="badge">#m.content('credits')#</span></li>
		</cfif>
		<cfif listContains(objectParams.infolist, 'releasedate') and isDate(m.content('releasedate'))>
			<li><span class="badge badge-primary">Released</span><span class="badge">#m.content('releasedate')#</span></li>
		</cfif>
		<cfif listContains(objectParams.infolist, 'created')>
			<li><span class="badge badge-primary">Created</span><span class="badge">#lsdateformat(m.content('created'))#</span></li>
		</cfif>
		<cfif listContains(objectParams.infolist, 'lastupdate')>
			<li><span class="badge badge-primary">Last Update</span><span class="badge">#lsdateformat(m.content('lastupdate'))#</span></li>
		</cfif>
		</ul>
	</div>
</cfoutput>