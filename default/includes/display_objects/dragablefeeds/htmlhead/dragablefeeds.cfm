<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfset rbFactory=getSite().getRBFactory()>
<cfoutput>
<script src="#application.configBean.getContext()#/#application.settingsmanager.getSite(request.siteid).getDisplayPoolID()#/includes/display_objects/dragablefeeds/js/dragablefeeds.js" type="text/javascript"></script>
<script>
var feeditems='#JSStringFormat(rbFactory.getKey("dragablefeeds.items"))#';
var feedsource='#JSStringFormat(rbFactory.getKey("dragablefeeds.source"))#';
var feedsave='#JSStringFormat(rbFactory.getKey("dragablefeeds.save"))#';
</script>
<link rel="stylesheet" href="#application.configBean.getContext()#/#application.settingsmanager.getSite(request.siteid).getDisplayPoolID()#/includes/display_objects/dragablefeeds/css/dragablefeeds.css" type="text/css" media="all" />
<!--[if lt IE 7]><link rel="stylesheet" href="#application.configBean.getContext()#/#application.settingsmanager.getSite(request.siteid).getDisplayPoolID()#/includes/display_objects/dragablefeeds/css/dragablefeeds-ie.css" type="text/css" media="all" /><![endif]-->
</cfoutput>