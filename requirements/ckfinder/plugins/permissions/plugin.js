CKFinder.addPlugin( 'permissions', function( api ) {

	var g_subdir;
	var g_editfilename;
	var privateListSimple;
	var publicListSimple;
	var labels = new Object();
	var bPrivateFlag = false;
	var dlgMain;

	var clearSelect = function(oSelect) {
		var len = oSelect.getInputElement().$.options.length;
		for (var i=0; i<len; i++) {
			oSelect.remove(0);
		}
	};
			
	var updatePerms = function(dialog) {
		dialog.setTitle( "Loading - Please Wait..." );
		api.connector.sendCommand( 'Permissions', { folderName : api.getSelectedFolder().name }, function( xml )
		{

			if ( xml.checkError() )
				return;
		
			privateListSimple = new Array();
			publicListSimple = new Array();
			var privateList = new Array();
			var publicList = new Array();

			g_subdir = xml.selectSingleNode( 'Connector/Path/@subdir' ).value;
			g_editfilename = xml.selectSingleNode( 'Connector/Path/@editFileName' ).value;
			
			var oLabels = xml.selectSingleNode('Connector/Labels');
			labels.editor = oLabels.getAttribute('editor');
			labels.author = oLabels.getAttribute('author');
			labels.inherit = oLabels.getAttribute('inherit');
			labels.readonly = oLabels.getAttribute('readonly');
			labels.deny = oLabels.getAttribute('deny');
			labels.group = oLabels.getAttribute('group');
			labels.admingroups = oLabels.getAttribute('admingroups');
			labels.membergroups = oLabels.getAttribute('membergroups');
			labels.permissions = oLabels.getAttribute('permissions');

			file = api.getSelectedFolder();
			dialog.setTitle( labels.permissions + ' - ' + file.name );

			var private = xml.selectNodes('Connector/Private/Group')
			for (var i = 0; i < private.length; i++) {
				var perm = private[i].getAttribute('perm');
				var groupid = private[i].getAttribute('groupid');
				var groupname = private[i].getAttribute('name');
				privateListSimple[i] = [groupname, groupid ];
				privateList[i] = [ groupname + ' - ' + perm, groupname, perm, groupid ];
			}

			var public = xml.selectNodes('Connector/Public/Group')
			for (var i = 0; i < public.length; i++) {
				var perm = public[i].getAttribute('perm');
				var groupid = public[i].getAttribute('groupid');
				var groupname = public[i].getAttribute('name');
				publicListSimple[i] = [groupname, groupid ];
				publicList[i] = [ groupname + ' - ' + perm, groupname, perm, groupid ];
			}
			
			var privategroups = dialog.getContentElement('tab1', 'privateperms');
			var publicgroups = dialog.getContentElement('tab1', 'publicperms');
			
			clearSelect(privategroups);
			clearSelect(publicgroups);
			
			// Populate select, based on whether we need private or public groups.
			for (var i=0; i<privateList.length; i++) 
				if (privateList[i][2] != 'inherit' && privateList[i][2] != 'none')
					privategroups.add(privateList[i][0], privateList[i][3]);
			for (var i=0; i<publicList.length; i++) 
				if (publicList[i][2] != 'inherit' && publicList[i][2] != 'none')
					publicgroups.add(publicList[i][0], publicList[i][3]);

		} );
	};

	CKFinder.dialog.add( 'addPermDialog', function( api )
	{
		return {
			title : labels.permissions,
			minWidth : 420,
			minHeight : 100,
			onShow : function() {
				var dialog = this;
				var groups = dialog.getContentElement('tab1', 'groups');
				
				// Clear select
				clearSelect(groups);
				
				// Populate select, based on whether we need private or public groups.
				var ary = (bPrivateFlag) ? privateListSimple : publicListSimple;
				groups.add('Select Group', '');

				for (var i=0; i<ary.length; i++) {
					groups.add(ary[i][0], ary[i][1]);
				}
				
			},
			onOk : function() {
				
				var dialog = this;
				
				// Submit changes
				api.connector.sendCommandPost( 'PermChange', null,
					{
						subdir: g_subdir,
						editfilename: g_editfilename,
						groupid: dialog.getContentElement('tab1', 'groups').getValue(),
						perm: dialog.getContentElement('tab1', 'level').getValue()
					},
					function( xml )
					{
						if ( xml.checkError() )
							return;

						updatePerms(dlgMain);
							
					}
				);
				
				// Update dialog to show changes.				
				//updatePerms(dlgMain);
				return undefined;
			},
			contents : [
				{
					id : 'tab1',
					label : '',
					title : '',
					expand : true,
					padding : 0,
					elements :
					[
						{
							type : 'vbox',
							children:
							[

								{
									type: 'select',
									id: 'groups',
									label: labels.group,
									size: 1,
									style: 'width: 220px;',
									items: []
								},
								{
									type : 'radio',
									id : 'level',
									'default': 'inherit',
									label : labels.permissions,
									items: [ [ labels.editor, 'editor'], [ labels.author, 'author'], [ labels.inherit, 'inherit'], [ labels.readonly, 'read'], [ labels.deny, 'deny']]
								}
							]
						}
					]
				}
			],
			buttons : [ CKFinder.dialog.okButton, CKFinder.dialog.cancelButton ]
		};
	});

	CKFinder.dialog.add( 'permDialog', function( api )
	{
		return {
			title : labels.permissions,
			minWidth : 390,
			minHeight : 230,
			onShow : function() {
				dlgMain = this;
				updatePerms(this);
			},
			onOk : function() {
				var dialog = this;
				return undefined;
			},
			contents : [
				{
					id : 'tab1',
					label : '',
					title : '',
					expand : true,
					padding : 0,
					elements :
					[
						{
							type : 'vbox',
							width : '280px',
							children:
							[
								{
									type: 'select',
									id: 'privateperms',
									label: 'System Groups',
									size: 5,
									style: 'width: 220px;',
									items: []
								},
								{
									type: 'hbox',
									widths: ['140px', '140px'],
									children: [
										{
											type: 'button',
											label: 'Add/Edit',
											'onClick': function() {
												bPrivateFlag = true;
												api.openDialog('addPermDialog');
											}
										}
									]
								},
								{
									type: 'select',
									id: 'publicperms',
									label: 'Member Groups',
									size: 5,
									style: 'width: 220px;',
									items: []
								},
								{
									type: 'hbox',
									widths: ['140px', '140px'],
									children: [
										{
											type: 'button',
											label: 'Add/Edit',
											'onClick': function() {
												bPrivateFlag = false;
												api.openDialog('addPermDialog');
											}
										}
									]
								}
							]
						}
					]
				}
			],
			buttons : [ CKFinder.dialog.okButton ]
		};
	} );
	
	api.addFolderContextMenuOption( { label : 'Permissions', command : "Permissions" } , function( api, file )
	{
		api.connector.sendCommandPost( 'Permissions', null,
			{
				subdir: ''
			},
			function( xml )
			{
				if ( xml.checkError() )
					return;
							
					api.openDialog('permDialog');
				}
		);
	});

	/*
	api.addFolderContextMenuOption( { label : 'Show Default Path', command : "GetDefaultPath" } , function( api, file )
	{
		api.connector.sendCommand( 'GetDefaultPath', { folderName : api.getSelectedFolder().name }, function( xml )
		{
			if ( xml.checkError() )
				return;
 
			var size = xml.selectSingleNode( 'Connector/DefaultFolder/@path' );
			api.openMsgDialog( "", "The default path is: " + size.value + ".");
		} );
	});
	*/
});

