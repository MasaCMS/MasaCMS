// todo: audit for resource bundle keys
MuraFileBrowser = {

	config: {
		resourcepath: "User_Assets",
		directory: "",
		height: 600,
		selectMode: 0,
		endpoint: '',
		displaymode: 2, // 1: grid, 2: list
		selectCallback: function() {}
	}
	
	, prettify: function( tgt ) {
	}
	
	, render: function( config ) {
		var self = this;
		var target =  "_" + Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
	
		this.config=Mura.extend(config,this.config);
		this.endpoint =  Mura.apiEndpoint + "filebrowser/";
		this.container = Mura("#MasaBrowserContainer");
		this.container.append("<div id='" + target + "'><component :is='currentView'></component></div>");
		this.target = target;
		this.main(); // Delegating to main()
		Mura.loader()
		.loadcss(Mura.corepath + '/vendor/codemirror/codemirror.css')
		.loadjs(
			Mura.adminpath + '/assets/js/vue.min.js',
			Mura.corepath + '/vendor/codemirror/codemirror.js',
		function() {
			self.mountbrowser();
		 } ) ;
	
		 this.getURLVars();
	}
	
	, main: function( config ) {
		var self = this;
	}
	
	, onError: function(msg) {
		console.log( msg );
	}
	
	, getURLVars: function() {
		var vars = {};
		var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
			vars[key] = value;
		});
	
		if(vars['CKEditorFuncNum'])
			this.callback = vars['CKEditorFuncNum'];
	}
	
	, validate: function() {
		return true;
	}
	
	, getEditFile: function( directory,currentFile,onSuccess) {
		var dir = directory == undefined ? "" : directory;
		var baseurl = this.endpoint + "/edit?directory=" + dir + "&filename=" + currentFile.fullname + "&resourcepath=" + this.config.resourcepath;
	
		if(!this.validate()) {
		return error("No Access");
		}
	
		Mura.get( baseurl )
		.then (
			//success
			function(response) {
			onSuccess(response);
			},
			//fail
			function(response) {
			onError(response);
			}
		);
	}

	, moveFile: function( currentFile,directory,destination,onSuccess ) {
		if(!this.validate()) {
			return error("No Access");
		}
	
		Mura.getEntity('filebrowser').invokeWithCSRF(
			'move',
			{
				directory:directory,
				destination:destination,
				resourcepath:this.config.resourcepath,
				filename:currentFile.fullname
			},
			'post'
		).then(
			//success
			function(response) {
				onSuccess(response);
			},
			//fail
			function(response) {
				this.onError(response);
			}
		);
	}

 , getChildren: function(dir,onSuccess) {

		if(!this.validate()) {
			return error("No Access");
		}
 		
		Mura.getEntity('filebrowser').invokeWithCSRF(
			'children',
			{
				directory:dir,
				resourcepath:this.config.resourcepath,
			},
			'post'
		)
			.then(
				//success
				function(response) {
					onSuccess(response);
				},
				//fail
				function(response) {
					this.onError(response);
				}
		);
	}

	, doDeleteFile: function( directory,currentFile,onSuccess,onError) {
		var dir = directory == undefined ? "" : directory;
		var baseurl = this.endpoint + "/delete?directory=" + dir + "&filename=" + currentFile.fullname + "&resourcepath=" + this.config.resourcepath;
		var formData = {
		resourcepath:this.config.resourcepath,
		directory:dir,
		filename:currentFile.fullname
		};
	
		if(!this.validate()) {
		return error("No Access");
		}
	
		Mura.getEntity('filebrowser').invokeWithCSRF(
		'delete',
		formData,
		'post'
		)
		.then (
		function(response) {
			if(response.success && response.success != "0") {
			onSuccess(response);
			}
			else {
			onError(response);
			}
		},
		function(response) {
			onError(response);
		}
		);
	}
	
	, doDuplicateFile: function( directory,currentFile,onSuccess,onError) {
		var dir = directory == undefined ? "" : directory;
		var formData = {
		resourcepath:this.config.resourcepath,
		completepath:this.config.completepath,
		directory:dir,
		file:currentFile
		};
		
		if(!this.validate()) {
		return error("No Access");
		}
	
		Mura.getEntity('filebrowser').invokeWithCSRF(
		'duplicate',
		formData,
		'post'
		).then (
			function(response) {
			onSuccess(response);
			},
			function(response) {
			onError(response);
			}
		);
	
	}
	
	, doUpdateContent: function( directory,currentFile,content,onSuccess,onError) {
		var dir = directory == undefined ? "" : directory;
		var formData = {
		resourcepath:this.config.resourcepath,
		completepath:this.config.completepath,
		directory:dir,
		filename:currentFile.fullname,
		content:content
		};
	
		if(!this.validate()) {
		return error("No Access");
		}
	
		Mura.getEntity('filebrowser').invokeWithCSRF(
		'update',
		formData,
		'post'
		).then (
		function(response) {
			onSuccess(response);
		},
		function(response) {
			onError(response);
		}
		);
	
	}
	
	, doRenameFile: function( directory,currentFile,onSuccess,onError) {
		var dir = directory == undefined ? "" : directory;
		var baseurl = this.endpoint + "/rename?directory=" + dir + "&filename=" + currentFile.fullname + "&name=" + currentFile.name + "&resourcepath=" + this.config.resourcepath;
	
		var formData = {
		resourcepath:this.config.resourcepath,
		completepath:this.config.completepath,
		directory:dir,
		filename:currentFile.fullname,
		name:currentFile.name
		};
	
		if(!this.validate()) {
		return error("No Access");
		}
	
		Mura.getEntity('filebrowser').invokeWithCSRF(
		'rename',
		formData,
		'post'
		).then (
		function(response) {
			onSuccess(response);
		},
		function(response) {
			onError(response);
		}
		);
	}
	
	, doNewFolder: function( directory,newfolder,onSuccess ) {
		var dir = directory == undefined ? "" : directory;
		var formData = {
		resourcepath:this.config.resourcepath,
		completepath:this.config.completepath,
		directory:dir,
		name:newfolder,
		};
	
		if(!this.validate()) {
		return error("No Access");
		}
	
		Mura.getEntity('filebrowser').invokeWithCSRF(
		'addfolder',
		formData,
		'post'
		).then (
		//success
		function(response) {
			onSuccess(response);
		},
		//fail
		function(response) {
			onError(response);
		}
		);
	
	}
	
	, loadDirectory: function( directory,pageindex,onSuccess,onError,filterResults,sortOn,sortDir,itemsper ) {
		var self = this;
	
		var dir = directory == undefined ? "" : directory;
	
		var baseurl = this.endpoint + "browse?directory=" + dir + "&resourcepath=" + this.config.resourcepath;
	
		if(!this.validate()) {
		return error("No Access");
		}
	
		if(pageindex) {
		baseurl += "&pageindex=" + pageindex;
		}
	
		if(itemsper) {
		baseurl += "&itemsperpage=" + itemsper;
		}
	
		if(filterResults.length) {
		baseurl += "&filterResults=" + filterResults;
		}
	
		Mura.get( baseurl )
		.then (
			//success
			function(response) {
			onSuccess(response);
			},
			//fail
			function(response) {
			onError(response);
			}
		);
	}
	
	, loadBaseDirectory: function( onSuccess,onError,directory ) {
		var self = this;
	
		var dir = directory ? directory : this.config.directory;
	
		var baseurl = this.endpoint + "/browse" + "?resourcepath=" + this.config.resourcepath + "&directory=" + dir + "&settings=1";
	
		if(!this.validate()) {
		return error("No Access");
		}
	
		Mura.get( baseurl )
		.then (
			//success
			function(response) {
			onSuccess(response);
			},
			//fail
			function(response) {
			onError(response);
			}
		);
	}
	
	, doUpload: function( formData,success,fail ) {
		formData.append('resourcepath',this.config.resourcepath);
	
		var fData = {};
		formData.forEach(function(value, key){
		fData[key] = value;
		});
		var json = JSON.stringify(fData);
	
		if(!this.validate()) {
		return error("No Access");
		}
	
		Mura.getEntity('filebrowser').invokeWithCSRF(
		'upload',
		formData,
		'post'
		).then(
		function doSuccess( response ) {
			success( response, fail );
		},
		function doonError( response ) {
			onError(response);
		}
		);
	}
	
	, rotate: function( currentFile,direction,success,error) {
		var self = this;
		var formData = {
		resourcepath:this.config.resourcepath,
		completepath:this.config.completepath,
		file:JSON.parse(JSON.stringify(currentFile)),
		direction:direction,
		};
	
		if(!this.validate()) {
		return error("No Access");
		}
	
		Mura.getEntity('filebrowser').invokeWithCSRF(
		'rotate',
		formData,
		'post'
		).then (
		function doSuccess( response ) {
			success( response );
		},
		function doonError( response ) {
			onError(response);
		}
		);
	}
	
	, performResize: function( currentFile,dimensions,success,error ) {
		var self = this;
		var formData = {
		resourcepath:this.config.resourcepath,
		completepath:this.config.completepath,
		file:JSON.parse(JSON.stringify(currentFile)),
		dimensions: dimensions
		};
	
		if(!this.validate()) {
		return error("No Access");
		}
	
		Mura.getEntity('filebrowser').invokeWithCSRF(
		'resize',
		formData,
		'post'
		).then(
		function doSuccess( response ) {
			success( response );
		},
		function doonError( response ) {
			onError(response);
		}
		);
	
	}
	
	, performCrop: function( currentFile,success,error ) {
		var self = this;
	
		if(!this.validate()) {
		return error("No Access");
		}
	
		var formData = {};
	
		// bounding container
		var container = document.getElementById('imagediv');
		// crop rect
		var cropRect = document.getElementById('croprectangle');
		// crop rect bounds
		var rect = cropRect.getBoundingClientRect();
		// original image dimensions
		var source = {
			width: currentFile.info.width,
			height: currentFile.info.height
		};
	
		// size of container
		var size = {
		width: container.clientWidth,
		height: container.clientHeight
		};
		// crop rect size
		var crop = {
			x: 0,
			y: 0,
			width: 0,
			height: 0
		};
	
		crop.x = cropRect.oLeft;
		crop.y = cropRect.oTop;
		crop.width = rect.width;
		crop.height = rect.height;
	
		formData.file = JSON.parse(JSON.stringify(currentFile));
		formData.crop = crop;
		formData.size = size;
	
		Mura.getEntity('filebrowser').invokeWithCSRF(
		'processCrop',
		formData,
		'post'
		).then (
		function doSuccess( response ) {
			success( response );
		},
		function doonError( response ) {
			onError(response);
		}
		);
	
	}
	, crop: function( canvas,clear ) {
	
		if(clear == true) {
		var cropRect = document.getElementById('croprectangle');
		if(cropRect)
			cropRect.parentNode.removeChild(cropRect);
		return;
		}
	
		var corners = {
			x: 0,
			y: 0,
			startX: 0,
			startY: 0
		};
		var element = null;
	
		function setCornerPosition(e) {
			var ev = e || window.event; //Moz || IE
			var rect = canvas.getBoundingClientRect();
	
			if (ev.pageX) { //Moz
				if(e.target != document.getElementById('imagediv')) {
				corners.x = e.offsetX + e.target.oLeft;
				corners.y = e.offsetY + e.target.oTop;
				}
				else {
				corners.x = ev.offsetX;
				corners.y = ev.offsetY;
				}
			} else if (ev.clientX) { //IE
				corners.x = ev.offsetX;
				corners.y = ev.offsetY;
			}
		};
	
		canvas.onmousemove = function (e) {
			if (element !== null) {
			setCornerPosition(e);
	//        element.pointer = 'none';
			element.style.width = Math.abs(corners.x - corners.startX) + 'px';
			element.style.height = Math.abs(corners.y - corners.startY) + 'px';
			element.style.left = (corners.x - corners.startX < 0) ? corners.x + 'px' : corners.startX + 'px';
			element.style.top = (corners.y - corners.startY < 0) ? corners.y + 'px' : corners.startY + 'px';
			}
		}
	
		canvas.onmouseup = function( e ) {
			element = null;
			canvas.style.cursor = "default";
		}
	
		canvas.onmousedown = function (e) {
			if (element !== null) {
			}
			else {
			var cropRect = document.getElementById('croprectangle');
			if(cropRect)
				cropRect.parentNode.removeChild(cropRect);
	
			setCornerPosition(e);
			corners.startX = corners.x;
			corners.startY = corners.y;
	
			var rect = canvas.getBoundingClientRect();
	
			element = document.createElement('div');
			element.className = 'rectangle';
			element.id = 'croprectangle';
			element.style.width = Math.abs(corners.x - corners.startX) + 'px';
			element.style.height = Math.abs(corners.y - corners.startY) + 'px';
			element.style.left = (corners.x - corners.startX < 0) ? corners.x + 'px' : corners.startX + 'px';
			element.style.top = (corners.y - corners.startY < 0) ? corners.y + 'px' : corners.startY + 'px';
	
			canvas.appendChild(element);
			canvas.style.cursor = "crosshair";
			}
		}
	}
	
	, mountbrowser: function() {
		var self = this;
	
		Vue.directive('click-outside', {
		bind: function (el, binding, vnode) {
			el.clickOutsideEvent = function (event) {
			// here I check that click was outside the el and his childrens
			if (!(el == event.target || el.contains(event.target))) {
				// and if it did, call method provided in attribute value
				vnode.context[binding.expression](event);
			}
			};
			document.body.addEventListener('click', el.clickOutsideEvent)
		},
		unbind: function (el) {
			document.body.removeEventListener('click', el.clickOutsideEvent)
		},
		});
	
		Vue.component('contextmenu', {
		props: ["currentFile","menuy","menux","bottom"],
		template: `
		<div id="newContentMenu" class="addNew" v-bind:style="{ left: (menux + 20) + 'px',top: getTop() + 'px' }">
			<ul id="newContentOptions">
				<li v-if="checkIsFile() && checkSelectMode()"><a href="#" @click.prevent="selectFile()"><i class="mi-check"></i>Select</a></li>
				<li v-if="checkIsFile() && checkFileEditable()"><a href="#" @click.prevent="editFile()"><i class="mi-pencil"></i>Edit</a></li>
				<li v-if="checkIsFile() && checkImageType()"><a href="#" @click.prevent="viewFile()"><i class="mi-image"></i>View</a></li>
				<li v-if="checkIsFile() || checkImageType()"><a href="#" @click.prevent="moveFile()"><i class="mi-move"></i>Move</a></li>
				<li v-if="checkIsFile() && checkImageType()"><a href="#" @click.prevent="duplicateFile()"><i class="mi-copy"></i>Duplicate</a></li>
				<li><a href="#" @click.prevent="renameFile()"><i class="mi-edit"> Rename</i></a></li>
				<li v-if="checkIsFile()"><a href="#" @click="downloadFile()"><i class="mi-download"> Download</i></a></li>
				<li class="delete"><a href="#" @click="deleteFile()"><i class="mi-trash"> Delete</i></a></li>
			</ul>
			</div>
		`,
		data() {
			return {
				posx: 0,
				posy: 0
			};
		}
		, computed: {
	
		}
		, mounted: function() {
		}
		, methods: {
			compstyle: function() {
			this.posx = this.menux;
			this.posy = this.menuy;
	
			return ;
			}
			, getTop: function() {
			return this.menuy + window.pageYOffset;
			}
			, selectFile: function() {
				if(MuraFileBrowser.config.selectMode == 1) {
					var urlstem = fileViewer.currentFile.url;
					if(urlstem.includes('://')) {
						urlstem = urlstem.replace(/^(.[^\/]*['\:\/\/'].[^\/]*)(.*)$/,'$2');
					}
					window.opener.CKEDITOR.tools.callFunction(self.callback,urlstem);
					window.close();
				}
				else {
					window.close();
					fileViewer.currentFile.rootpath = MuraFileBrowser.rootpath;
					return MuraFileBrowser.config.selectCallback( fileViewer.currentFile );
				}
			}
			, editFile: function() {
				fileViewer.editFile(this.successEditFile);
			}
			, duplicateFile: function() {
				fileViewer.duplicateFile(fileViewer.refresh, fileViewer.displayError);
			}
			, viewFile: function() {
				fileViewer.isDisplayWindow = "VIEW";
				fileViewer.viewFile();
			}
			, successEditFile: function( response ) {
				this.currentFile.content = response.data.content;
				fileViewer.isDisplayWindow = "EDIT";
				}
			, renameFile: function() {
				fileViewer.isDisplayWindow = "RENAME";
			}
			, moveFile: function() {
				fileViewer.isDisplayWindow = "MOVE";
			}
			, downloadFile: function() {
				window.open(fileViewer.currentFile.url, '_blank');
			}
			, deleteFile: function() {
			fileViewer.isDisplayWindow = "DELETE";
			}
			, checkSelectMode: function() {
				return fileViewer.checkSelectMode();
			}
			, checkFileEditable: function() {
				return fileViewer.checkFileEditable();
			}
			, checkImageType: function() {
			return fileViewer.checkImageType();
			}
			, checkIsFile: function() {
			return fileViewer.checkIsFile();
			}
		}
		});
	
		Vue.component('actionwindow', {
		props: ["isDisplayWindow","currentFile","currentIndex","error",'foldertree'],
		template: `
			<div id="actionwindow-wrapper">
			<editwindow v-if="isDisplayWindow=='EDIT'" :currentFile="currentFile"></editwindow>
			<renamewindow v-if="isDisplayWindow=='RENAME'" :currentFile="currentFile"></renamewindow>
			<addfolderwindow v-if="isDisplayWindow=='ADDFOLDER'" :currentFile="currentFile"></addfolderwindow>
			<downloadwindow v-if="isDisplayWindow=='DOWNLOAD'" :currentFile="currentFile"></downloadwindow>
			<deletewindow v-if="isDisplayWindow=='DELETE'" :currentFile="currentFile"></deletewindow>
			<movewindow v-if="isDisplayWindow=='MOVE'" :foldertree="foldertree" :currentFile="currentFile"></movewindow>
			<errorwindow v-if="isDisplayWindow=='ERROR'" :currentFile="currentFile" :error="error"></errorwindow>
			</div>
		`,
		data() {
			return {};
		},
		methods: {
		}
		});

		


		Vue.component('movewindow', {
			props: ['files','folders','foldertree','isDisplayContext','currentFile'],
			template: `
			<div class="ui-dialog actionwindow-formwrapper">
				<div>
					<div>
						<span class="ui-dialog-title">Move</span>
						<div>
							<label>Name: <span>{{currentFile.fullname}}</span></label>
							<label>Location: <span>{{this.$root.resourcepath}}</span><span v-for="(item, index) in foldertree"> / {{item}}</span> </label>
						</div>
						<div>
							<label>
								Move to:
								<span><a @click="setDir(-1)" class="folder-item">{{this.$root.resourcepath}}</a></span>
									<span v-for="(item,index) in sourcefolders" @click="setDir(index)"> / <a class="folder-item">{{item}}</a></span>
								<span>
									<select v-if="children.length" v-model="folderName">
										<option v-if="item.length" v-for="item in children" :value="item">/{{item}}</option>
									</select>
								</span>
							</label>
						</div>
						<div class="buttonset">
							<button @click="moveFile()">Move</button>
							<button class="mura-secondary" @click="cancel()">Cancel</button>
						</div>
					</div>
				</div>
			</div>
			`,
			data() {
					return {
						folderName: '',
						sourcefolders: [],
						children: [],
						invalid: ''
					};
			},
			watch: {
				folderName: function(val) {
					if(this.folderPath != '') {
						this.sourcefolders.push(this.folderName);
	
						var destination = "";
	
						for(i in this.sourcefolders) {
							destination += "/" + this.sourcefolders[i];
						}
						this.children = [];
						MuraFileBrowser.getChildren(destination,this.update);
					}
				}
			},
			methods: {
				moveFile: function() {
					var directory = "";
					var destination = "";

					for(i in fileViewer.foldertree) {
						directory += "/" + fileViewer.foldertree[i];
					}
	
					for(i in this.sourcefolders) {
						destination += "/" + this.sourcefolders[i];
					}
	
					fileViewer.spinnermodal = 1;
					MuraFileBrowser.moveFile(this.currentFile,directory,destination,this.isMoved);

				},
				isMoved: function() {
					fileViewer.isDisplayWindow = '';
					fileViewer.refresh();
				},
				setDir: function(val) {
					val +=1;
					this.sourcefolders.length = val;
					var folder = "";
	
					for(i in this.sourcefolders) {
						folder += "/" + this.sourcefolders[i];
					}
					this.children = [];
					MuraFileBrowser.getChildren(folder,this.update);
				},
				update: function(result) {
					if(parseInt(result.success)) {
						this.invalid = "";
						this.children = result.folders;
					}
					else {
						this.children = [];
						this.invalid = "(This is not a valid directory)";
					}
				},
				cancel: function() {
					fileViewer.isDisplayWindow = '';
				}
			},
			mounted: function() {
				this.sourcefolders = this.foldertree.slice(0);
	
				this.filename = this.currentFile.name;
				fileViewer.isDisplayContext = 0;
				var folder = "";
	
				for(i in this.sourcefolders) {
					folder += "/" + this.sourcefolders[i];
				}
	
				MuraFileBrowser.getChildren(folder,this.update);
			}
		});

		Vue.component('renamewindow', {
		props: ["currentFile"],
		template: `
			<div class="ui-dialog dialog-nobg actionwindow-formwrapper">
			<div>
				<span class="ui-dialog-title">Rename</span>
				<div>
					<label>Name:</label>
					<input type="text" v-model="filename"></input>
				</div>
			</div>
			<div class="buttonset">
				<button @click="updateRename()">Save</button>
				<button @click="cancel()">Cancel</button>
			</div>
			</div>
		`,
		data() {
			return {
				filename: ''
			};
		},
		methods: {
			updateRename: function() {
			this.currentFile.name = this.filename;
			fileViewer.renameFile();
	
			fileViewer.isDisplayWindow = '';
			}
			, cancel: function() {
			fileViewer.isDisplayWindow = '';
			}
		},
		mounted: function() {
			this.filename = this.currentFile.name;
			fileViewer.isDisplayContext = 0;
		}
		});
	
		Vue.component('errorwindow', {
		props: ['error'],
		template: `
			<div class="ui-dialog dialog-confirm ui-dialog actionwindow-formwrapper">
			<div>
				<span class="ui-dialog-title">Error</span>
				<h4>{{error}}</h4>
			</div>
			<div class="buttonset">
				<button @click="cancel()">Close</button>
			</div>
			</div>
		`,
		data() {
			return {
				filename: ''
			};
		},
		methods: {
			cancel: function() {
			fileViewer.isDisplayWindow = '';
			}
		}
		});
	
		Vue.component('addfolderwindow', {
		props: ["currentFile"],
		template: `
			<div class="ui-dialog dialog-nobg actionwindow-formwrapper">
			<div>
				<span class="ui-dialog-title">Add Folder</span>
				Name:
				<input type="text" v-model="foldername"></input>
			</div>
			<div class="buttonset">
				<button @click="newFolder()">Save</button>
				<button @click="cancel()">Cancel</button>
			</div>
			</div>
		`,
		data() {
			return {
				foldername: ''
			};
		},
		methods: {
			newFolder: function() {
			fileViewer.newFolder(this.foldername);
	
			fileViewer.isDisplayWindow = '';
			}
			, cancel: function() {
			fileViewer.isDisplayWindow = '';
			}
		},
		mounted: function() {
	
		}
		});
	
		Vue.component('gallerywindow', {
		props: ["currentFile","currentIndex","total"],
		template: `
			<div class="fileviewer-modal">
			<div class="fileviewer-gallery" v-click-outside="closewindow">
				<div class="fileviewer-image" :style="{ 'background-image': 'url(' + encodeURI(currentFile.url) + '?' + Math.ceil(Math.random()*100000) + ')' }"></div>
				<div>
					<div class="actionwindow-left" @click="lastimage"><i class="mi-caret-left"></i></div>
					<div class="actionwindow-right" @click="nextimage"><i class="mi-caret-right"></i></div>
					<div class="fileviewer-gallery-menu">
					<ul>
						<li v-if="checkImageType() && checkSelectMode()"><a @click="selectFile()"><i class="mi-check"></i>Select</a></li>
						<li v-if="checkImageType()"><a @click="editImage()"><i class="mi-check"></i>Edit Image</a></li>
						<li v-if="checkFileEditable()"><a @click="editFile()"><i class="mi-pencil"></i>Edit</a></li>
						<li><a @click="renameFile()"><i class="mi-edit"></i>Rename</a></li>
						<li v-if="checkIsFile()"><a @click="downloadFile()"><i class="mi-download"></i>Download</a></li>
						<li><a @click="deleteFile()"><i class="mi-trash"></i>Delete</a></li>
						<li><a @click="closewindow()"><i class="mi-times"></i>Close</a></li>
					</ul>
					<p>{{currentFile.fullname}} ({{currentFile.size}}kb <span v-if="checkImageType()">{{currentFile.info.width}}x{{currentFile.info.height}}</span>)</p>
				</div>
			</div>
			</div>
		`,
		data() {
			return {};
		}
		, mounted: function() {
			this.$root.isDisplayContext = 0;
		}
		, methods: {
			lastimage: function() {
			fileViewer.previousFile(1);
			}
			, nextimage: function() {
			fileViewer.nextFile(1);
			}
			, closewindow: function( event ) {
			this.$root.isDisplayWindow = "";
			}
			, selectFile: function() {
				if(MuraFileBrowser.config.selectMode == 1) {
					var urlstem = fileViewer.currentFile.url;
					if(urlstem.includes('://')) {
						urlstem = urlstem.replace(/^(.[^\/]*['\:\/\/'].[^\/]*)(.*)$/,'$2');
					}
					window.opener.CKEDITOR.tools.callFunction(self.callback,urlstem);
					window.close();
				}
				else {
					return MuraFileBrowser.config.selectCallback( fileViewer.currentFile );
				}
			}
			, renameFile: function() {
			fileViewer.isDisplayWindow = "RENAME";
			}
			, editImage: function() {
			fileViewer.isDisplayWindow = "EDITIMAGE";
			}
			, downloadFile: function() {
				window.open(fileViewer.currentFile.url, '_blank');
			}
			, deleteFile: function() {
			fileViewer.isDisplayWindow = "DELETE";
			}
			, checkSelectMode: function() {
				return fileViewer.checkSelectMode();
			}
			, checkFileEditable: function() {
				return fileViewer.checkFileEditable();
			}
			, checkImageType: function() {
			return fileViewer.checkImageType();
			}
			, checkIsFile: function() {
			return fileViewer.checkIsFile();
			}
	
		}
		});
	
		Vue.component('imageeditwindow', {
		props: ["currentFile","currentIndex","total"],
		template: `
		<div class="fileviewer-modal">
			<imageeditmenu class="fileviewer-gallery" :currentFile="currentFile" :currentIndex="currentIndex" v-click-outside="closewindow"></imageeditmenu>
		</div>
		`,
		data() {
			return {};
		}
		, mounted: function() {
		}
		, methods: {
			closewindow: function( event ) {
			this.$root.isDisplayWindow = "";
			}
		}
		});
	
		Vue.component('imageeditmenu', {
		props: ["currentFile","currentIndex"],
		template: `
			 <div class="fileviewer-modal">
			<div class="fileviewer-image" id="imagediv" :style="{ 'background-image': 'url(' + encodeURI(currentFile.url) + '?' + Math.ceil(Math.random()*100000) + ')' }"></div>
			<div>
				<div class="fileviewer-gallery-menu">
				<ul>
				  <!--- MAIN --->
				  <span v-if="editmode==''">
					<!--- <li><a @click="crop()"><i class="mi-crop"> Crop</i></a></li> --->
					<li><a @click="rotateRight()"><i class="mi-rotate-right"> Rotate Right</i></a></li>
					<li><a @click="rotateLeft()"><i class="mi-rotate-left"> Rotate Left</i></a></li>
					<li><a @click="resize()"><i class="mi-expand"> Resize</i></a></li>
					<li><a @click="cancel()"><i class="mi-chevron-left"> Back</i></a></li>
					</span>
					<!--- CROP --->
					<span  v-if="editmode=='CROP'">
					<li><a @click="confirmCrop()"><i class="mi-check"> Confirm</i></a></li>
					<li><a @click="cancel()"><i class="mi-times"> Cancel</i></a></li>
					</span>
					<!--- RESIZE --->
					<span  v-if="editmode=='RESIZE'">
					<li>Width: <input :disabled="resizedimensions.aspect == 'height'" name="resize-width" v-model="resizedimensions.width"></li>
					<li>Height: <input :disabled="resizedimensions.aspect == 'width'" name="resize-height" v-model="resizedimensions.height"></li>
					<li>Aspect:
						<select name="resize-aspect" v-model="resizedimensions.aspect">
						<option value="none">None</option>
						<option value="height">Height</option>
						<option value="width">Width</option>
						<option value="within">Within</option>
						</select>
					</li>
					<li><a @click="confirmResize()"><i class="mi-check"> Confirm</i></a></li>
					<li><a @click="cancel()"><i class="mi-times"> Cancel</i></a></li>
					</span>
				</ul>
				<p>{{currentFile.fullname}} ({{currentFile.size}}kb {{currentFile.info.width}}x{{currentFile.info.height}})</p>
				</div>
			</div>
			</div>
		`
		, data() {
			return {
				editmode: '',
				resizedimensions: {
				width: 0,
				height: 0,
				backup: 0,
				aspect: 'none'
				}
			};
		}
		, mounted: function() {
			this.resizedimensions.width = this.currentFile.info.width;
			this.resizedimensions.height = this.currentFile.info.height;
			this.$root.isDisplayContext = 0;
			this.editmode = '';
		}
		, methods: {
			rotateLeft: function() {
			MuraFileBrowser.rotate(this.currentFile,'counterclock',this.rotateComplete);
			}
			, rotateRight: function() {
			MuraFileBrowser.rotate(this.currentFile,'clock',this.rotateComplete);
			}
			, rotateComplete() {
			this.$root.refresh(null,null,displaywindow = "EDITIMAGE");
			}
			, resize() {
			this.editmode = "RESIZE";
			}
			, confirmResize() {
			MuraFileBrowser.performResize(this.currentFile,this.resizedimensions,this.resizeComplete);
			}
			, resizeComplete() {
			this.$root.refresh(null,null,displaywindow = "EDITIMAGE");
			}
			, crop: function() {
			this.editmode = "CROP";
			MuraFileBrowser.crop(document.getElementById('imagediv'));
			}
			, confirmCrop: function() {
			MuraFileBrowser.performCrop( this.currentFile,this.cropComplete );
			}
			, cropComplete: function() {
			this.$root.refresh();
			}
			, closewindow: function( event ) {
			this.$root.isDisplayWindow = "";
			}
			, cancel: function( event ) {
			this.$root.isDisplayWindow = "VIEW";
			this.editmode = '';
			}
		}
		});
	
		Vue.component('deletewindow', {
		props: ["currentFile"],
		template: `
			<div class="ui-dialog dialog-confirm actionwindow-formwrapper">
			<span class="ui-dialog-title">Delete</span>
				<p>Confirm Deletion: {{currentFile.fullname}}</p>
				<div class="buttonset">
				<button @click="doDelete()">Delete</button>
				<button @click="cancel()">Cancel</button>
				</div>
			</div>
		`,
		data() {
			return {};
		},
		methods: {
			doDelete: function() {
			fileViewer.deleteFile(  fileViewer.refresh, fileViewer.displayError );
			fileViewer.isDisplayWindow = '';
			}
			, cancel: function() {
			fileViewer.isDisplayWindow = '';
			}
		}
		});
	
		Vue.component('editwindow', {
		props: ["currentFile"],
		template: `
			<div class="ui-dialog dialog-nobg actionwindow-formwrapper">
			<span class="ui-dialog-title">Edit</span>
			<textarea id="contenteditfield" class="editwindow" v-model="filecontent"></textarea>
			<div class="buttonset">
				<button @click="updateContent()">Update</button>
				<button @click="cancel()">Cancel</button>
			</div>
			</div>
		`,
		data() {
			return {
				filecontent: ''
			};
		},
		methods: {
			updateContent: function() {
			fileViewer.updateContent(this.filecontent);
			fileViewer.isDisplayWindow = '';
			}
			, cancel: function() {
			fileViewer.isDisplayWindow = '';
			}
			, selectAll: function() {
			editor.commands["selectAll"](this.editor);
			},
			autoFormat: function() {
			/*
			editor.setCursor(0,0);
			CodeMirror.commands["selectAll"](editor);
			editor.autoFormatRange(editor.getCursor(true), editor.getCursor(false));
			editor.setSize(500, 500);
			editor.setCursor(0,0);
			*/
			}
		}
		, mounted: function() {
			this.filecontent = this.currentFile.content;
			/*
				editor = CodeMirror.fromTextArea(document.getElementById('contenteditfield'), {
				value: this.currentFile.content,
				mode:  "html",
				extraKeys: {"Ctrl-Space": "autocomplete"},
				lineNumbers: true,
				autoCloseTags: true,
				indentWithTabs: true,
				theme: 'monokai'
			}
			);
	
			editor.getDoc().setValue(this.currentFile.content);
			this.autoFormat();
			ed = this;
			editor.on('change', function(cm) {
			ed.filecontent = cm.getValue();
			});
	*/
		}
		});
	
		Vue.component('appbar', {
		props: ["links","isbottomnav","response","itemsper","location"],
		template: `
			<div class="filewindow-appbar">
				<navmenu v-if="response.links" :links="links" :response="response" :itemsper="itemsper" :isbottomnav="isbottomnav"></navmenu>
				<modemenu v-if="location"></modemenu>
			</div>
		`,
		data: function() {
			return {
	
			}
		},
		computed: {
	
		},
		methods: {
			applyPage: function(goto) {
				var pageindex = 1;
	
				if(goto == 'last') {
				pageindex = parseInt(fileViewer.response.totalpages);
				}
				else if(goto == 'next') {
				pageindex = parseInt(fileViewer.response.pageindex) + 1;
				}
				else if(goto == 'previous') {
				pageindex = parseInt(fileViewer.response.pageindex) - 1;
				}
	
				this.$parent.refresh('',pageindex)
			}
			, applyItemsPer: function() {
			this.$parent.itemsper = this.itemsper;
			}
		}
	
		});
	
		Vue.component('modemenu', {
		props: ["links","isbottomnav","response","itemsper","displaymode"],
		template: `
			<div class="filewindow-modemenu">
				<div class="btn-group btn-group-toggle" data-toggle="buttons">
				<a class="btn btn-secondary" v-bind:class="{ highlight: viewmode == 1 }" @click="switchMode(1)">
					<i class="mi-th" title="Grid View"></i>
				</a>
				<a class="btn btn-secondary" v-bind:class="{ highlight: viewmode == 2 }" @click="switchMode(2)">
					<i class="mi-bars" title="List View"></i>
				</a>
				</div>
				<a @click="newFolder" class="btn btn-secondary">
				<i class="mi-folder" title="Add Folder"></i>
				</a>
				<input class="filebrowser-filter" placeholder="Type to filter" v-model="filterResults" v-on:input="filterChange">
			</div>
		`,
		data() {
			return {
				viewmode: this.$root.displaymode,
				filterResults: '',
				timeout: undefined
			};
		},
		methods: {
			switchMode: function(mode) {
	
			var fdata = {
				displaymode: JSON.parse(JSON.stringify(mode))
			}
			// URL encodes the JSON string to safely handle special characters in the cookie value
			Mura.createCookie( 'fbDisplayMode',encodeURIComponent(JSON.stringify(fdata)),1000);
	
			this.$root.displaymode = this.viewmode = mode;
			}
			, newFolder: function() {
			fileViewer.isDisplayWindow = 'ADDFOLDER';
			}
			, filterChange: function(e,value) {
			// timeout to allow for typing and not fire immediately
			if(this.timeout)
				window.clearTimeout(this.timeout);
	
			this.$root.filterResults = this.filterResults;
			this.timeout = window.setTimeout(this.$root.refresh, 500);
			}
		}
	
		});
	
		Vue.component('navmenu', {
		props: ["links","isbottomnav","response","itemsper"],
		template: `
			<div class="filewindow-navmenu">
				<p v-if="isbottomnav">
				{{response.pageindex}} of {{response.totalpages}} <!-- ({{response.totalitems}}) includes folders -->
				</p>
			<ul class="pagination" v-if="response.totalitems>=25">
				<li class="paging" v-if="links.previous || links.next">
				<a href="#" v-if="links.first" @click.prevent="applyPage('first')">
					<i class="mi-angle-double-left"></i>
				</a>
				<a v-else class="disabled">
					<i class="mi-angle-double-left"></i>
				</a>
				</li>
				<li class="paging" v-if="links.previous || links.next">
				<a href="#" v-if="links.previous" @click.prevent="applyPage('previous')">
					<i class="mi-angle-left"></i>
				</a>
				<a v-else class="disabled">
					<i class="mi-angle-left"></i>
				</a>
				</li>
				<li class="paging" v-if="links.previous || links.next">
				<a href="#" v-if="links.next" @click.prevent="applyPage('next')">
					<i class="mi-angle-right"></i>
				</a>
				<a v-else class="disabled">
					<i class="mi-angle-right"></i>
				</a>
				</li>
				<li class="paging paging-last" v-if="links.previous || links.next">
				<a href="#" v-if="links.last" @click.prevent="applyPage('last')">
					<i class="mi-angle-double-right"></i>
				</a>
				<a v-else class="disabled">
					<i class="mi-angle-double-right"></i>
				</a>
				</li>
	
				<li class="pull-right">
				<select class="itemsper" @change="applyItemsPer" v-model="itemsper">
					<option value='25' :selected="itemsper == 25 ? 'selected' : null">25</option>
					<option value='50' :selected="itemsper == 50 ? 'selected' : null">50</option>
					<option value='100' :selected="itemsper == 100 ? 'selected' : null">100</option>
					<option value='9999' :selected="itemsper == 9999 ? 'selected' : null">All</option>
				</select>
				</li>
				<li class="pull-right"><label class="itemsper-label">View in groups of </label></li>
	
			</ul>
			</div>
		`,
		data() {
		},
		methods: {
			applyPage: function(goto) {
				var pageindex = 1;
	
				if(goto == 'last') {
				pageindex = parseInt(fileViewer.response.totalpages);
				}
				else if(goto == 'next') {
				pageindex = parseInt(fileViewer.response.pageindex) + 1;
				}
				else if(goto == 'previous') {
				pageindex = parseInt(fileViewer.response.pageindex) - 1;
				}
	
				this.$root.refresh('',pageindex)
			}
			, applyItemsPer: function() {
			this.$root.itemsper = this.itemsper;
			this.$root.refresh();
			}
		}
	
		});
	
		Vue.component('listmode', {
		props: ['files','folders','foldertree','isDisplayContext','currentFile','settings'],
		template: `
			<div class="listmode-wrapper">
			<table class="mura-table-grid">
				<thead>
				<tr>
					<th class="actions">
					<a v-if="foldertree.length" class="folder-back" href="#" @click.prevent="back()">
						&nbsp;
						<i class="mi-arrow-circle-o-left"></i>
					</a>
					</th>
					<th class="var-width">{{settings.rb.filebrowser_filename}}</th>
					<th>{{settings.rb.filebrowser_size}}</th>
					<th>{{settings.rb.filebrowser_modified}}</th>
				</tr>
				</thead>
				<tbody>
				<tr v-if="files.length==0">
					<td class="actions"></td>
					<td class="var-width">No Results</td>
					<td></td>
					<td></td>
				</tr>
				<tr v-for="(file,index) in files">
					<td class="actions">
						<a href="#" :id="'fileitem-'+index" class="show-actions" @click.prevent="openMenu($event,file,index)"><i class="mi-ellipsis-v"></i></a>
						<div class="actions-menu hide">
							<ul class="actions-list">
							<li class="edit"><a @contextmenu="openMenu($event,file,index)"><i class="mi-pencil"></i>View</a></li>
							</ul>
						</div>
					</td>
					<td class="var-width">
						<a v-if="parseInt(file.isfile)" href="#" @click.prevent="viewFile(file,index)">{{file.fullname}}</a>
						<a v-else href="#" @click.prevent="refresh(file.name)"><i class="mi-folder"></i> {{file.fullname}}</a>
					</td>
					<td>
					<div v-if="parseInt(file.isfile)">
						{{file.size}}kb
					</div>
					
					<div v-else>
						--
					</div>
					</td>
					<td>
						{{file.lastmodifiedshort}}
					</td>
				</tr>
	
				</tbody>
			</table>
			<contextmenu :currentFile="this.$parent.currentFile" :isDisplayContext="this.$root.isDisplayContext" v-if="isDisplayContext" :menux="menux" :menuy="menuy"></contextmenu>
			</div>`,
		data() {
			return {
			menux: 0,
			menuy: 0
			}
		}
		, mounted: function() {
			this.$root.isDisplayContext = 0;
		}
		, methods: {
			refresh: function( directory,index ) {
			this.$root.refresh( directory,index );
			}
			, displayError: function( e ) {
			this.$root.displayError( e );
			}
			,back: function( ) {
			this.$root.back( );
			}
			, viewFile: function( file,index ) {
			this.$root.currentFile = file;
			this.$root.currentIndex = index;
	
			if(this.checkImageType(file,index)) {
				fileViewer.isDisplayWindow = "VIEW";
			}
			else if(this.checkFileEditable(file,index)) {
				fileViewer.editFile(this.successEditFile);
			}
			}
			, successEditFile: function( response ) {
			this.currentFile.content = response.data.content;
			fileViewer.isDisplayWindow = "EDIT";
			}
			, isViewable: function(file,index){
			this.$root.currentFile = file;
			this.$root.currentIndex = index;
			return fileViewer.isViewable();
			}
			, checkFileEditable: function(file,index) {
			this.$root.currentFile = file;
			this.$root.currentIndex = index;
			return fileViewer.checkFileEditable();
			}
			, checkImageType: function(file,index) {
			this.$root.currentFile = file;
			this.$root.currentIndex = index;
			return fileViewer.checkImageType();
			}
			, checkIsFile: function() {
			return fileViewer.checkIsFile();
			}
			,openMenu: function(e,file,index,ref) {
	
			this.$root.isDisplayContext = 0;
	
			var left = Math.floor(document.getElementById('fileitem-'+index).getBoundingClientRect().left);
			var top =  Math.floor(document.getElementById('fileitem-'+index).getBoundingClientRect().top) + window.scrollX-5;
	
			this.$nextTick(function () {
				this.$root.isDisplayContext = 1;
			});
	
			this.$root.isDisplayWindow = '';
			this.$root.currentFile = file;
			this.$root.currentFile.index = index;
			this.$root.currentIndex = index;
			this.menux = left;
			this.menuy = top;
	
			e.preventDefault();
			}
		}
		});
	
		Vue.component('gridmode', {
		props: ['files','folders','foldertree','isDisplayContext','currentFile'],
		template: `
			<div class="gridmode-wrapper">
			<div v-if="foldertree.length" class="fileviewer-item" @click="back()">
				<div class="fileviewer-item-icon">
				<i class="mi-arrow-circle-o-left"></i>
				</div>
				<div class="fileviewer-item-meta">
				<div class="fileviewer-item-label">
					Back
				</div>
				</div>
			</div>
			<div v-for="(file,index) in files">
				<div class="fileviewer-item"  :id="'fileitem-'+index"  v-if="parseInt(file.isfile)">
					<div class="fileviewer-item-image"  @click="viewFile(file,index)">
						<div v-if="parseInt(file.isimage)" class="fileviewer-item-icon" :style="{ 'background-image': 'url(' + encodeURI(file.url) + ')' }"></div>
						<div v-else class="fileviewer-item-icon fileviewer-item-filetype" :class="['fileviewer-item-icon-' + file.type]">{{file.ext}}</div>
					</div>
					<div class="fileviewer-item-meta">
						<div class="fileviewer-item-label">
						{{file.fullname}}
						</div>
						<div class="fileviewer-item-meta-details">
							<div v-if="parseInt(file.isfile)" class="fileviewer-item-meta-size">
								{{file.size}}kb
							</div>
						</div>
						<i :id="'btn-'+index" class="btn mi-ellipsis-v" @click="openMenu($event,file,index)"></i>
					</div>
				</div>
				<div class="fileviewer-item" :id="'fileitem-'+index" v-else>
					<div class="fileviewer-item-icon" @click="refresh(file.name)">
						<i class="mi-folder-open"></i>
					</div>
					<div class="fileviewer-item-meta">
						<div class="fileviewer-item-label">
						{{file.fullname}}
						</div>
						<div class="fileviewer-item-meta-details">
							<div v-if="parseInt(file.isfile)" class="fileviewer-item-meta-size">
								{{file.size}}kb
							</div>
						</div>
						<i :id="'btn-'+index" class="btn mi-ellipsis-v" @click="openMenu($event,file,index)"></i>
					</div>
				</div>
			</div>
			<div class="clearfix"></div>
			<contextmenu :currentFile="this.$parent.currentFile" :isDisplayContext="isDisplayContext" v-if="isDisplayContext" :menux="menux" :menuy="menuy"></contextmenu>
			</div>`,
		data() {
			return {
				menux: 0,
				menuy: 0,
				offsetx: 0,
				offsety: 0
			}
		}
		, mounted: function() {
			this.$root.isDisplayContext = 0;
		}
		, methods: {
			refresh: function( directory,index ) {
			this.$root.refresh( directory,index );
			}
			,back: function( ) {
			this.$root.back( );
			}
			, viewFile: function(file,index) {
				this.$root.currentFile = file;
				this.$root.currentIndex = index;
				if(parseInt(file.isimage)) {
					fileViewer.isDisplayWindow = "VIEW";
					fileViewer.viewFile();
				}
				else {
					this.openMenu(null,file,index);
				}
			}
			,openMenu: function(e,file,index) {
				window.index    = index;
				window.gridMode = true;
		
				// gridmode

				var oLeft = 135;
				var oTop = -3;
		
				// offset positioning relative to parent
				if (document.getElementById('MasaBrowserContainer')){
					// is a modal
					if (document.getElementById('MasaBrowserContainer').parentNode == document.getElementById('alertDialogMessage')){
						oTop += 57;
						oLeft += Math.floor(document.getElementById('MasaBrowserContainer').getBoundingClientRect().left);
					}
				}

				var menuEl = document.getElementById('btn-'+index);
				var menuleft = Math.floor(menuEl.getBoundingClientRect().left);
				var menutop = Math.floor(menuEl.getBoundingClientRect().top);
				var menuheight = 170;

				if(!parseInt(file.isfile)) {
					menuheight = 50;
				}
				else if(!parseInt(!file.isimage)) {
					menuheight = 108;
				}


				this.menux = menuleft - 20 - oLeft;
				this.menuy = menutop - oTop;
				this.bottom = window.innerHeight;

				if(this.menuy+menuheight+25 > this.bottom) {
					this.menuy -= menuheight+7;
				}
		
				this.$root.currentFile = file;
				this.$root.currentIndex = index;
				
				this.$root.isDisplayContext = 0;
		
				this.$nextTick(function () {
					this.$root.isDisplayContext = 1;
				})
		
				this.$root.isDisplayWindow = '';
				this.$root.currentFile = file;
				this.$root.currentFile.index = index;
				this.$root.currentIndex = index;
				if(e != null) {
					e.preventDefault();
				}
			}
		}
		});
	
		Vue.component('filewindow', {
		props: ['files','folders','foldertree','isDisplayContext','currentFile','settings','displaymode'],
		template: `
			<div class="filewindow-wrapper">
			<gridmode v-if="displaymode==1" :currentFile="currentFile" :foldertree="foldertree" :files="files" :folders="folders" :isDisplayContext="isDisplayContext"></gridmode>
			<listmode  v-if="displaymode==2" :settings="settings" :currentFile="currentFile" :foldertree="foldertree" :files="files" :folders="folders" :isDisplayContext="isDisplayContext"></listmode>
			</div>`,
		data() {
			return {};
		},
		methods: {
	
		}
		});
	
		Vue.component('spinner', {
		template: `
			<div id="spinner">
	
			</div>`,
		data() {
			return {};
		}
		, mounted: function() {
			$("#spinner").spin(spinnerArgs);
		}
		, destroyed:  function() {
			$("#spinner").spin(!1);
		}
		, methods: {
	
		}
		});
	
		const IS_START = 0, IS_SAVE = 1, IS_SUCCESS = 2, IS_FAIL = 3;
	
		var fileViewer = new Vue({
		el: "#" + self.target,
		template: `
			<div class="fileviewer-wrapper">
			<spinner v-if="spinnermodal"></spinner>
			<div v-if="message" class="alert alert-error">
				<span>
				{{message}}
				</span>
			</div>
			<gallerywindow v-if="isDisplayWindow=='VIEW'" :settings="settings" :currentFile="currentFile" :currentIndex="currentIndex"></gallerywindow>
			<imageeditwindow v-if="isDisplayWindow=='EDITIMAGE'" :settings="settings" :currentFile="currentFile" :currentIndex="currentIndex"></imageeditwindow>
			<actionwindow v-if="isDisplayWindow" :settings="settings" :isDisplayWindow="isDisplayWindow" :currentIndex="currentIndex" :foldertree="foldertree" :currentFile="currentFile" :error="error"></actionwindow>
			<div class="mura-header">
				<ul class="breadcrumb">
				<li @click="setDirDepth(-1)"><a><i class="mi-home"></i>{{resourcepath}}</a></li>
				<li v-for="(item,index) in foldertree" @click="setDirDepth(index)"><a><i class="mi-folder-open"></i>{{item}}</a></li>
				</ul>
			</div>
			<div class="mura-header" id="fileviewer-message" v-if="isErrorMessage">
				<div class="alert alert-error">
					<span v-html="renderer(this.errorMessage)"></span>
				</div>	
			</div>
			<div class="fileviewer-droptarget">
				<form enctype="multipart/form-data" novalidate v-if="isStart || isSave">
				<input type="file" multiple :name="uploadField" :disabled="isSave" @change="filesChanged($event.target.name, $event.target.files);" accept="*.*" class="file-input-field">
				<p v-if="isStart" class="upload-icon">
					{{settings.rb.filebrowser_draghere}}
				</p>
				<p v-if="isSave" class="download-icon">
					{{settings.rb.filebrowser_uploading}} ({{fileCount}})
				</p>
				</form>
			</div>
			<appbar v-if="response.links" :settings="settings" :location=1 :links="response.links" :itemsper="itemsper" :response="response"></appbar>
			<filewindow :settings="settings" :currentFile="currentFile" :isDisplayContext="isDisplayContext" :foldertree="foldertree" :files="files" :folders="folders" :displaymode="displaymode"></filewindow>
			<appbar v-if="response.links" :settings="settings" :location=0 :links="response.links" :itemsper="itemsper" :response="response"></appbar>
			</div>`
		,
		data: {
			currentView: 'fileviewer',
			currentState: null,
			currentFile: null,
			currentIndex: 0,
			foldertree: [],
			fileCount: 0,
			rootpath: '',
			files: [],
			folders: [],
			spinnermodal: 0,
			error: "",
			settings: { rb: {} },
			displaymode: this.config.displaymode,
			uploadedFiles: [],
			isDisplayContext: 0,
			isErrorMessage: 0,
			errorMessage: '',
			isDisplayWindow: '',
			uploadField: "uploadFiles",
			filterResults: '',
			sortOn: '',
			sortDir: 'ASC',
			itemsper: 25,
			message: '',
			editfilelist: self.editfilelist,
			resourcepath: this.config.resourcepath.replace('_',' '),
			response: {pageindex: 0}
		},
		ready: function() {
		},
		computed: {
			isStart() {
			return this.currentState === IS_START;
			},
			isSave() {
			return this.currentState === IS_SAVE;
			},
			isSuccess() {
			return this.currentState === IS_SUCCESS;
			},
			isonError() {
			return this.currentState === IS_FAIL;
			}
		},
		methods: {
			renderer(val) {
				return val;
			},
			updateDelete: function() {
				self.updateDelete(currentFile);
			}
			, updateContent: function( content ) {
			var dir = "";
	
			for(var i=0;i<this.foldertree.length;i++) {
				dir = dir + "/" + this.foldertree[i];
			}
	
			self.doUpdateContent( dir,this.currentFile,content,this.refresh );
			}
			, renameFile: function() {
			var dir = "";
	
			for(var i=0;i<this.foldertree.length;i++) {
				dir = dir + "/" + this.foldertree[i];
			}
	
				self.doRenameFile( dir,this.currentFile,this.refresh );
			}
			, newFolder: function(foldername) {
			var dir = "";
	
			for(var i=0;i<this.foldertree.length;i++) {
				dir = dir + "/" + this.foldertree[i];
			}
			self.doNewFolder( dir,foldername,this.refresh );
			}
			, updateEdit: function() {
				self.updateEdit(currentFile);
			}
			, displayResults: function(resp) {
				var self = this;
				this.response = resp.data;

				//folder requested does not exist
				if(parseInt(this.response.dne) == 1) {
					console.log("Requested folder does not not exist; resetting folder tree to root");
					this.foldertree = [];
					var fdata = {
						foldertree: []
					}
					Mura.createCookie( 'fbFolderTree',JSON.stringify(fdata),1);
					this.$nextTick(function () {
						self.refresh();
					});
				}
				MuraFileBrowser.rootpath = this.response.rootpath;
				this.files = this.response.items;
				this.folders = this.response.folders;
		
				if(this.response.settings) {
					this.settings = this.response.settings;
				}
				this.$nextTick(function () {
					this.spinnermodal = 0;
				});
	
			}
			, displayError: function( e ) {
			if(e && e.message) {
				this.message = e.message;
			}
			}
			, previousFile( img ) {
			img = img ? img : 0;
			index = this.currentIndex;
	
			index--;
	
			if(index+1 <= 0) {
				return;
			}
	
			if(!parseInt(this.files[index].isfile)) {
				return;
			}
	
			if(img && this.checkImageType() || !img) {
				this.currentFile = this.files[index];
				this.currentIndex = index;
	
				return;
			}
			else {
				this.previousFile(img);
			}
	
			}
			, nextFile( img ) {
			img = img ? img : 0;
			index = this.currentIndex;
	
			index++;
	
			if(index >= this.files.length) {
				return;
			}
	
			if(img && this.checkImageType() || !img) {
				this.currentFile = this.files[index];
				this.currentIndex = index;
				return;
			}
			else {
				this.nextFile(img);
			}
			}
			, upload: function() {
			}
			, uploadReset() {
			this.currentState = IS_START;
			this.uploadedFiles = [];
			this.error = null;
			}
			, setDirDepth: function( depth ) {
				this.foldertree = this.foldertree.slice(0,depth+1);
				this.refresh();
			}
			, editFile: function( onSuccess,onError ) {
			var dir = "";
	
			for(var i=0;i<this.foldertree.length;i++) {
				dir = dir + "/" + this.foldertree[i];
			}
	
			self.getEditFile(dir,this.currentFile,onSuccess);
	
			}
			, viewFile: function( direction ) {
			}
			, deleteFile: function( onSuccess, onError) {
			var dir = "";
	
			for(var i=0;i<this.foldertree.length;i++) {
				dir = dir + "/" + this.foldertree[i];
			}
	
			self.doDeleteFile(dir,this.currentFile,onSuccess,onError);
	
			}
			, duplicateFile: function( onSuccess, onError) {
			var dir = "";
	
			for(var i=0;i<this.foldertree.length;i++) {
				dir = dir + "/" + this.foldertree[i];
			}
	
			self.doDuplicateFile(dir,this.currentFile,onSuccess,onError);
	
			}
			, refresh: function( folder,pageindex,displaywindow ) {
				this.spinnermodal = 0;
				if(this.isErrorMessage==1) {
					this.isErrorMessage=2;
				}
				else if(this.isErrorMessage==2) {
					this.isErrorMessage=0;
					this.errorMessage = "";			
				}

				if(displaywindow) {
					this.isDisplayWindow = "";
					this.$nextTick(function () {
					this.$root.isDisplayWindow = displaywindow;
				});
			}
			else
				this.isDisplayWindow = '';
	
			if(folder && folder.length)
				this.foldertree.push(folder);
	
			var dir = "";
	
			isNaN(pageindex) ? 0 : pageindex;
	
			for(var i=0;i<this.foldertree.length;i++) {
				dir = dir + "/" + this.foldertree[i];
			}
			this.isDisplayContext = "";
			this.spinnermodal = 1;
	
			var fdata = {
				foldertree: JSON.parse(JSON.stringify(this.foldertree))
			}
	
			Mura.createCookie( 'fbFolderTree',JSON.stringify(fdata),1);
	
			self.loadDirectory(dir,pageindex,this.displayResults,this.displayError,this.filterResults,this.sortOn,this.sortDir,this.itemsper,displaywindow);
			}
			, back: function() {
			this.foldertree.splice(-1);
			var folder = this.foldertree.length ? "" : this.foldertree[this.foldertree.length-1];
			this.refresh();
			}
			, closeMenu: function( e ) {
			this.isDisplayContext = 0;
			e.preventDefault();
			}
			, filesChanged: function(fieldName, fileList) {
			// handle file changes
	
			this.uploadedFiles = fileList;
	
			const formData = new FormData();
	
			var dir = "";
	
			if (!fileList.length) return;
	
			// append the files to FormData
	
			this.fileCount = fileList.length;
	
			Array
				.from(Array(fileList.length).keys())
				.map(x => {
				formData.append(fieldName, fileList[x], fileList[x].name);
				});
	
			for(var i=0;i<this.foldertree.length;i++) {
				dir = dir + "/" + this.foldertree[i];
			}
	
			formData.append("directory",dir);
	
			// save it
			this.save(formData);
			}
			, save: function( formData ) {
				this.currentState = IS_SAVE;
				self.doUpload( formData,this.saveComplete );
			}
			, saveComplete: function(resp) {
				console.log("SAVED",resp);
				if(resp.failed && resp.failed.length) {
					this.isErrorMessage = 1;
					this.errorMessage = "<ul>";
					for(var e = 0;e<resp.failed.length;e++) {
						this.errorMessage += "<li><strong>" + resp.failed[e].clientfile + ":</strong> "  + resp.failed[e].message + "</li>";
					}
					this.errorMessage += "</ul>";
				}

				this.uploadReset();
				this.refresh();
			}
			, checkSelectMode: function() {
			return MuraFileBrowser.config.selectMode;
			}
			, isViewable: function() {
				var editlist = this.settings.editfilelist.split(",");
				var imagelist = this.settings.imagelist.split(",");
				for(var i = 0;i<editlist.length;i++) {
				if(this.currentFile.ext.toLowerCase() == editlist[i]) {
					return true;
				}
				}
				for(var i = 0;i<imagelist.length;i++) {
				if(this.currentFile.ext.toLowerCase() == imagelist[i]) {
					return true;
				}
				}
				return false;
			}
			, checkFileEditable: function() {
			var editlist = this.settings.editfilelist.split(",");
	
			for(var i = 0;i<editlist.length;i++) {
				if(this.currentFile.ext.toLowerCase() == editlist[i]) {
				return true;
				}
			}
			return false;
			}
			, checkImageType: function() {
			var imagelist = this.settings.imagelist.split(",");
				for(var i = 0;i<imagelist.length;i++) {
				if(this.currentFile.ext.toLowerCase() == imagelist[i]) {
					return true;
				}
				}
				return false;
			}
			, checkIsFile: function() {
	
			if(Math.floor(this.currentFile.isfile)) {
				return true;
			}
			return false;
			}
		},
		mounted: function() {
			this.uploadReset();
			this.$nextTick(function () {
				this.spinnermodal = 1;
			});
			this.selectMode = self.config.selectMode;
	// folder cookie
	
			var dir = "";
	
			var cFolder = Mura.readCookie( 'fbFolderTree');
			if(cFolder) {
				var cFolderJSON = JSON.parse(cFolder);
	
				if(cFolderJSON.foldertree) {
				this.$root.foldertree = cFolderJSON.foldertree;
	
				for(var i=0;i<this.foldertree.length;i++) {
					dir = dir + "/" + this.foldertree[i];
				}
	
				}
			}
	
	// displaymode cookie
			var cDisplay = Mura.readCookie( 'fbDisplayMode' );
	
			if(cDisplay) {
				var decodedDisplay = decodeURIComponent(cDisplay);
		        var fbDisplayJSON = JSON.parse(decodedDisplay);
        
				if(fbDisplayJSON.displaymode)
				this.$root.displaymode = this.viewmode = fbDisplayJSON.displaymode;
	
			}
	
			self.loadBaseDirectory(this.displayResults,this.displayError,dir);
	
			window.addEventListener('mouseup', function(event) {
	//        fileViewer.isDisplayContext = 0;
			});
			var vm = this;
		}
		});
	}
	
	};
	
