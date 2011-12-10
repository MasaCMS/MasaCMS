<cfoutput>
#Now()#
</cfoutput>
<hr>

<cfset objDOA=CreateObject("component","DBController")>

<cfdump var="#objDOA#">

<cfscript>
	//create ds for mysql
	objDOA.setDBType("mysql");
	//set vals
	sArgs = StructNew();
	sArgs.GWPassword="123";
	sArgs.DatabaseServer="localhost";
	//sArgs.DatabaseName="information_schema";
	sArgs.UserName="root";
	sArgs.Password="123";
	//call ds creation, will automatically create corresponding DB
	sReturn=objDOA.fDSCreate(argumentCollection=sArgs);
	

</cfscript>
<hr>
<cfoutput>#sReturn#</cfoutput>
