<cfoutput>
	<div id="header" class="clearfix">
		<h1><a href="#application.configBean.getContext()#/">#renderer.getSite().getSite()#</a></h1>
		<form action="#application.configBean.getIndexFile()#" id="searchForm">
			<div>
				<!--- <label for="txtKeywords">Search:</label> --->
				<input type="text" name="keywords" id="txtKeywords" class="text" value="Enter Search Term" onclick="this.value='';" onblur="if(this.value==''){this.value='Enter Search Term';}" />
				<input type="hidden" name="display" value="search" />
				<input type="hidden" name="newSearch" value="true" />
				<input type="hidden" name="noCache" value="1" />
				<input type="submit" value="Search" class="submit" />
			</div>
		</form>
		<cf_CacheOMatic key="dspPrimaryNav#request.contentBean.getcontentID()#">#renderer.dspPrimaryNav(viewDepth="2",id="navPrimary",displayHome="Always",closePortals="true")#</cf_cacheomatic>
		<!--- Optional named arguments for Primary Nav are: displayHome="Always/Never/Conditional", openPortals/closePortals="contentid,contentid" (i.e. show specific sub-content in dropdown nav) --->
		<cfif arraylen(request.crumbdata) gt 1><p id="sectionTitle">#request.crumbdata[evaluate(arrayLen(request.crumbdata)-1)].menutitle#</p></cfif>
	</div>
</cfoutput>