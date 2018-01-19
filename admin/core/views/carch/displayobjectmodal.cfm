<cfscript>
    if(isJSON(rc.$.event('params'))){
		objectParams=deserializeJSON(rc.$.event('params'));
	} else {
        objectParams={};
    }
	$=rc.$;
	m=rc.$;
    mura=rc.$;

    url.compactDisplay="true";

    if(listLast(url.view,'.') != 'cfm'){
        if(len(url.view) && !listFind('/,\',right(url.view,1))){
            url.view=url.view & '/index.cfm';
        } else {
            url.view=url.view & 'index.cfm';
        }
    }

    url.view=ReReplace(url.view, '[^a-zA-Z0-9_\.\\/]','','all');
    url.view=replace(url.view,'../','','all');
    url.view=replace(url.view,'..\','','all');

    m=application.mura.getBean('m').init(url.siteid);

    modalFile=rc.$.siteConfig().lookupDisplayObjectFilePath(url.view);

    if(len(modalfile)){
        savecontent variable='modalbody'{
            WriteOutput('<script src="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/js/architecture.min.js?coreversion=#application.coreversion#" type="text/javascript" ></script>');
            include modalfile;
        }
    } else {
        modalbody="<h2>Error</h2><p>Error finding requested modal file. #url.view#</p>";
    }
</cfscript>
<cfoutput>
    #modalbody#
</cfoutput>
