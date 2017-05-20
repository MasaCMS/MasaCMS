/**
 * @license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */
CKEDITOR.dialog.add( 'textarea', function( editor ) {
	return {
		title: editor.lang.forms.textarea.title,
		minWidth: 350,
		minHeight: 220,
		onShow: function() {
			delete this.textarea;

			var element = this.getParentEditor().getSelection().getSelectedElement();
			if ( element && element.getName() == "textarea" ) {
				this.textarea = element;
				this.setupContent( element );
			}
		},
		onOk: function() {
			var editor,
				element = this.textarea,
				isInsertMode = !element;

			if ( isInsertMode ) {
				editor = this.getParentEditor();
				element = editor.document.createElement( 'textarea' );
			}
			this.commitContent( element );

			if ( isInsertMode )
				editor.insertElement( element );
		},
		contents: [
			{
			id: 'info',
			label: editor.lang.forms.textarea.title,
			title: editor.lang.forms.textarea.title,
			elements: [
				{
				id: '_cke_saved_name',
				type: 'text',
				label: editor.lang.common.name,
				'default': '',
				accessKey: 'N',
				setup: function( element ) {
					this.setValue( element.data( 'cke-saved-name' ) || element.getAttribute( 'name' ) || '' );
				},
				commit: function( element ) {
					if ( this.getValue() )
						element.data( 'cke-saved-name', this.getValue() );
					else {
						element.data( 'cke-saved-name', false );
						element.removeAttribute( 'name' );
					}
				}
			},
				{
				type: 'hbox',
				widths: [ '50%', '50%' ],
				children: [
					{
					id: 'cols',
					type: 'text',
					label: editor.lang.forms.textarea.cols,
					'default': '',
					accessKey: 'C',
					style: 'width:50px',
					validate: CKEDITOR.dialog.validate.integer( editor.lang.common.validateNumberFailed ),
					setup: function( element ) {
						var value = element.hasAttribute( 'cols' ) && element.getAttribute( 'cols' );
						this.setValue( value || '' );
					},
					commit: function( element ) {
						if ( this.getValue() )
							element.setAttribute( 'cols', this.getValue() );
						else
							element.removeAttribute( 'cols' );
					}
				},
					{
					id: 'rows',
					type: 'text',
					label: editor.lang.forms.textarea.rows,
					'default': '',
					accessKey: 'R',
					style: 'width:50px',
					validate: CKEDITOR.dialog.validate.integer( editor.lang.common.validateNumberFailed ),
					setup: function( element ) {
						var value = element.hasAttribute( 'rows' ) && element.getAttribute( 'rows' );
						this.setValue( value || '' );
					},
					commit: function( element ) {
						if ( this.getValue() )
							element.setAttribute( 'rows', this.getValue() );
						else
							element.removeAttribute( 'rows' );
					}
				}
				]
			},
				{
				id: 'value',
				type: 'textarea',
				label: editor.lang.forms.textfield.value,
				'default': '',
				setup: function( element ) {
					this.setValue( element.$.defaultValue );
				},
				commit: function( element ) {
					element.$.value = element.$.defaultValue = this.getValue();
				}
			},
		            {
		                id: 'data-required',
		                type: 'select',
		                label: 'Required',
		                'default': 'false',
		                items: [
		                    ['False', 'false'],
		                    ['True', 'true']
		                ],
		                setup: function (b) {
		                    var c = b.hasAttribute('data-required') && b.getAttribute('data-required');
		                    this.setValue(c || '');
		                },
		                commit: function (b) {
		                    if (this.getValue()) b.setAttribute('data-required', this.getValue());
		                    else b.removeAttribute('data-required');
		                }
		            },
		            {
		                id: 'data-validate',
		                type: 'select',
		                label: 'Validation',
		                'default': '',
		                items: [
		                    ['None', ''],
		                    ['Regex', 'regex']
		                ],
		                setup: function (b) {
		                    var c = b.hasAttribute('data-validate') && b.getAttribute('data-validate');
		                    this.setValue(c || '');
		                },
		                commit: function (b) {
		                    if (this.getValue()) b.setAttribute('data-validate', this.getValue());
		                    else b.removeAttribute('data-validate');
		                }
		            },
		            {
		                id: 'data-message',
		                type: 'text',
		                label: 'Validation Failure Message',
		                'default': '',
		                setup: function (b) {
		                    var c = b.hasAttribute('data-message') && b.getAttribute('data-message');
		                    this.setValue(c || '');
		                },
		                commit: function (b) {
		                    if (this.getValue()) b.setAttribute('data-message', this.getValue());
		                    else b.removeAttribute('data-message');
		                }
		            },
		            {
		                id: 'data-regex',
		                type: 'text',
		                label: 'Regex Expression (Use when validate is set to Regex)',
		                'default': '',
		                setup: function (b) {
		                    var c = b.hasAttribute('data-regex') && b.getAttribute('data-regex');
		                    this.setValue(c || '');
		                },
		                commit: function (b) {
		                    if (this.getValue()) b.setAttribute('data-regex', this.getValue());
		                    else b.removeAttribute('data-regex');
		                }
		            }

			]
		}
		]
	};
});
