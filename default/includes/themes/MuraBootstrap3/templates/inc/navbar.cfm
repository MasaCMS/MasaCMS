<cfoutput>
<header class="navbar-wrapper">
	<nav class="navbar navbar-inverse navbar-static-top" role="navigation">
		<div class="container">
			<div class="navbar-header">
				<a class="navbar-brand" href="#$.createHREF(filename='')#">#HTMLEditFormat($.siteConfig('site'))#</a>
				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
			</div><!--- /.navbar-header --->
			<div class="collapse navbar-collapse navbar-ex1-collapse">
				<div class="row">
					<div class="col-md-7">
						<cf_CacheOMatic key="dspPrimaryNav">
							#$.dspPrimaryNav(
								viewDepth=1
								, id='navPrimary'
								, class='nav navbar-nav'
								, displayHome='never'
								, closeFolders=false
								, showCurrentChildrenOnly=false
								, ulTopClass='nav navbar-nav'
								, ulNestedClass='dropdown-menu'
								, liHasKidsClass='dropdown'
								, liHasKidsAttributes=''
								, liHasKidsNestedClass='dropdown-submenu'
								, liNestedClass=''
								, aHasKidsClass='dropdown-toggle'
								, aHasKidsAttributes='role="button" data-toggle="dropdown" data-target="##"'
								, liCurrentClass=''
								, aCurrentClass=''
								, siteid=$.event('siteid')
							)#
						</cf_CacheOMatic>
						<!---
							Optional named arguments for Primary Nav are:
							displayHome="Always/Never/Conditional"
							openFolders/closeFolders="contentid,contentid" 
								(e.g. show specific sub-content in dropdown nav)
						--->
						<script>
							$(function(){
								$(#serializeJSON($.getCurrentURLArray())#).each(
									function(index, value){
										$("##navPrimary [href='" + value + "']").closest("li").addClass("active");
									}
								);
							})
						</script>
					</div>
					<div class="col-md-3 pull-right">
						<form id="searchForm" class="navbar-form navbar-right" role="search">
							<div class="input-group">
								<input type="text" name="Keywords" id="txtKeywords" class="form-control" value="#HTMLEditFormat($.event('keywords'))#" placeholder="#$.rbKey('search.search')#">
								<span class="input-group-btn">
									<button type="submit" class="btn btn-default">
										<i class="fa fa-search"></i>
									</button>
								</span>
							</div>
							<input type="hidden" name="display" value="search">
							<input type="hidden" name="newSearch" value="true">
							<input type="hidden" name="noCache" value="1">
						</form>
					</div><!--- /search --->
				</div><!--- /.row --->
			</div><!--- /.navbar-collapse --->
		</div><!--- /.container --->
	</nav><!--- /nav --->
</header>
</cfoutput>