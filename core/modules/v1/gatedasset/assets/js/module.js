Mura(function(m){
	Mura.DisplayObject.Form.reopen({
			// triggered after the form has rendered on the browser
		onAfterResponseRender: function () {
		}
	});

	var self = this;
	self.inited = false;
	
	Mura.UI.GatedAsset=Mura.UI.extend(
		{
		context:{},
		ormform: false,
		formJSON:{},
		data:{},
		columns:[],
		currentpage: 0,
		entity: {},
		fields:{},
		filters: {},
		datasets: [],
		sortfield: '',
		sortdir: '',
		inlineerrors: true,
		properties: {},
		rendered: {},
		renderqueue: 0,
		formInit: false,
		responsemessage: "",
		renderClient: function() {
			if(this.context.formid && this.context.formid.length) {
				var gatedkey = 'GATED_' + this.context.formid.replaceAll('\-','');

				var cc = readCookie(gatedkey);
				var ident = "mura-form-" + this.context.instanceid;
				this.context.formEl = "#" + ident;
				
				if(cc.length) {
					var content = this.context.posttext;
					content += '<div><a id="gatedasset-button-action" class="btn btn-primary" href=' + this.context.url + '>' + this.context.buttonlabel + '</a></div>';
					Mura(this.context.targetEl).html(content);
				}
				else {
					this.context.pretext = "<div class='gated-pretext'>"+this.context.pretext+"</div>";
					var nestedForm = new Mura.UI.Form( this.context );
					this.context.mode = 'form';
					if(this.context.displaytype == 'modal') {
						this.context.html = '<div class="modal" id="gatedModal" tabindex="-1" role="dialog"><div class="modal-dialog" role="document"> <div class="modal-content"><div class="modal-body" id="'+ident+'"></div><div class="modal-footer"><button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button></div></div></div></div>';
						var button = "<button id='gatedasset-button-modal' class='btn btn-primary' data-toggle='modal' data-target='#gatedModal'>" + this.context.modalbuttonlabel + "</button>";
						Mura(this.context.targetEl).html( this.context.pretext + this.context.html + button );
						Mura("#gatedasset-button-modal").on('click',function() {
							nestedForm.getForm();
						});
					}
					else {
						this.context.html = '<div id="'+ident+'"></div';
						Mura(this.context.targetEl).html( this.context.pretext + this.context.html );		
						nestedForm.getForm();
					}
				}
			}
			return this;
		},
		renderServer:function(){
			return Mura.templates['form'](this.context);
		}
	});

	Mura.DisplayObject.GatedAsset=Mura.UI.GatedAsset;
	Mura.UI.gatedasset=Mura.UI.GatedAsset;
	Mura.DisplayObject.gatedasset=Mura.UI.GatedAsset;

});
