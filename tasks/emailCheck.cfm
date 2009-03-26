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

<cfscript>
// config
sMailServer = "";
sUsername = "";
sPassword = "";
sSubject = "";
sAddyTo = "";
sAddyFrom = "";
oProps = createObject("java", "java.util.Properties").init();
oProps.put("javax.mail.smtp.host", sMailServer);
oRecipientType = createObject("java", "javax.mail.Message$RecipientType");
oMailSession = createObject("java", "javax.mail.Session").getInstance(oProps);
oMimeMessage = createObject("java", "javax.mail.internet.MimeMessage").init(oMailSession);
oAddressFrom = createObject("java", "javax.mail.internet.InternetAddress").init(sAddyFrom);
oAddressTo = createObject("Java","javax.mail.internet.InternetAddress").init(sAddyTo);
oMimeMessage.setFrom(oAddressFrom);
oMimeMessage.addRecipient(oRecipientType.TO, oAddressTo);
oMimeMessage.setSubject(sSubject);
oMimeMessage.setText("Email Test.");
oTransport = oMailSession.getTransport("smtp");
oTransport.connect(sMailServer, sUsername, sPassword);
oTransport.send(oMimeMessage);
oTransport.close();
</cfscript>
<cfcontent reset="true" />
<cfabort />