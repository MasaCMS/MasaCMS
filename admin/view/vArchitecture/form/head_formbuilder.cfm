<cfsilent>
<cfsavecontent variable="headFormBuilder">
<cfoutput>
<link rel="stylesheet" href="#application.configBean.getContext()#/admin/css/formbuilder/templatebuilder/base.css" type="text/css" media="all" />
<link rel="stylesheet" href="#application.configBean.getContext()#/admin/css/formbuilder/minigrid/minigrid.css" type="text/css" media="all" />
<script src="#application.configBean.getContext()#/admin/js/jquery.jsonform.js" type="text/javascript" language="Javascript"></script>
<script src="#application.configBean.getContext()#/admin/js/templatebuilder/jquery.templatebuilder.0.3.js" type="text/javascript" language="Javascript"></script>
<script src="#application.configBean.getContext()#/admin/js/minigrid/jquery-ui-minigrid-0.7.js" type="text/javascript" language="Javascript"></script>
</cfoutput>
</cfsavecontent>
</cfsilent>
<cfhtmlhead text="#headFormBuilder#" >