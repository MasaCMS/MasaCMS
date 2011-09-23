<cfif application.configBean.getValue("htmlEditorType") eq "fckeditor">
<cfoutput><script type="text/javascript" src="#$.globalConfig('context')#/wysiwyg/fckeditor.js"></script></cfoutput>
<cfelse><cfoutput><script type="text/javascript" src="#$.globalConfig('context')#/tasks/widgets/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="#$.globalConfig('context')#/tasks/widgets/ckeditor/adapters/jquery.js"></script></cfoutput>
</cfif>