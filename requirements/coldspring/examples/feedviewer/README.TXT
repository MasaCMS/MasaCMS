############################
#  Copyright (c) 2002-2005	David Ross,	Chris Scott
#  
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#  
#       http://www.apache.org/licenses/LICENSE-2.0
#  
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#		
#			
# $Id: README.TXT,v 1.3 2005/10/11 03:46:35 wiersma Exp $
#
############################

Coldspring Example App: CFML Feedviewer.

This "feedviewer" is server-side weblog aggregator, ala FullAsAGoog.com or MarkMe.com.

A "channel" refers to weblog, and channels can exists in multiple categories. Feedviewer will retrieve and parse rss and atom feeds into entries which are inserted into a database, to be displayed.

Feedviewer was written to emphasize the decoupling of application Model and View from a controller, thus I’ve included both Mach-ii and Fusebox4 controllers, as well as a sample façade for remote calls.

Feedviewer defaults to using xml as a storage mechanism. This is to minimize any effort required in actually making it run. You should be able to test the Fusebox4 and Remote versions without touching anything. If you wish to use the mach-ii framework for a controller, you will need to have mach-ii installed. Get it at: http://www.mach-ii.com

Feedviewer uses coldspring (duh) to manage its services. The service definitions are in the services.xml file located in this directory. I tried to annotate the service definitions as heavily as possible.

Using a database:
	-I originally wrote Feedviewer to use a relational database, and if you intend to actually USE the app to aggregate weblogs, it’s highly advisable that you use a database rather than the default xml-storage mechanism. The xml-storage components were written to be very pessimistic, so all operations result in read/write to the actual file.
	-Feedviewer will work on MS SQLServer2000 (or MSDE), and MySql
	-There is ddl for each vendor in the /data/ddl/ directory that can be used to create the database
	-Then you must create a datasource in CF administrator
	-To configure the application to use the database-storage components:
		-Edit app-config.xml (for the mach-ii version) or fusebox.init.cfm (for the fusebox4 version) or application.cfm (for the remote façade version)
		-Change dstype to "rdbms"
		-Change dsn to the name of the datasource you created
		-Change dsvendor to "mysql" or "mssql" depending on which vendor’s database you used
		-Edit services.xml
			-Change any references to xml-storage gateways and DAOs to their sql counterparts. For instance, "coldspring.examples.feedviewer.model.category.xmlCategoryDAO" needs to be changed to "coldspring.examples.feedviewer.model.category.sqlCategoryDAO"
			There are only 6 definitions that need to be changed:
				-CategoryDAO
				-CategoryGateway
				-ChannelDAO
				-ChannelGateway
				-EntryDAO
				-EntryGateway


Feedviewer is shipping with two rss/atom "normalizer" implementations:
	1) Roger Benningfield's RSS normalizer
	2) java ROME library 

Right now, the services.xml file is configured to use Roger Benningfield's normalizer. I included ROME because I had difficulty getting Roger’s to normalize several popular feeds. To use ROME, you 
will have to include two jar files, rome-0.5.jar and jdom.jar, in CFMX's classpath. They are included in the javalib/ folder. After a server restart edit services.xml to point at the ROME “normalizer” (just a wrapper I wrote). There are instructions in services.xml as to how one would do that. 

The feedviewer-remote directory contains an example of how to setup a flash remoting interface to this application. It uses ColdSpring's flashUtilityService which can convert CFC instances into a java class that the Flash Remoting Gateway can convert into an Actionscript class. This same process also works for arguments passed to CFC from the flash client. In case the Actionscript class will get converted to CFC instance. You can configure the mappings in the services.xml file under the flashMappings bean. 

This application is far from complete... it only has basic functionality and was designed to demonstrate the use of coldspring to manage a service layer. In the future its feature set may become more rounded, as I do have a need for a CFML-based server side aggregator to 
replace a php-version I wrote.

If you have any questions, the best place would be the forums on coldspring's cfopen site:
	http://cfopen.org/projects/coldspring
	
Otherwise, feel free to email me at dave.ross@gmail.com

Thanks!
