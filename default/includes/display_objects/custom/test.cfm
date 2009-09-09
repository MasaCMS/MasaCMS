<cfsilent>
    <cfset content=application.contentManager.getActiveContent('', request.siteid)>
    <cfparam name="request.message" default="">
    <cfparam name="request.newFile" default=""/>
    <cfparam name="request.title" default="">
    <cfparam name="request.summary" default="">
    <cfparam name="request.body" default="">
    
    <cfif StructKeyExists(form,"doAction") and form.doaction eq "AddContent">
        
        <cfset content.setParentID(request.contentBean.getContentID())>
        <cfset content.setType("Page")>
        <cfset content.setTitle(request.title)>
        <cfset content.setSummary(request.summary)>
        <cfset content.setBody(request.body)>
        <cfset content.setApproved(0)>
        
        <!--- upload image file --->
        <cfset content.setValue('newFile',request.newFile) />
        
        <cfset application.contentManager.add(content)>
        
        <cfset request.message="Your case has been uploaded successfully. If successful your case study will appear on the website in the new few weeks.">
    
    </cfif>
</cfsilent>
<div class="upload-form">
<cfif len(request.message) eq 0>
<form action="" method="post" onsubmit="return validate(this)" enctype="multipart/form-data">
	<div class="form-field">
		<label for="title">Case study title:</label><input type="text" name="title" id="title" required="true" message="Enter a case study title" />
		<div class="clear"></div>
	</div>
	<div class="form-field">
		<label for="body">Content:</label><textarea name="body" id="body" required="true" message="Enter content for case study"></textarea>
		<div class="clear"></div>
	</div>
	<input type="hidden" name="doaction" value="AddContent"/>
	<div class="clear"></div>
	<div class="form-field">
		<label for="body">Upload a photo:</label>
		<div class="photo-upload">
			<p>This photo may be <strong>published</strong> with your case study.</p>
			<p class="inputNote">Logo must be JPG format optimised for up to 200 x 200 pixels</p>
			<input type="file" id="txtNewFile" name="newFile" validate="regex" regex="(.+)(\.)(jpg|JPG)" message="Your logo must be a .JPG" />
		</div>
		<div class="clear"></div>
	</div>
    <div id="upload-btn"><input type="submit" /></div>
</form>
<cfelse>
<p><cfoutput>#request.message#</cfoutput></p>
</cfif>
</div>