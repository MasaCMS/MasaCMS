<cfoutput>
<header class="row-fluid">
	<nav class="navbar navbar-inverse span12">
		<div class="navbar-inner">
			<div class="#$.getMBContainerClass()#">
				<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</a>
				<a class="brand" href="#$.createHREF(filename='')#">
					<i class="icon-bullseye"></i> #HTMLEditFormat($.siteConfig('site'))#
				</a>
				
				<cfif $.currentUser().isLoggedIn()>
					<a id="logout" class="btn" href="./?doaction=logout">Logout</a>
				<cfelse>
					<form id="login" name="frmLogin" method="post" action="?nocache=1" onsubmit="return validate(this);" novalidate="novalidate" class="navbar-form pull-right">
						<input type="text" id="txtUsername" class="span2" name="username" required="true" placeholder="Username" message="#htmlEditFormat($.rbKey('user.usernamerequired'))#" />
						<input type="password" id="txtPassword" class="span2" name="password" required="true" placeholder="Password" message="#htmlEditFormat($.rbKey('user.passwordrequired'))#" />
						<input type="hidden" name="doaction" value="login" />
						<input type="hidden" name="linkServID" value="#HTMLEditFormat($.event('linkServID'))#" />
						<input type="hidden" name="returnURL" value="#HTMLEditFormat($.event('returnURL'))#" />
						<button type="submit" class="btn" value="#htmlEditFormat($.rbKey('user.login'))#">Sign in</button>
					</form>
				</cfif>
				
				<div class="nav-collapse collapse">
					<cf_CacheOMatic key="dspPrimaryNav#$.content('contentid')#">
						#$.dspPrimaryNav(
							viewDepth=1,
							id='navPrimary',
							class='nav',
							displayHome='Never',
							closeFolders=false,
							showCurrentChildrenOnly=false,
							ulTopClass='nav',
							ulNestedClass='dropdown-menu',
							liHasKidsClass='dropdown',
							liHasKidsCustomString='',
							liHasKidsNestedClass='dropdown-submenu',
							liNestedClass='',
							aHasKidsClass='dropdown-toggle',
							aHasKidsCustomString='',
							liCurrentClass='active',
							aCurrentClass=''
						)#
					</cf_cacheomatic>
					<!---
						Optional named arguments for Primary Nav are:
							displayHome="Always/Never/Conditional"
							openFolders/closeFolders="contentid,contentid" 
								(e.g. show specific sub-content in dropdown nav)
					--->
				</div><!--/.nav-collapse -->
			</div><!-- .container -->
		</div><!-- /.navbar-inner -->
	</nav><!-- /.navbar -->
</header>
</cfoutput>