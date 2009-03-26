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

<cfoutput><form name="searchFrm" id="svSearchForm"  method="get">
<h3><label for="search">Search</label></h3>
<input id="search" class="text" name="keywords" type="text" value="#HTMLEditFormat(request.keywords)#" alt="search"/><input name="newSearch" value="true" type="hidden"/><input type="hidden" name="display" value="search"/><input type="hidden" name="nocache" value="1"/><input type="submit" value="Go" class="submit"/>
</form>
</cfoutput>