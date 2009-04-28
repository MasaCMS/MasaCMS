<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--
 * FCKeditor - The text editor for internet
 * Copyright (C) 2003-2006 Frederico Caldeira Knabben
 * 
 * Licensed under the terms of the GNU Lesser General Public License:
 * 		http://www.opensource.org/licenses/lgpl-license.php
 * 
 * For further information visit:
 * 		http://www.fckeditor.net/
 * 
 * "Support Open Source software. What about a donation today?"
 * 
 * File Name: frmresourceslist.html
 * 	This page shows all resources available in a folder in the File Browser.
 * 
 * File Authors:
 * 		Frederico Caldeira Knabben (fredck@fckeditor.net)
-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<link href="browser.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="js/common.js"></script>
	<script type="text/javascript" src="js/filesearchhover.js"></script>
	<script type="text/javascript">

var oListManager = new Object() ;

oListManager.Clear = function()
{
	document.body.innerHTML = '' ;
}

oListManager.GetFolderRowHtml = function( folderName, folderPath )
{
	// Build the link to view the folder.
	var sLink = '<a href="#" onclick="OpenFolder(\'' + folderPath.replace( /'/g, '\\\'') + '\');return false;">' ;

	return '<tr>' +
			'<td width="16">' +
				sLink +
				'<img alt="" src="../../../skins/mura/file_manager_images/Folder.gif" width="16" height="16" border="0"></a>' +
			'</td><td nowrap colspan="2">&nbsp;' +
				sLink + 
				folderName + 
				'</a>' +
		'</td></tr>' ;
}

oListManager.GetFileRowHtml = function( fileName, fileUrl, fileSize )
{
	// Get the file icon.
	var sIcon = oIcons.GetIcon( fileName ) ;
	
	var sExtension = fileName.substr( fileName.lastIndexOf('.') + 1 ).toLowerCase() ;
	
	// Build the link to view the folder.
	var sLink = '<a href="#" onclick="OpenFile(\'' + fileUrl.replace( /'/g, '\\\'') + '\');return false;"';
	if (sExtension == 'gif' || sExtension == 'jpg' || sExtension == 'png')
		sLink += ' onmouseover="showtrail(\'' + fileUrl.replace( /'/g, '\\\'') + '\');" onmouseout="hidetrail();"';
	sLink += '>';

	

	return '<tr>' +
			'<td width="16">' +
				sLink + 
				'<img alt="" src="../../../skins/mura/file_manager_images/icons/' + sIcon + '.gif" width="16" height="16" border="0"></a>' +
			'</td><td>&nbsp;' +
				sLink + 
				fileName + 
				'</a>' +
			'</td><td align="right" nowrap>&nbsp;' +
				fileSize + 
				' KB' +  ' ' + '<a href="./deleteitem.cfm?src=' + fileUrl +
				'" onclick="return confirm(\'delete file?\');">Delete</a>' +
		'</td></tr>' ;


}

function OpenFolder( folderPath )
{
	// Load the resources list for this folder.
	window.parent.frames['frmFolders'].LoadFolders( folderPath ) ;
}

function OpenFile( fileUrl )
{
	window.top.opener.SetUrl( fileUrl ) ;
	window.top.close() ;
	window.top.opener.focus() ;
}

function LoadResources( resourceType, folderPath )
{
	oListManager.Clear() ;
	oConnector.ResourceType = resourceType ;
	oConnector.CurrentFolder = folderPath
	oConnector.SendCommand( 'GetFoldersAndFiles', null, GetFoldersAndFilesCallBack ) ;
}

function Refresh()
{
	LoadResources( oConnector.ResourceType, oConnector.CurrentFolder ) ;
}

function GetFoldersAndFilesCallBack( fckXml )
{
	if ( oConnector.CheckError( fckXml ) != 0 )
		return ;

//	var dTimer = new Date() ;

	// Get the current folder path.
	var oNode = fckXml.SelectSingleNode( 'Connector/CurrentFolder' ) ;
	var sCurrentFolderPath	= oNode.attributes.getNamedItem('path').value ;
	var sCurrentFolderUrl	= oNode.attributes.getNamedItem('url').value ;
	
	var sHTML = '<table id="tableFiles" cellspacing="1" cellpadding="0" width="100%" border="0">' ;


	// Add the Folders.	
	var oNodes = fckXml.SelectNodes( 'Connector/Folders/Folder' ) ;
	for ( var i = 0 ; i < oNodes.length ; i++ )
	{
		var sFolderName = oNodes[i].attributes.getNamedItem('name').value ;
		sHTML += oListManager.GetFolderRowHtml( sFolderName, sCurrentFolderPath + sFolderName + "/" ) ;
	}

	// Add the Files.	
	var oNodes = fckXml.SelectNodes( 'Connector/Files/File' ) ;
	for ( var i = 0 ; i < oNodes.length ; i++ )
	{
		var sFileName = oNodes[i].attributes.getNamedItem('name').value ;
		var sFileSize = oNodes[i].attributes.getNamedItem('size').value ;
		sHTML += oListManager.GetFileRowHtml( sFileName, sCurrentFolderUrl + sFileName, sFileSize ) ;
	}

	sHTML += '</table>' ;
	sHTML += '<div id="trailimageid"></div>';
	
	document.body.innerHTML = sHTML ;

//	window.top.document.title = 'Finished processing in ' + ( ( ( new Date() ) - dTimer ) / 1000 ) + ' seconds' ;
}

window.onload = function()
{
	window.top.IsLoadedResourcesList = true ;
}
	</script>
</head>
<body class="fileManager" id="resourcesList"<cfif structKeyExists(url,"reload")> onload="Refresh();"</cfif>>
</body>
</html>
