<cfif application.configBean.getValue("htmlEditorType") eq "fckeditor">
<cfoutput><script type="text/javascript" src="#application.configBean.getContext()#/wysiwyg/fckeditor.js"></script></cfoutput>
<cfelse><cfoutput><script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckeditor/adapters/jquery.js"></script></cfoutput>
</cfif>