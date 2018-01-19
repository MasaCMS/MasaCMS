<?xml version="1.0" encoding="UTF-8"?>
<configuration>

<system.webServer>

<defaultDocument>
	<files>
		<remove value="index.cfm" />
		<add value="index.cfm" />
	</files>
</defaultDocument>

<staticContent>
 	<remove fileExtension=".woff" />
	<mimeMap fileExtension=".woff" mimeType="application/octet-stream" />
</staticContent>

</system.webServer>
</configuration>
