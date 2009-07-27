/*
	DynamicToolbar FCKEditor plugin, v1.1 (080810)
	Copyright (c) 2008, Gonzalo Perez de la Ossa (http://dense13.com/)
	License: http://www.opensource.org/licenses/mit-license.php
*/

// Set the dynamicToolbar_buttons configuration in your HTML file,
// using something like:
//   >> oEditor.Config['DynamicToolbar_buttons'] = "Bold,Italic";
//
// Use the following symbols to split the toolbar:
//  , -> consecutive buttons
//  + => separate block (in same line, if it fits)
//  - => add a separator (note: also use comma before/after)
//  | => start a new row
//
// For example: Bold,Italic,-,RemoveFormat+Link,Unlink|SelectAll
//
// Then set the dynamic toolbar with:
//   >> oEditor.ToolbarSet = 'DynamicToolbar';

FCKConfig.ToolbarSets["DynamicToolbar"] = [];

if (FCKConfig['DynamicToolbar_buttons']) {
	var lines, blocks;
	lines = FCKConfig['DynamicToolbar_buttons'].split('|');

	for (var i=0, l=lines.length ; i<l ; i++) {
		// Process each line
		blocks = lines[i].split('+');
		for (var j=0, l2=blocks.length ; j<l2 ; j++) {
			// Process each block
			var destBlock = blocks[j].split(',');
			FCKConfig.ToolbarSets["DynamicToolbar"].push(destBlock);
		}
		if (i<l-1) FCKConfig.ToolbarSets["DynamicToolbar"].push('/');
	}
}
