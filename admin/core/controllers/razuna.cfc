/*
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
*/ 
 
component persistent="false" accessors="true" output="false" extends="controller" {

	// *********************************  PAGES  *******************************************
	
	public any function before(required struct rc) {
		if (not variables.permUtility.getModulePerm('00000000000000000000000000000000000',arguments.rc.siteid)){
			secure(arguments.rc);
		}
		
		rc.razunaSettings = rc.$.getBean('razunaSettings').loadBy(siteID=session.siteid);
		rc.razunaAPI = rc.$.getBean('razunaAPI').set(rc.razunaSettings.getHostName(), rc.razunaSettings.getApiKey(), rc.razunaSettings.getHostID());
	}
	
	public any function default(required rc) {
		rc.qFolders = rc.razunaAPI.getFolders();
	}
	
	public any function getnodes(required rc) {
		rc.qFolders = rc.razunaAPI.getFolders(rc.folderid);
		rc.qAssets = rc.razunaAPI.getassets(rc.folderid);
	}

	function settingsQueryToStruct(q){
		structSettings = structnew();
		for(i=1; i<=q.recordcount; i++ ){
            structSettings [q["name"][i]] = q["settingValue"][i];			 
		}
		return structSettings;
	}
	
	function structkeydefault(struct,keyName,defaultVal){
		if(structkeyExists(arguments.struct,arguments.keyName))
			return arguments.struct[arguments.keyName];
		else
			return arguments.defaultVal;
	}

}