/*  This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without
Mura CMS under the license of your choice, provided that you follow these specific guidelines:

Your custom code

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

	/admin/
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
*/
component extends="mura.cfobject" output="false" {

	public function init(required any configBean, required any userGateway, required any contentGateway, required any sessionTrackingGateway, required any emailGateway, required any settingsManager, required any raterManager, required any feedGateway) output=false {
		variables.configBean=arguments.configBean;
		variables.userGateway=arguments.userGateway;
		variables.contentGateway=arguments.contentGateway;
		variables.sessionTrackingGateway=arguments.sessionTrackingGateway;
		variables.emailGateway=arguments.emailGateway;
		variables.settingsManager=arguments.settingsManager;
		variables.raterManager=arguments.raterManager;
		variables.feedGateway=arguments.feedGateway;
		return this;
	}

	public function getSiteSessionCount(required string siteID="", required boolean membersOnly="false", required string visitorStatus="false", required numeric span="15", required string spanType="n") output=false {
		return variables.sessionTrackingGateway.getSiteSessionCount(arguments.siteID,arguments.membersOnly,arguments.visitorStatus,arguments.span,arguments.spanType);
	}

	public function getCreatedMembers(required string siteID="", required string startDate="", required string stopDate="") output=false {
		return variables.userGateway.getCreatedMembers(arguments.siteID,arguments.startDate,arguments.stopDate);
	}

	public function getTotalMembers(required string siteID="") output=false {
		return variables.userGateway.getTotalMembers(arguments.siteID);
	}

	public function getTotalAdministrators(required string siteID="") output=false {
		return variables.userGateway.getTotalAdministrators(arguments.siteID);
	}

	public function getTopContent(required string siteID="", required numeric limit="10", required boolean membersOnly="false", required string visitorStatus="false", required string startDate="", required string stopDate="", required boolean excludeHome="false") output=false {
		return variables.sessionTrackingGateway.getTopContent(arguments.siteID,arguments.limit,arguments.membersOnly,arguments.visitorStatus,arguments.startDate,arguments.stopDate,arguments.excludeHome);
	}

	public function getSiteSessions(required string siteID="", required String contentID="", required boolean membersOnly="false", required string visitorStatus="false", required numeric span="15", required string spanType="n") output=false {
		return variables.sessionTrackingGateway.getSiteSessions(arguments.siteID,arguments.contentID,arguments.membersOnly,arguments.visitorStatus,arguments.span,arguments.spanType);
	}

	public function getSessionHistory(string urlToken="", string siteID="") {
		return variables.sessionTrackingGateway.getSessionHistory(arguments.urlToken,arguments.siteID);
	}

	public function getTopKeywords(required string siteID="", required numeric limit="10", required boolean membersOnly="false", required string visitorStatus="false", required string startDate="", required string stopDate="") output=false {
		return variables.sessionTrackingGateway.getTopKeywords(arguments.siteID,arguments.limit,arguments.membersOnly,arguments.visitorStatus,arguments.startDate,arguments.stopDate);
	}

	public function getTotalKeywords(required string siteID="", required boolean membersOnly="false", required string visitorStatus="false", required string startDate="", required string stopDate="") output=false {
		return variables.sessionTrackingGateway.getTotalKeywords(arguments.siteID,arguments.membersOnly,arguments.visitorStatus,arguments.startDate,arguments.stopDate);
	}

	public function getTotalHits(required string siteID="", required boolean membersOnly="false", required string visitorStatus="false", required string startDate="", required string stopDate="") output=false {
		return variables.sessionTrackingGateway.getTotalHits(arguments.siteID,arguments.membersOnly,arguments.visitorStatus,arguments.startDate,arguments.stopDate);
	}

	public function getTotalSessions(required string siteID="", required boolean membersOnly="false", required string visitorStatus="false", required string startDate="", required string stopDate="") output=false {
		return variables.sessionTrackingGateway.getTotalSessions(arguments.siteID,arguments.membersOnly,arguments.visitorStatus,arguments.startDate,arguments.stopDate);
	}

	public function getTopReferers(required string siteID="", required numeric limit="10", required string startDate="", required string stopDate="") output=false {
		return variables.sessionTrackingGateway.getTopReferers(arguments.siteID,arguments.limit,arguments.startDate,arguments.stopDate);
	}

	public function getTotalReferers(required string siteID="", required string startDate="", required string stopDate="") output=false {
		return variables.sessionTrackingGateway.getTotalReferers(arguments.siteID,arguments.startDate,arguments.stopDate);
	}

	public function getcontentTypeCount(required string siteID="", required string type="") output=false {
		return variables.contentGateway.getTypeCount(arguments.siteID,arguments.type);
	}

	public function getRecentUpdates(required string siteID="", required numeric limit="5", required string startDate="", required string stopDate="") output=false {
		return variables.contentGateway.getRecentUpdates(arguments.siteID,arguments.limit,arguments.startdate,arguments.stopdate);
	}

	public function getRecentFormActivity(required string siteID="", required numeric limit="5") output=false {
		return variables.contentGateway.getRecentFormActivity(arguments.siteID,arguments.limit);
	}

	public function getDraftList(string siteID, required string userID="#listFirst(session.mura.isLoggedIn,'^')#", required numeric limit="100000000", required string startDate="", required string stopDate="", required string sortBy="lastUpdate", required string sortDirection="desc") output=false {
		return variables.contentGateway.getDraftList(arguments.siteID,arguments.userID,arguments.limit,arguments.startDate,arguments.stopDate,arguments.sortBy,arguments.sortDirection);
	}

	public function getTopRated(required string siteID="", required numeric threshold="1", required numeric limit="0", required string startDate="", required string stopDate="") output=true {
		return variables.raterManager.getTopRated(arguments.siteID,arguments.threshold,arguments.limit,arguments.startDate,arguments.stopDate);
	}

	public function getFeedTypeCount(required string siteID="", required string type="") output=false {
		return variables.feedGateway.getTypeCount(arguments.siteID,arguments.type);
	}

	public function getSessionSearch(required array params, required string siteid="", required boolean membersOnly="false", required string visitorStatus="false", required string startDate="", required string stopDate="") output=false {
		return variables.sessionTrackingGateway.getSessionSearch(arguments.params,arguments.siteID,arguments.membersOnly,arguments.visitorStatus,arguments.startDate,arguments.stopDate);
	}

	public function getEmailActivity(required string siteid="", required numeric limit="5", required string startDate="", required string stopDate="") output=false {
		return variables.emailGateway.getSessionSearch(arguments.siteID,arguments.limit,arguments.startDate,arguments.stopDate);
	}

	public function getTimeSpan(firstRequest, lastRequest, required format="#session.dateKeyFormat#") output=false {
		var theStart=arguments.firstRequest;
		var days = 0;
		var hours = 0;
		var minutes = 0;
		var seconds = 0;
		var returnStr = "";
		if ( arguments.format == session.dateKeyFormat ) {
			hours = dateDiff("h",theStart,arguments.lastRequest);
			theStart = dateAdd("h",hours,theStart);
			minutes = dateDiff("n",theStart,arguments.lastRequest);
			theStart = dateAdd("n",minutes,theStart);
			seconds = dateDiff("s",theStart,arguments.lastRequest);
			if ( hours < 10 ) {
				hours="0#hours#";
			}
			if ( minutes < 10 ) {
				minutes="0#minutes#";
			}
			if ( seconds < 10 ) {
				seconds="0#seconds#";
			}
			return "#hours#:#minutes#:#seconds#";
		} else {
			days = dateDiff("d",theStart,arguments.lastRequest);
			theStart = dateAdd("d",days,theStart);
			hours = dateDiff("h",theStart,arguments.lastRequest);
			theStart = dateAdd("h",hours,theStart);
			minutes = dateDiff("n",theStart,arguments.lastRequest);
			if ( days ) {
				returnStr = days & " days";
			}
			if ( hours ) {
				if ( returnStr != "" ) {
					returnStr = returnStr & ", ";
				}
				returnStr = returnStr & hours & " hours";
			}
			if ( minutes ) {
				if ( returnStr != "" ) {
					returnStr = returnStr & ", ";
				}
				returnStr = returnStr & minutes & " minutes";
			}
			return returnStr;
		}
	}

	public function getLastSessionDate(urlToken, originalUrlToken, beforeDate) {
		var rs = "";
		var qs = getQueryService(name='rs',readOnly=true);

		qs.addParam(name='urlToken', cfsqltype="cf_sql_varchar", value=arguments.urlToken );
		qs.addParam(name='originalUrlToken', cfsqltype="cf_sql_varchar", value=arguments.originalUrlToken );
		qs.addParam(name="entered",cfsqltype="cf_sql_timestamp", value=LSDateFormat(arguments.beforeDate,'mm/dd/yyyy'));

		rs=qs.execute(sql="select max(entered) as lastRequest
				from tsessiontracking
				where originalUrlToken= :originalUrlToken
				and urlToken <> :urlToken
				and entered < :entered").getResult();


		if ( isDate(rs.lastRequest) ) {
			return rs.lastRequest;
		} else {
			return "Not Available";
		}
	}

	public function getUserFromSessionQuery(rsSession) {
		var rs = "";
		var qs = new Query();
		qs.setDbType('query');
		qs.setAttributes(rsSession=arguments.rsSession);
		rs=qs.execute(sql="select fname,lname from rsSession where userID > ''").getResult();

		if ( rs.recordcount ) {
			return rs.fname & " " & rs.lname;
		} else {
			return "Anonymous";
		}
	}

	public function getUserAgentFromSessionQuery(rsSession) {
		var rs = "";
		var qs = new Query();
		qs.setDbType('query');
		qs.setAttributes(rsSession=arguments.rsSession);
		rs=qs.execute(sql="select user_agent from rsSession where user_agent > ''").getResult();

		if ( rs.recordcount ) {
			return rs.user_agent;
		} else {
			return "unknown";
		}
	}

}
