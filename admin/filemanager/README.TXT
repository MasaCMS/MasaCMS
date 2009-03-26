Before using this application. you must modify the initialization
settings in the cffm.cfm file!!!

By using this code, you are agreeing to the terms of the license
agreement found in LICENSE.TXT.

Please send your feedback to rick@webworksllc.com

If you incorporate CFFM into an application, please let me know.
It will make me feel good about myself.

This file manager integrates nicely with both TinyMCE (1.45+) and 
FCKeditor 2.0+ ... 

FCKEDITOR 2.0+ :
	You must set the fck configuration options in fckconfig.js
	as follows:
  
	FCKConfig.LinkBrowserURL	= "/path/to/cffm/cffm.cfm?editorType=fck&EDITOR_RESOURCE_TYPE=file";
	FCKConfig.ImageBrowserURL	= "/path/to/cffm/cffm.cfm?editorType=fck&EDITOR_RESOURCE_TYPE=image";
	FCKConfig.FlashBrowserURL	= "/path/to/cffm/cffm.cfm?editorType=fck&EDITOR_RESOURCE_TYPE=flash";

TINYMCE 1.45+ :
	In your javascript where you implement tinymce, you need to create a callback function like this:

<script language="Javascript">
	function cffmCallback(field_name, url, type, win) 
	{
		// Do custom browser logic
		url = '/path/to/cffm/cffm.cfm?editorType=mce&EDITOR_RESOURCE_TYPE=' + type;
		x = 700; // width of window
		y = 500; // height of window
		win2 = win; // don't ask, it works.  win2 ends up being global to the page, while win is only accessible to the function.
		cffmWindow = window.open(url,"","width="+x+",height="+y+",left=20,top=20,bgcolor=white,resizable,scrollbars,menubar=0");
		if ( cffmWindow != null )
		{
			// bring the window to the front
			cffmWindow.focus();
		}	
	}
	// then modify your init() call to include the callback reference:
	tinyMCE.init({
		file_browser_callback : "cffmCallback"
	});

</script>	


Thanks!

