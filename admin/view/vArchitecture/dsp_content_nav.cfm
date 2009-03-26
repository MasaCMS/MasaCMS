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
<div id="newContentMenu" onMouseOut="hideMenu('newContentMenu');" class="addNew">
  <ul>
    <li id="newZoom"><a href="" id="newZoomLink" onMouseOver="keepMenu('newContentMenu');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.zoom")#</a></li>
    <li id="newCopy"><a href="" id="newCopyLink" onMouseOver="keepMenu('newContentMenu');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.copy")#</a></li>
	<li id="newPaste"><a href="" id="newPasteLink" onMouseOver="keepMenu('newContentMenu');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.paste")#</a></li>
	<li id="newPage"><a href="" id="newPageLink" onMouseOver="keepMenu('newContentMenu');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.addpage")#</a></li>
    <li id="newLink"><a href="" id="newLinkLink" onMouseOver="keepMenu('newContentMenu');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.addlink")#</a></li>
    <li id="newFile"><a href="" id="newFileLink" onMouseOver="keepMenu('newContentMenu');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.addfile")#</a></li>
   <!---  <li id="newFileMulti"><a href="" id="newFileMultiLink" onMouseOver="keepMenu('newContentMenu');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.addmultifiles")#</a></li> --->
	<li id="newPortal"><a href="" id="newPortalLink" onMouseOver="keepMenu('newContentMenu');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.addportal")#</a></li>
    <li id="newCalendar"><a href="" id="newCalendarLink" onMouseOver="keepMenu('newContentMenu');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.addcalendar")#</a></li>
    <li id="newGallery"><a href="" id="newGalleryLink" onMouseOver="keepMenu('newContentMenu');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.addgallery")#</a></li>
    <li id="newGalleryItem"><a href="" id="newGalleryItemLink" onMouseOver="keepMenu('newContentMenu');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.addgalleryitem")#</a></li>
	<li id="newGalleryItemMulti"><a href="" id="newGalleryItemMultiLink" onMouseOver="keepMenu('newContentMenu');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.addmultiitems")#</a></li>
  </ul>
</div>
</cfoutput>
