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

<cfoutput>
<html>
<head>
<title>Message from #rsEmail.site#</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body text="##000000" link="##000000" vlink="##000000" alink="##000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
#bodyHtml#
<p><cfoutput>To unsubscribe, <a href="#unsubscribe#">please click here</a>. To forward, <a href="#forward#">please click here</a>.</p>
#trackOpen#</cfoutput>
</body>
</html></cfoutput>