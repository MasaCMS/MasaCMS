
component extends="mura.bean.beanORM" entityname="razunasettings" table="trazunasettings" hint="This provides razuna api setting persistence"{

	property name="settingsID" fieldtype="id";
	property name="site" fieldtype="one-to-one" cfc="site" fkcolumn="siteID";
	property name="hostName" required=true;
	property name="hostID" validate="numeric" required=true;
	property name="apiKey" required=true;
	property name="servertype" required=true inlist="cloud,local" default="local";
	property name="damPath" length="250";

	function save(){		
		var razunaEnabled = application.configBean.getValue('razuna');
		if(razunaEnabled == "true"){
			// Create deprecation warning
			var pluginManager=getBean('pluginManager');
			var $ = getBean('$').init();
			$.event().setValue("deprecationType","Razuna");		
			pluginManager.announceEvent(eventToAnnounce='LogDeprecation',currentEventObject=$);
		}

		super.save();
	}
}