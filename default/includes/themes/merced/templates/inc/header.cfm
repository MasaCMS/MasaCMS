<cfoutput>
	<div id="header" class="clearfix">
		<h1><a href="#$.createHREF(filename='')#">#HTMLEditFormat($.siteConfig('site'))#</a></h1>
		<ul class="navUtility">
			<li><a href="#$.createHREF(filename='about')#">About Us</a></li>
			<li class="last"><a href="#$.createHREF(filename='contact')#">Contact</a></li>
		</ul>
		<form action="" id="searchForm">
			<fieldset>
				<input type="search" name="Keywords" id="txtKeywords" class="text" value="Search" onfocus="this.value=(this.value=='Search') ? '' : this.value;" onblur="this.value=(this.value=='') ? 'Search' : this.value;" />
				<input type="hidden" name="display" value="search" />
				<input type="hidden" name="newSearch" value="true" />
				<input type="hidden" name="noCache" value="1" />
				<input type="submit" class="submit" value="Go" />
			</fieldset>
		</form>
		<cf_CacheOMatic key="dspPrimaryNav#$.content('contentID')#">
			#$.dspPrimaryNav(
				viewDepth="1",
				id="navPrimary",
				displayHome="Always",
				closePortals="true",
				showCurrentChildrenOnly="false"
				)#</cf_cacheomatic>
		<!--- Optional named arguments for Primary Nav are: displayHome="Always/Never/Conditional", openPortals/closePortals="contentid,contentid" (i.e. show specific sub-content in dropdown nav) --->
	</div>
</cfoutput>

