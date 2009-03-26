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

<cfoutput>#application.contentRenderer.renderFile(listFirst(url.fileID,'.'))#</cfoutput>
<!--- <cfscript>
		i_buffer = 10000;
		byteClass = createObject("java", "java.lang.Byte"); //
		byteArray = createObject("java","java.lang.reflect.Array").newInstance(byteClass.TYPE, i_buffer);
		context = getPageContext();
		response = context.getResponse().getResponse(); 
		flvinstream = createObject("java", "java.net.URL").init("http://#cgi.server_name#/tasks/render/file?fileID=#url.fileID#").openConnection().getInputStream(); 
		flvoutstream = response.getOutputStream(); // take over control of the feed to the browser
		byteClass.Init(1);
				context.setFlushOutput(false);
		try {
			do {
				i_length = flvinstream.read(byteArray,0,i_buffer);
				if (i_length neq -1) {
					flvoutstream.write(byteArray);
					flvoutstream.flush();
				}
			} while (i_length neq -1); // keep going until there's nothing left to read.
		}
		catch(any excpt) {}
		flvoutstream.flush(); // send any remaining bytes
		response.reset(); // reset the feed to the browser
		flvoutstream.close(); // close the stream to flash
		flvinstream.close(); // close the file stream
	
</cfscript> --->