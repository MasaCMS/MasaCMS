FCKCommands.RegisterCommand( 'SelectComponent', new FCKDialogCommand( 'SelectComponent', FCKLang.SelectComponentDlgTitle, FCKPlugins.Items['SelectComponent'].Path + 'fck_selectComponent.cfm', 340, 200 ) ) ;

// Create the "Plaholder" toolbar button.
var oSelectComponentItem = new FCKToolbarButton( 'SelectComponent', FCKLang.SelectComponentBtn, FCKLang.SelectComponentBtn,1 ,false,false) ;
oSelectComponentItem.IconPath = FCKPlugins.Items['SelectComponent'].Path + 'btn_selectComponent.png' ;
oSelectComponentItem.Label='Insert Component';
FCKToolbarItems.RegisterItem( 'SelectComponent', oSelectComponentItem ) ;




