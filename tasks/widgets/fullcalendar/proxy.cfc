component output=false {

	remote string function getFullCalendarItems(calendarid, siteid, start, end, categoryid, tag) returnFormat='plain' {

		// validate required args
		var reqArgs = ['calendarid','siteid'];
		for ( arg in reqArgs ) {
			if ( !StructKeyExists(arguments, arg) || !Len(arguments[arg]) ) {
				return 'Please provide a <strong>#arg#</strong>.';
			}
		}

		var $ = application.serviceFactory.getBean('$').init(arguments.siteid);
		var calendarUtility = $.getCalendarUtility();

		return 
			calendarUtility.fullCalendarFormat(
				calendarUtility.getCalendarItems(argumentCollection=arguments)
			);
	}

}