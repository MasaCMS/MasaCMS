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
  this.container = Mura("#MuraFileBrowserContainer");
  this.container.append("<div id='" + target + "'><component :is='currentView'></component></div>");
  this.target = target;
  this.main(); // Delegating to main()
  Mura.loader()
    .loadcss(Mura.corepath + '/vendor/codemirror/codemirror.css')
    .loadjs(
      Mura.adminpath + '/assets/js/vue.min.js',
      Mura.corepath + '/vendor/codemirror/codemirror.js',
      // Mura.corepath + '/vendor/codemirror/addon/formatting/formatting.js',
      // Mura.corepath + '/vendor/codemirror/mode/htmlmixed/htmlmixed.js',
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

  if(!this.validate()) {
    return error("No Access");
  }

  Mura.get( baseurl )
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

, doDuplicateFile: function( directory,currentFile,onSuccess,onError) {
  var dir = directory == undefined ? "" : directory;
  var baseurl = this.endpoint + "/duplicate?directory=" + dir + "&resourcepath=" + this.config.resourcepath;

  if(!this.validate()) {
    return error("No Access");
  }

  var formData = {};
  formData.file = currentFile;

  Mura.post( baseurl,formData )
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

, doUpdateContent: function( directory,currentFile,content,onSuccess,onError) {
  var dir = directory == undefined ? "" : directory;
  var baseurl = this.endpoint + "/update?directory=" + dir + "&filename=" + currentFile.fullname + "&resourcepath=" + this.config.resourcepath;

  if(!this.validate()) {
    return error("No Access");
  }

  Mura.post( baseurl,{content: content} )
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

, doRenameFile: function( directory,currentFile,onSuccess,onError) {
  var dir = directory == undefined ? "" : directory;
  var baseurl = this.endpoint + "/rename?directory=" + dir + "&filename=" + currentFile.fullname + "&name=" + currentFile.name + "&resourcepath=" + this.config.resourcepath;

  if(!this.validate()) {
    return error("No Access");
  }

  Mura.get( baseurl )
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

, doNewFolder: function( directory,newfolder,onSuccess ) {
  var dir = directory == undefined ? "" : directory;
  var baseurl = this.endpoint + "/addfolder?directory=" + dir + "&name=" + newfolder + "&resourcepath=" + this.config.resourcepath;

  if(!this.validate()) {
    return error("No Access");
  }

  Mura.get( baseurl )
    .then(
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
    .then(
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

, loadBaseDirectory: function( onSuccess,onError ) {
  var self = this;
  var baseurl = this.endpoint + "/browse" + "?resourcepath=" + this.config.resourcepath + "&directory=" + this.config.directory + "&settings=1";

  if(!this.validate()) {
    return error("No Access");
  }

  Mura.get( baseurl )
    .then(
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
  var self = this;
  var baseurl = this.endpoint + "/upload" + "?resourcepath=" + this.config.resourcepath;

  if(!this.validate()) {
    return error("No Access");
  }

  Mura.post( baseurl,formData )
    .then(
      function doSuccess( response ) {
        success( response );
      },
      function doonError( response ) {
        this.onError(response);
      }
    );
}
, rotate: function( currentFile,direction,success,error) {
  var self = this;
  var baseurl = this.endpoint + "rotate" + "?resourcepath=" + this.config.resourcepath;

  if(!this.validate()) {
    return error("No Access");
  }

  var formData = {};

  formData.file = JSON.parse(JSON.stringify(currentFile));
  formData.direction = direction;

  Mura.post( baseurl,formData )
    .then(
      function doSuccess( response ) {
        success( response );
      },
      function doonError( response ) {
        this.onError(response);
      }
    );

}

, performResize: function( currentFile,dimensions,success,error ) {
  var self = this;
  var baseurl = this.endpoint + "resize" + "?resourcepath=" + this.config.resourcepath;

  if(!this.validate()) {
    return error("No Access");
  }

  var formData = {};

  formData.file = JSON.parse(JSON.stringify(currentFile));
  formData.dimensions = dimensions;

  Mura.post( baseurl,formData )
    .then(
      function doSuccess( response ) {
        success( response );
      },
      function doonError( response ) {
        this.onError(response);
      }
    );
}

, performCrop: function( currentFile,success,error ) {
  var self = this;
  var baseurl = this.endpoint + "processCrop" + "?resourcepath=" + this.config.resourcepath;

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

  crop.x = cropRect.offsetLeft;
  crop.y = cropRect.offsetTop;
  crop.width = rect.width;
  crop.height = rect.height;

  formData.file = JSON.parse(JSON.stringify(currentFile));
  formData.crop = crop;
  formData.size = size;

  Mura.post( baseurl,formData )
    .then(
      function doSuccess( response ) {
        success( response );
      },
      function doonError( response ) {
        this.onError(response);
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
            corners.x = e.offsetX + e.target.offsetLeft;
            corners.y = e.offsetY + e.target.offsetTop;
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
    props: ["currentFile","menuy","menux"],
    template: `
    <div id="newContentMenu" class="addNew" v-bind:style="{ left: (menux + 20) + 'px',top: menuy + 'px' }">
        <ul id="newContentOptions">
          <li v-if="checkIsFile() && checkSelectMode()"><a href="#" @click.prevent="selectFile()"><i class="mi-check"> Select</i></a></li>
          <li v-if="checkIsFile() && checkFileEditable()"><a href="#" @click.prevent="editFile()"><i class="mi-pencil"> Edit</i></a></li>
          <li v-if="checkIsFile() && checkImageType()"><a href="#" @click.prevent="viewFile()"><i class="mi-image"> View</i></a></li>
          <li v-if="checkIsFile() && checkImageType()"><a @click.prevent="duplicateFile()"><i class="mi-copy"> Duplicate</i></a></li>
          <li><a href="#" @click.prevent="renameFile()"><i class="mi-edit"> Rename</i></a></li>
          <li v-if="checkIsFile()"><a href="#" @click="downloadFile()"><i class="mi-download"> Download</i></a></li>
          <li><a href="#" @click="deleteFile()"><i class="mi-trash"> Delete</i></a></li>
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

     , selectFile: function() {
        if(MuraFileBrowser.config.selectMode == 1) {
          window.opener.CKEDITOR.tools.callFunction(self.callback,fileViewer.currentFile.url);
          window.close();
        }
        else {
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
    props: ["isDisplayWindow","currentFile","currentIndex","error"],
    template: `
      <div id="actionwindow-wrapper">
        <editwindow v-if="isDisplayWindow=='EDIT'" :currentFile="currentFile"></editwindow>
        <renamewindow v-if="isDisplayWindow=='RENAME'" :currentFile="currentFile"></renamewindow>
        <addfolderwindow v-if="isDisplayWindow=='ADDFOLDER'" :currentFile="currentFile"></addfolderwindow>
        <downloadwindow v-if="isDisplayWindow=='DOWNLOAD'" :currentFile="currentFile"></downloadwindow>
        <deletewindow v-if="isDisplayWindow=='DELETE'" :currentFile="currentFile"></deletewindow>
        <errorwindow v-if="isDisplayWindow=='ERROR'" :currentFile="currentFile" :error="error"></errorwindow>
      </div>
    `,
    data() {
        return {};
    },
    methods: {
    }
  });

  Vue.component('renamewindow', {
    props: ["currentFile"],
    template: `
      <div class="actionwindow-formwrapper">
        <div>
          <h3>Rename</h3>
          <label>
            Name:
            <input v-model="filename"></input>
          </label>
        </div>
        <div>
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
      <div class="actionwindow-formwrapper">
        <div>
          <h3>Error</h3>
          <h4>{{error}}</h4>
        </div>
        <div>
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
      <div class="actionwindow-formwrapper">
        <div>
          <h3>Add Folder</h3>
          <label>
            Name:
            <input v-model="foldername"></input>
          </label>
        </div>
        <div>
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
          <div class="fileviewer-image" :style="{ 'background-image': 'url(' + encodeURI(currentFile.url) + ')' }"></div>
            <div>
              <div class="actionwindow-left" @click="lastimage"><i class="mi-caret-left"></i></div>
              <div class="actionwindow-right" @click="nextimage"><i class="mi-caret-right"></i></div>
              <div class="fileviewer-gallery-menu">
                <ul>
                  <li v-if="checkImageType() && checkSelectMode()"><a @click="selectFile()"><i class="mi-check"> Select</i></a></li>
                <li v-if="checkImageType()"><a @click="editImage()"><i class="mi-check"> Edit Image</i></a></li>
                  <li v-if="checkFileEditable()"><a  @click="editFile()"><i class="mi-pencil"> Edit</i></a></li>
                  <li><a @click="renameFile()"><i class="mi-edit"> Rename</i></a></li>
                  <li v-if="checkIsFile()"><a @click="downloadFile()"><i class="mi-download">Download</i></a></li>
                  <li><a @click="deleteFile()"><i class="mi-trash"> Delete</i></a></li>
                  <li><a @click="closewindow()"><i class="mi-times">Close</i></a></li>
                </ul>
              <p>{{currentFile.fullname}} ({{currentFile.size}}k <span v-if="checkImageType()">{{currentFile.info.width}}x{{currentFile.info.height}}</span>)</p>
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
        <div class="fileviewer-image" id="imagediv" :style="{ 'background-image': 'url(' + encodeURI(currentFile.url) + ')' }"></div>
        <div>
          <div class="fileviewer-gallery-menu">
            <ul>
              <!--- MAIN --->
              <span v-if="editmode==''">
                <li><a @click="crop()"><i class="mi-crop"> Crop</i></a></li>
                <li><a @click="rotateRight()"><i class="mi-rotate-right"> Rotate Right</i></a></li>
                <li><a @click="rotateLeft()"><i class="mi-rotate-left"> Rotate Left</i></a></li>
                <li><a @click="resize()"><i class="mi-expand"> Resize</i></a></li>
                <li><a @click="cancel()"><i class="mi-times"> Cancel</i></a></li>
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
            <p>{{currentFile.fullname}} ({{currentFile.size}}k {{currentFile.info.width}}x{{currentFile.info.height}})</p>
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
      <div class="actionwindow-formwrapper">
        <h3>Delete</h3>
        <label>
          <p>Confirm Deletion: {{currentFile.fullname}}</p>
          <button @click="doDelete()">Delete</button>
          <button @click="cancel()">Cancel</button>
        </label>
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
      <div class="actionwindow-formwrapper">
        <h3>Edit</h3>
        <label>
          <textarea id="contenteditfield" class="editwindow" v-model="filecontent" style="width: 400">abba</textarea>
          <button @click="updateContent()">Update</button>
          <button @click="cancel()">Cancel</button>
        </label>
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
        editor.setCursor(0,0);
        CodeMirror.commands["selectAll"](editor);
        editor.autoFormatRange(editor.getCursor(true), editor.getCursor(false));
        editor.setSize(500, 500);
        editor.setCursor(0,0);
      }
    }
    , mounted: function() {
      this.filecontent = this.currentFile.content;
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
            <label class="btn btn-secondary" v-bind:class="{ highlight: viewmode == 1 }" @click="switchMode(1)">
              <i class="mi-th" title="Grid View"></i>
            </label>
            <label class="btn btn-secondary" v-bind:class="{ highlight: viewmode == 2 }" @click="switchMode(2)">
              <i class="mi-bars" title="List View"></i>
            </label>
          </div>
          <label @click="newFolder" class="btn btn-secondary">
            <i class="mi-folder" title="Add Folder"></i>
          </label>
          <input v-model="filterResults" v-on:input="filterChange">
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
    props: ["links","isbottomnav","response"],
    template: `
        <div class="filewindow-navmenu">
          <p v-if="isbottomnav">
          {{response.pageindex}} of {{response.totalpages}} <!-- ({{response.totalitems}}) includes folders -->
          </p>
        <ul class="pagination">
          <li><a href="#" v-if="links.first" @click.prevent="applyPage('first')">
            <i class="mi-angle-double-left"></i>
          </a></li>
          <li><a href="#" v-if="links.previous" @click.prevent="applyPage('previous')">
            <i class="mi-angle-left"></i>
          </a></li>
          <li><a href="#" v-if="links.next" @click.prevent="applyPage('next')">
            <i class="mi-angle-right"></i>
          </a></li>
          <li><a href="#" v-if="links.last" @click.prevent="applyPage('last')">
            <i class="mi-angle-double-right"></i>
          </a></li>

          <li class="pull-right">
            <select name="itemsper" class="itemsper" @change="applyItemsPer" v-model="itemsper">
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
        return {itemsper:this.$root.itemsper};
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
        this.$root.refresh('',1)
      }
    }

  });

  Vue.component('listmode', {
    props: ['files','folders','foldertree','isDisplayContext','currentFile','settings'],
    template: `
      <div class="listmode-wrapper">
        <table class="mura-table-grid">
          <tbody>
            <tr>
              <th class="actions"></th>

              <th class="var-width">{{settings.rb.filebrowser_filename}}</th>
              <th>{{settings.rb.filebrowser_size}}</th>
              <th>{{settings.rb.filebrowser_modified}}</th>
            </tr>
            <tr v-if="foldertree.length">
              <td>
                <a href="#" @click.prevent="back()">
                  &nbsp;
                  <i class="mi-arrow-up"></i>
                </a>
              </td>
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
              <td class="var-width" v-if="parseInt(file.isfile)">
                <a href="#" @click.prevent="viewFile(file,index)">{{file.fullname}}</a>
              </td>
              <td v-else class="var-width">
                <a href="#" @click.prevent="refresh(file.name)"><i class="mi-folder"></i> {{file.fullname}}</a>
              </td>
              <td>
                <i v-if="parseInt(file.isfile)">
                  {{file.size}}K
                </i>
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

        if(this.$root.contextListener) {
        }

        var left = Math.floor(document.getElementById('fileitem-'+index).getBoundingClientRect().left) - 26;
        var top =  Math.floor(document.getElementById('fileitem-'+index).getBoundingClientRect().top) + window.scrollX;

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
          <div class="fileviewer-item"  :id="'fileitem-'+index"  v-if="parseInt(file.isfile)" @click="openMenu($event,file,index)">
            <div class="fileviewer-item-image">
              <div v-if="0" class="fileviewer-item-icon" :class="['fileviewer-item-icon-' + file.type]"></div>
              <div v-else class="fileviewer-item-icon" :style="{ 'background-image': 'url(' + encodeURI(file.url) + ')' }"></div>
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
            </div>
          </div>
          <div class="fileviewer-item" v-else @click="refresh(file.name)">
            <div class="fileviewer-item-icon">
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
    , methods: {
      refresh: function( directory,index ) {
        this.$root.refresh( directory,index );
      }
      ,back: function( ) {
        this.$root.back( );
      }
      ,openMenu: function(e,file,index) {
        this.menux = Math.floor(document.getElementById('fileitem-'+index).getBoundingClientRect().left)+5;
        this.menuy =  Math.floor(document.getElementById('fileitem-'+index).getBoundingClientRect().top)+10 + window.scrollX;

        this.$root.currentFile = file;
        this.$root.currentIndex = index;

        this.$nextTick(function () {
          this.$root.isDisplayContext = 1;
        })

        this.$root.isDisplayWindow = '';
        this.$root.currentFile = file;
        this.$root.currentFile.index = index;
        this.$root.currentIndex = index;

        e.preventDefault();
      }
    }
  });

  Vue.component('filewindow', {
    props: ['files','folders','foldertree','isDisplayContext','currentFile','settings','displaymode'],
    template: `
      <div class="filewindow-wrapper">
        <gridmode v-if="displaymode==1" :currentFile="currentFile"   :foldertree="foldertree" :files="files" :folders="folders" :isDisplayContext="isDisplayContext"></gridmode>
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
        <i class="fa fa-spinner fa-spin"></i>
      </div>`,
    data() {
      return {};
    },
    methods: {

    }
  });

  const IS_START = 0, IS_SAVE = 1, IS_SUCCESS = 2, IS_FAIL = 3;

  var fileViewer = new Vue({
    el: "#" + self.target,
    template: `
      <div class="fileviewer-wrapper">
        <spinner v-if="spinnermodal"></spinner>
        {{message}}
        <gallerywindow v-if="isDisplayWindow=='VIEW'" :settings="settings" :currentFile="currentFile" :currentIndex="currentIndex"></gallerywindow>
        <imageeditwindow v-if="isDisplayWindow=='EDITIMAGE'" :settings="settings" :currentFile="currentFile" :currentIndex="currentIndex"></imageeditwindow>
        <actionwindow v-if="isDisplayWindow" :settings="settings" :isDisplayWindow="isDisplayWindow" :currentIndex="currentIndex" :currentFile="currentFile" :error="error"></actionwindow>
        <div class="mura-header">
          <ul class="breadcrumb">
            <li @click="setDirDepth(-1)"><a><i class="mi-home"></i>{{resourcepath}}</a></li>
            <li v-for="(item,index) in foldertree" @click="setDirDepth(index)"><a><i class="mi-folder-open"></i>{{item}}</a></li>
          </ul>
        </div>  
        <div class="fileviewer-droptarget">
          <form enctype="multipart/form-data" novalidate v-if="isStart || isSave">
            <input type="file" multiple :name="uploadField" :disabled="isSave" @change="filesChanged($event.target.name, $event.target.files);" accept="*.*" class="file-input-field">
            <p v-if="isStart" class="upload-icon">
              {{settings.rb.filebrowser_draghere}}
            </>
            <p v-if="isSave" class="download-icon">
              {{settings.rb.filebrowser_uploading}} ({{fileCount}})
              <ul class="fileviewer-uploadedfiles">
                <li v-for="file in uploadedFiles">
                  {{file.fullname}} ({{Math.floor(file.size/1000)}}kb)
                </li>
              </ul>
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
      files: [],
      folders: [],
      spinnermodal: 0,
      error: "",
      settings: { rb: {} },
      displaymode: this.config.displaymode,
      uploadedFiles: [],
      isDisplayContext: 0,
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
      , displayResults: function(response) {
        this.response = response.data;
        this.files = response.data.items;
        this.folders = response.data.folders;

        if(response.data.settings) {
          this.settings = response.data.settings;
        }
        this.$nextTick(function () {
          this.spinnermodal = 0;
        });

      }
      , displayError: function( e ) {
        if(e.message) {
          this.message = message;
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
      , saveComplete: function( ) {
        this.uploadReset();
        this.refresh();
      }
      , checkSelectMode: function() {
        return MuraFileBrowser.config.selectMode;
      }
      , isViewable: function() {
          var editlist = this.settings.editfilelist;
          var imagelist = this.settings.imagelist;
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
        var editlist = this.settings.editfilelist;

        for(var i = 0;i<editlist.length;i++) {
          if(this.currentFile.ext.toLowerCase() == editlist[i]) {
            return true;
          }
        }
        return false;
      }
      , checkImageType: function() {
        var imagelist = this.settings.imagelist;
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
        self.loadBaseDirectory(this.displayResults,this.displayError);
        window.addEventListener('mouseup', function(event) {
//        fileViewer.isDisplayContext = 0;
        });
        var vm = this;
    }
  });
}

};