<!---Prevent any layouts from being applied--->
<cfset request.layout=false>
<!--- Minimise white space by resetting the output buffer and only returning the following cfoutput --->
<cfcontent type="text/html; charset=utf-8" reset="yes">