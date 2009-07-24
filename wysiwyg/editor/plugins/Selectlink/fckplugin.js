FCKCommands.RegisterCommand( 'Selectlink', new FCKDialogCommand( 'Selectlink', FCKLang.SelectlinkDlgTitle, FCKPlugins.Items['Selectlink'].Path + 'fck_selectlink.cfm', 400, 400 ) ) ;

// Create the "Plaholder" toolbar button.
var oSelectlinkItem = new FCKToolbarButton( 'Selectlink', FCKLang.SelectlinkBtn, FCKLang.SelectlinkBtn,1,false,false ) ;
oSelectlinkItem.IconPath = FCKPlugins.Items['Selectlink'].Path + 'btn_selectlink.gif' ;

FCKToolbarItems.RegisterItem( 'Selectlink', oSelectlinkItem ) ;




