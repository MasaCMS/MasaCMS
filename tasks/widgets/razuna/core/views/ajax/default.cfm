<cfsilent>
<!---
 *
 * Copyright (C) 2005-2008 Razuna Ltd.
 *
 * This file is part of Razuna - Enterprise Digital Asset Management.
 *
 * Razuna is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Razuna is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero Public License for more details.
 *
 * You should have received a copy of the GNU Affero Public License
 * along with Razuna. If not, see <http://www.gnu.org/licenses/>.
 *
 * You may restribute this Program with a special exception to the terms
 * and conditions of version 3.0 of the AGPL as described in Razuna's
 * FLOSS exception. You should have received a copy of the FLOSS exception
 * along with Razuna. If not, see <http://www.razuna.com/licenses/>.
 *
 *
 * HISTORY:
 * Date US Format		User					Note
 * 2013/04/10			CF Mitrah		 	Initial version
 
--->
</cfsilent>
<div id="tagTree" class="jstree-classic"></div>
<div id="full_page_loader">
    <img src="#pluginPath#assets/images/ajax-loader.gif" style="position: absolute; left: 50%; top: 50%; margin-left: -32px; margin-top: -32px; display: block;"/>
</div>
<!--- Search Div --->
<div id="search_div" class="pull-right">
	<input type="text" name="search_box" id="search_box">
	<input type="button" class="btn search" name="search" value="Search" id="search">
	<input type="button" class="btn reset" name="reset" value="Reset" id="reset" onclick="$('#tagTree').jstree('refresh',-1);">
</div>
<!--- Image Details --->
<div style="display:none;" id="razunaImageDetails">
	<div id="inner-div">
	<input type="hidden" name"instances" id="instances" value="">
	<table class="describe" style="width:100%; height:auto; ">
	</table>
	</div>
</div>
