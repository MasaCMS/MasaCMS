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

<cfparam name="error.diagnostics" default="">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Error</title>
<link href="/default/css/default.css" rel="stylesheet" type="text/css" />
</head>

<body>
 
	<h2>Error</h2>
	<h3>We're sorry, but we've encountered an error.</h3>
	<p><a href="javascript: history.go(-1);" class="highlight">Cick here to return to the previous page.</a></p><p></p>
	<p><cfoutput>#error.diagnostics#</cfoutput></p>

</body>
</html>