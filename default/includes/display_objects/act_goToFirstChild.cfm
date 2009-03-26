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
<cfsilent>
<cfset rsPre=application.contentGateway.getKids('00000000000000000000000000000000000',request.siteid,request.contentBean.getcontentid(),'default',now(),100,request.keywords,0,request.contentBean.getsortBy(),request.contentBean.getsortDirection(),request.categoryID,request.relatedID,request.tag)>
<cfif getSite().getExtranet() eq 1 and request.r.restrict eq 1>
	<cfset rs=queryPermFilter(rsPre)/>
<cfelse>
	<cfset rs=rsPre/>
</cfif>

<cfif rs.recordcount>	
	<cfset redirect=createHREF(rs.type,rs.filename,rs.siteid,rs.contentid,"","","",application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())>	
	<cfset application.contentRenderer.redirect(redirect) />
</cfif>
</cfsilent>

	