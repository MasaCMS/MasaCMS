<?xml version="1.0" encoding="UTF-8"?>

<!-- this file can be deleted if you're not planning on using URL rewriting with IIS 7. -->
<!-- you can add your own files and folders that should be excluded from URL rewriting by adding them to the "pattern" below. -->

<!-- To remove the Mura siteID directory and index.cfm from urls you must also set both siteIDInURLS and indexFileInURLs to 0 in your /config/setting.ini.cfm and reload Mura.-->

<!-- SET ENABLED TO TRUE BELOW TO TURN ON THE URL REWRITING RULES -->
<configuration>
       <system.webServer>
               <rewrite>
                       <rules>
                               <rule name="Mura Main Rewrite Rule" stopProcessing="true" enabled="false">
                                       <match url="^(.*)$" ignoreCase="true" />
                                       <conditions logicalGrouping="MatchAll">
                                       <add input="{REQUEST_FILENAME}" matchType="IsFile" negate="true" />
                                       <add input="{REQUEST_FILENAME}" matchType="IsDirectory" negate="true" />
                                    </conditions>
                                    <action type="Rewrite" url="/index.cfm/{R:1}" />
                               </rule>
                       </rules>
               </rewrite>
       </system.webServer>
</configuration>