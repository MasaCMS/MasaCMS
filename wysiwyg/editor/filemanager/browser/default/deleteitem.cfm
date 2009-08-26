<cfif session.mura.isLoggedIn>
<cfset location=left(application.configBean.getFileDir(),len(application.configBean.getFileDir())-len(application.configBean.getAssetPath())) />

<cffile action="DELETE" file="#location##url.src#">
</cfif>
<cflocation url="#application.configBean.getContext()#/fckeditor/editor/filemanager/browser/default/frmresourceslist.cfm?reload">
