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
<cfoutput>
<!---<h3>This is the template "#application[FUSEBOX_APPLICATION_KEY].errortemplatesPath##cfcatch.type#.cfm"</h3>--->
<h2>An Error of type "#cfcatch.type#" has occurred</h2>
<h3>#cfcatch.message#</h3>
<p>
#cfcatch.detail#
</p>
</cfoutput>
