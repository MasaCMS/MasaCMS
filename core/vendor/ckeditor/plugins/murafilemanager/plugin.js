CKEDITOR.plugins.add( 'MuraFilemanager', {
    icons: 'murafilemanager',
    init: function( editor ) {
      editor.addCommand( 'insertTimestamp', {
          exec: function( editor ) {
              var now = new Date();
              editor.insertHtml( 'The current date and time is: <em>' + now.toString() + '</em>' );
          }
      });

      editor.ui.addButton( 'MuraFilemanager', {
          label: 'Mura File Manager',
          command: 'insertTimestamp',
          toolbar: 'insert,0'
      });

    }
});
