<cfoutput>
	<cfif !$.content().getIsHome()>

		<!--- Page Title --->
			<#$.getHeaderTag('headline')# class="mura-page-title pageTitle">
				#esapiEncode('html', $.content('title'))#
			</#$.getHeaderTag('headline')#>
		<!--- /Page Title --->

		<!--- Release Date, Credits, etc. --->
		<cfset commentCount = Val($.content().getStats().getComments())>
		<cfset itCategories = $.content().getCategoriesIterator()>
		<cfif
			IsDate($.setDynamicContent($.content('releasedate')))
			or Len($.setDynamicContent($.content('credits')))
			or ListLen($.content().getTags())
			or itCategories.hasNext()
			or commentCount>
			<ul class="list-inline">

				<!--- Content Release Date --->
					<cfif IsDate($.setDynamicContent($.content('releasedate')))>
						<li class="mura-credits">
							<i class="fa fa-clock-o"></i> #LSDateFormat($.setDynamicContent($.content('releasedate')))#
						</li>
					</cfif>
				<!--- /Content Release Date --->

				<!--- Comments --->
					<cfif commentCount gt 0>
						<li class="mura-comment-count">
							<i class="fa fa-comments"></i> #commentCount# Comment<cfif commentCount gt 1>s</cfif>
						</li>
					</cfif>
				<!--- /Comments --->

				<!--- Tags --->
					<cfif ListLen($.content().getTags())>
						<li class="mura-tags">
							<i class="fa fa-tags"></i>
							<cfloop from="1" to="#ListLen($.content().getTags())#" index="t">
							#esapiEncode('html', trim(ListGetAt($.content().getTags(), t)))#<cfif t neq ListLen($.content().getTags())>, </cfif>
							</cfloop>
						</li>
					</cfif>
				<!--- /Tags --->

				<!--- Categories --->
					<cfif itCategories.hasNext()>
						<li class="mura-categories">
							<i class="fa fa-folder-open"></i>
							<cfloop condition="itCategories.hasNext()">
								<cfset categoryItem = itCategories.next()>
								#HTMLEditFormat(categoryItem.getName())#</a><cfif itCategories.hasNext()>, </cfif>
							</cfloop>
						</li>
					</cfif>
				<!--- /Categories --->

				<!--- Credits --->
					<cfif Len($.setDynamicContent($.content('credits')))>
						<li class="mura-credits">
							<i class="fa fa-user"></i> #esapiEncode('html', $.setDynamicContent($.content('credits')))#
						</li>
					</cfif>
				<!--- /Credits --->
			</ul>
		</cfif>

	</cfif>


	<!--- Primary Associated Image --->
		<cfif $.content().hasImage(usePlaceholder=false)>
			<cfscript>
				img = $.content().getImageURL(
					size = 'carouselimage' // small, medium, large, custom, or any other pre-defined image size
					,complete = false // set to true to include the entire URL, not just the absolute path (default)
				);
			</cfscript>
			<div class="mura-asset">
				<a class="mura-meta-image-link" href="#$.content().getImageURL()#" title="#esapiEncode('html_attr', $.content('title'))#" rel="shadowbox[body]">
					<img class-"mura-meta-image carouselimage" src="#img#" alt="#esapiEncode('html_attr', $.content('title'))#">
				</a>
			</div>
		</cfif>
	<!--- /Primary Associated Image --->

	<!--- Body --->
		<div class="mura-body">
			#$.renderEditableAttribute(attribute="body",type="htmlEditor")#
		</div>
	<!--- /Body --->

</cfoutput>
