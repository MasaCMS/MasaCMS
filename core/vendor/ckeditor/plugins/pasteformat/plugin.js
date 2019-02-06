/**
 * @file Plugin to cleanup pasted text.
 */
CKEDITOR.plugins.add( 'pasteformat',
{
	init : function( editor )
	{

		function CleanHTML( ev )
		{
			var html=ev.data.html || ev.data.dataValue;

			html = html.replace(/<(\/)*(\\?xml:|meta|link|span|font|del|ins|st1:|[ovwxp]:)((.|\s)*?)>/gi, ''); // Unwanted tags
			html = html.replace(/(class|style|type|start)=("(.*?)"|(\w*))/gi, ''); // Unwanted sttributes
			html = html.replace(/<style(.*?)style>/gi, '');   // Style tags
			html = html.replace(/<script(.*?)script>/gi, ''); // Script tags
			html = html.replace(/<!--(.*?)-->/gi, '');        // HTML comments
			html = html.replace(/<p><br.*?\/><\/p>/gi,"<p>paraplaceholder<\/p>" ) ;
			html = html.replace(/<\/p>\s*<p>/gi,"\<br \/>" ) ;
			html = html.replace(/paraplaceholder/gi,"<\/p><p>" ) ;
			html = html.replace(/<p><br.*?\/>/gi,"<p>" ) ;
			//console.log(html)
			if (ev.data.html) {
				ev.data.html =html;
			}
			else if (ev.data.dataValue) {
				ev.data.dataValue =html;
			}
		}

		editor.on( 'paste', CleanHTML );
	}
});
