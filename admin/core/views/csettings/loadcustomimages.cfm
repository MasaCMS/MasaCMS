
	<cfset request.layout=false>
	<cfif len(rc.sizeid)>
		<cfswitch expression="#rc.imageAction#">
			<cfcase value="delete">
				 <cfset application.serviceFactory.getBean('imageSize').loadBy(sizeid=rc.sizeid).delete()>
			</cfcase>
			<cfcase value="save">
				 <cfset application.serviceFactory.getBean('imageSize').loadBy(sizeid=rc.sizeid).set(rc).save()>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfset images=application.settingsManager.getSite(rc.siteid).getCustomImageSizeIterator()>

<cfoutput>
<!---
SizeID:#rc.sizeid#<br/>
imageAction:#rc.imageAction#<br/>
name:#rc.name#<br/>
height:#rc.height#<br/>
width:#rc.width#<br/>
--->
<cfif images.hasNext()>
<table class="mura-table-grid">
<tr>
<th >Name</th>
<th>Height</th>
<th>Width</th>
<th class="actions"></th>
</tr>
<cfloop condition="images.hasNext()">
<cfset image=images.next()>
<tr>
<td class="var-width">#esapiEncode('html',image.getName())#</td>
<td>#esapiEncode('html',image.getHeight())#</td>
<td>#esapiEncode('html',image.getWidth())#</td>
<td class="actions"><ul>
	<li class="edit"><a href="##" text="Edit" onclick="return openCustomImageSize('#image.getSizeID()#','#esapiEncode('javascript',image.getSiteID())#');"><i class="icon-pencil"></i></a></li>
</ul></td>
</tr>
</cfloop>
</table>
<cfelse>
	<p class="alert">There are currently no custom image sizes.</p>
</cfif>
</cfoutput>