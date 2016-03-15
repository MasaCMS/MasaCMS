<cfoutput>
<cfinclude template="inc/email_html_head.cfm">
<body <cfif $.content('eTemplateStyle') neq 'default'>class="#$.content('eTemplateStyle')#"</cfif> style="margin:0; padding:0;" bgcolor="##F0F0F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<!-- 100% background wrapper (grey background) -->
<table border="0" width="100%" height="100%" cellpadding="0" cellspacing="0" bgcolor="##F0F0F0">
  <tr>
    <td align="center" valign="top" bgcolor="##F0F0F0" style="background-color: ##F0F0F0;">

      <br>

      <!-- 600px container -->
      <table border="0" width="600" cellpadding="0" cellspacing="0" class="container">
        <tr>
          <!-- Start content (white background) -->
          <td class="content" align="left">

			<!-- Start Main Content -->
			<table width="600" border="0" cellpadding="0" cellspacing="0" class="force-row" style="width: 600px;">
			<!-- Top header section -->
			<tr>
			  	<td class="header-table">
			  		<table border="0" cellpadding="0" cellspacing="0">
					  <tr>
					    <!-- top left -->
					    <td class="grey toolbar" width="252" height="30">&nbsp;</td>
					    <td rowspan="2" class="logo">
					    	<!---
					    	<img src="#$.siteConfig('themeAssetPath')#/images/mura-logo-email.jpg" alt="Mura CMS" width="98" height="101">
					    	--->
					    </td>
					    <!-- top right -->
					    <td class="grey font toolbar" width="252"height="30" align="right"></td>
					  </tr>
					  <!-- second half of logo toolbar -->
					  <tr>
						  <td colspan="2" class="grey-dk">&nbsp;</td>
						  <td class="grey-dk">&nbsp;</td>
					  </tr>
					  <!-- Header area -->
					  <tr>
						<!--- Otherwise include the headline and subhead --->
					  	<td class="headline grey-dk" colspan="3" align="center">
					  		<h1 class="font">#$.content('eHeadline')#</h1>
					  		<h2 class="font">#$.content('eSubhead')#</h2>
					  	</td>
				
					  </tr>
					</table>
			  	</td>
			  </tr>
			<!-- /header -->
			 
			<tr>
			    <td class="cols-wrapper">
				    #$.dspBody(crumblist=false);
					)#
			    </td>
			</tr>
			
			  
			<!-- Footer -->
			<tr>
				<!-- Essentially a row -->
				<td class="cols-wrapper footer">
				    <!--[if mso]>
				      <table border="0" width="576" cellpadding="0" cellspacing="0" style="width: 576px;">
				      <tr><td width="288" style="width: 288px;" valign="top"><![endif]-->
				
				
			        <table width="288" border="0" cellpadding="0" cellspacing="0" align="left" class="force-row" style="width: 288px;">
			          <tr>
			            <td class="col" valign="top">
			              <div class="col-copy">Mura Marketing Edition is a product of Blue River Interactive Group.
	3195 Zinfandel Drive, G-21 Rancho Cordova, CA 95670</div>
			              <br>
			            </td>
			          </tr>
			        </table>
				
				    <!--[if mso]></td><td width="288" style="width: 288px;" valign="top"><![endif]-->
				
					<table width="288" border="0" cellpadding="0" cellspacing="0" align="left" class="force-row" style="width: 288px;">
			          <tr>
			            <td class="col" valign="top">
			              <div class="col-copy">&copy; Copyright #year(now())# Blue River Interactive Group. All rights reserved.</div>
			              <br>
			            </td>
			          </tr>
			        </table>
			
					<!--[if mso]></td></tr></table><![endif]-->
			
			    </td>
			</tr>
			<!-- / Footer -->
			</table>

          </td>
        </tr>
      </table><!--/600px container -->


    </td>
  </tr>
</table><!--/100% background wrapper-->

<cfinclude template="inc/email_inliner.cfm">

</body>
</html>
</cfoutput>