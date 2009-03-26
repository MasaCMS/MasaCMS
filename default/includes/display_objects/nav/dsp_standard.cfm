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

<!--- This outputs peer nav and the sub nav of the page you are on if there is any. It omits top level nav for the sake of redundancy and dead-ends if there is no content below the page you are on. Usually works best when used in conjunction with the breadcrumb nav since it changes as you get deeper into a site. --->
<cf_CacheOMatic key="standardNav#request.contentBean.getcontentID()#" nocache="#request.nocache#"><cfoutput>#dspStandardNav()#</cfoutput></cf_CacheOMatic>