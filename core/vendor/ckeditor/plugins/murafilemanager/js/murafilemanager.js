// objectparams are available under 'this.context.{yourVar}'
MuraFilemanager = {
// Mura invokes this method by default
render: function() {

  var self = this;
  var target =  "_" + Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);

  this.webRoot = "http://localhost:8050/index.cfm/_api/json/v1/default/muraFileBrowser";
  this.editfilelist = ["txt","cfm"];
  this.imagelist = ["gif","jpg","jpeg","png"];

  this.container = Mura("#MuraFileManagerContainer");
  this.container.append("<div id='" + target + "'><component :is='currentView'></component></div>");
  this.target = target;

  this.main(); // Delegating to main()

  Mura.loader()
    .loadjs(
      '/core/modules/v1/vuefm/assets/js/vue.js',
    function() {
      self.mountbrowser();
     } ) ;

     this.getURLVars();
}

, main: function() {
  var self = this;
}

, error: function(msg) {
  console.log( msg );
}

, getURLVars: function() {
    var vars = {};
    console.log(window.location.href);
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });

    console.log(vars['CKEditorFuncNum']);

    this.callback = vars['CKEditorFuncNum'];
}

, validate: function() {
  return true;
}

, getEditFile: function( directory,currentFile,onSuccess) {
  var dir = directory == undefined ? "" : directory;
  var baseurl = this.webRoot + "/edit?directory=" + dir + "&filename=" + currentFile.fullname;

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
        self.fail(response);
      }
    );
}


, doDeleteFile: function( directory,currentFile,onSuccess) {
  var dir = directory == undefined ? "" : directory;
  var baseurl = this.webRoot + "/delete?directory=" + dir + "&filename=" + currentFile.fullname;

  if(!this.validate()) {
    return error("No Access");
  }

  Mura.get( baseurl )
    .then(
      //success
      function(response) {
        console.log("BOOM");
        console.log(response);
        onSuccess(response);
      },
      //fail
      function(response) {
        self.fail(response);
      }
    );
}

, doRenameFile: function( directory,currentFile) {
  var dir = directory == undefined ? "" : directory;
  var baseurl = this.webRoot + "/rename?directory=" + dir + "&filename=" + currentFile.fullname + "&name=" + currentFile.name;

  if(!this.validate()) {
    return error("No Access");
  }

  Mura.get( baseurl )
    .then(
      //success
      function(response) {
        console.log("response");
        console.log(response);
      },
      //fail
      function(response) {
        self.fail(response);
      }
    );
}

, loaddirectory: function( directory,pageindex,onSuccess,fail ) {
  var self = this;

  var dir = directory == undefined ? "" : directory;
  var baseurl = this.webRoot + "/browse?directory=" + dir;

  if(!this.validate()) {
    return error("No Access");
  }

  if(pageindex) {
    baseurl += "&pageindex=" + pageindex;
  }

  Mura.get( baseurl )
    .then(
      //success
      function(response) {
        onSuccess(response);
      },
      //fail
      function(response) {
        self.fail(response);
      }
    );
}

, loadBaseDirectory: function( success,fail ) {
  var self = this;
  var baseurl = this.webRoot + "/browse";

  if(!this.validate()) {
    return error("No Access");
  }

  Mura.get( baseurl )
    .then(
      //success
      function(response) {
        success(response);
      },
      //fail
      function(response) {
        self.fail(response);
      }
    );
}

, doUpload: function( formData,success,fail ) {
  var self = this;
  var baseurl = this.webRoot + "/upload";

  if(!this.validate()) {
    return error("No Access");
  }

  Mura.post( baseurl,formData )
    .then(
      function doSuccess( response ) {
        success( response );
      },
      function doFail( response ) {
        console.log( "fail" );
        console.log( response );
      }
    );
}


, mountbrowser: function() {
  var self = this;

  Vue.component('contextmenu', {
    props: ["isDisplayContext","currentFile"],
    template: `
      <div class="filewindow-context">
        <ul>
          <li @click="selectFile()" v-if="checkImageType()"><i class="fa fa-select"> Select</i></li>
          <li><hr noshade></li>
          <li @click="editFile()" v-if="checkFileType()"><i class="fa fa-pencil"> Edit</i></li>
          <li @click="viewFile()" v-if="checkImageType()"><i class="fa fa-image"> View</i></li>
          <li @click="renameFile()"><i class="fa fa-download"> Rename</i></li>
          <li @click="downloadFile()"><i class="fa fa-download"> Download</i></li>
          <li @click="deleteFile()"><i class="fa fa-trash"> Delete</i></li>
        </ul>
      </div>
    `,
    data() {
        return {};
    },
    methods: {
      selectFile: function() {
        console.log(fileViewer.currentFile);
        window.opener.CKEDITOR.tools.callFunction(self.callback,fileViewer.currentFile.image);
        window.close();
      }

      , editFile: function() {
        console.log("EDIT: " + fileViewer.currentFile.name);
        fileViewer.editFile(this.successEditFile);
      }
      , viewFile: function() {
        console.log("View: " + fileViewer.currentFile.name);
        fileViewer.isDisplayWindow = "VIEW";
        fileViewer.viewFile();
      }
      , successEditFile: function( response ) {
        console.log("RESP");
        console.log(response);
        this.currentFile.content = response.data.content;
        fileViewer.isDisplayWindow = "EDIT";
      }
      , renameFile: function() {
        console.log("RENAME: " + fileViewer.currentFile.name);
        fileViewer.isDisplayWindow = "RENAME";
      //  fileViewer.currentFile.name = "JOHN";
      }
      , downloadFile: function() {
        console.log("DOWNLOAD: " + fileViewer.currentFile.name);
        fileViewer.isDisplayWindow = "DOWNLOAD";

      }
      , deleteFile: function() {
        console.log("DELETE: " + fileViewer.currentFile.name);
        fileViewer.isDisplayWindow = "DELETE";
      }
      , checkFileType: function() {
          return fileViewer.checkFileType();
      }
      , checkImageType: function() {
        return fileViewer.checkImageType();
      }
    }

  });

  Vue.component('actionwindow', {
    props: ["isDisplayWindow","currentFile"],
    template: `
      <div id="actionwindow-wrapper">
        <editwindow v-if="isDisplayWindow=='EDIT'" :currentFile="currentFile"></editwindow>
        <viewwindow v-if="isDisplayWindow=='VIEW'" :currentFile="currentFile"></viewwindow>
        <renamewindow v-if="isDisplayWindow=='RENAME'" :currentFile="currentFile"></renamewindow>
        <downloadwindow v-if="isDisplayWindow=='DOWNLOAD'" :currentFile="currentFile"></downloadwindow>
        <deletewindow v-if="isDisplayWindow=='DELETE'" :currentFile="currentFile"></deletewindow>
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
    }
  });

  Vue.component('viewwindow', {
    props: ["currentFile"],
    template: `
      <div class="actionwindow-formwrapper">
        <div>
          <div class="actionwindow-left" @click="lastimage">&lt;</div>
          <div class="actionwindow-right" @click="nextimage">&gt;</div>
        </div>
        <div class="fileviewer-gallery" :style="{ 'background-image': 'url(' + currentFile.image + ')' }"></div>
      </div>
    `,
    data() {
        return {};
    },
    methods: {
      lastimage: function() {
        fileViewer.previousFile(1);
      }
      , nextimage: function() {
        fileViewer.nextFile(1);
      }
    }
  });

  Vue.component('deletewindow', {
    props: ["currentFile"],
    template: `
      <div class="actionwindow-formwrapper">
        <h3>Delete</h3>
        <label>
          <p>Confirm Deletion: {{currentFile.name}}</p>
          <button @click="updateDelete()">Delete</button>
          <button @click="cancel()">Cancel</button>
        </label>
      </div>
    `,
    data() {
        return {};
    },
    methods: {
      updateDelete: function() {
        fileViewer.deleteFile(  fileViewer.refresh);
        fileViewer.isDisplayWindow = '';
      }
      , successDeleteFile: function() {
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
          <textarea class="editwindow" v-model="filecontent"></textarea>
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
        fileViewer.isDisplayWindow = '';
      }
      , cancel: function() {
        fileViewer.isDisplayWindow = '';
      }
    }
    , mounted: function() {
      console.log(this.currentFile);
      this.filecontent = this.currentFile.content;
    }
  });

  Vue.component('navmenu', {
    props: ["links","isbottomnav","response","itemsper"],
    template: `
        <div class="filewindow-navmenu">
          <p v-if="isbottomnav">
          {{response.pageindex}} of {{response.totalpages}} <!-- ({{response.totalitems}}) includes folders -->
          </p>
        <ul class="pagination">
          <li><a v-if="links.first" @click="applyPage('first')">
            <i class="fa fa-angle-double-left"></i>
          </a></li>
          <li><a v-if="links.previous" @click="applyPage('previous')">
            <i class="fa fa-angle-left"></i>
          </a></li>
          <li><a v-if="links.next" @click="applyPage('next')">
            <i class="fa fa-angle-right"></i>
          </a></li>
          <li><a v-if="links.last" @click="applyPage('last')">
            <i class="fa fa-angle-double-right"></i>
          </a></li>

          <li class="pull-right">
            <select name="itemsper" class="itemsper" @change="applyItemsPer" v-model="itemsper">
              <option value='10' :selected="itemsper == 10 ? 'selected' : null">10</option>
              <option value='20' :selected="itemsper == 20 ? 'selected' : null">20</option>
              <option value='50' :selected="itemsper == 50 ? 'selected' : null">50</option>
            </select>
          </li>

        </ul>
      </div>
    `,
    data() {
        return {};
    },
    methods: {
      applyPage: function(goto) {
r43
        console.log("USE: " + goto);

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

          console.log("goto " + pageindex);

          this.$parent.refresh('',pageindex)
      }
      , applyItemsPer: function() {
        this.$parent.itemsper = this.itemsper;
      }
    }

  });


  Vue.component('filewindow', {
    props: ['files','folders','foldertree','isDisplayContext','currentFile'],
    template: `
      <div class="filewindow-wrapper" @mousemove="trax">
        <div v-if="foldertree.length" class="fileviewer-item" @click="back()">
          <div class="fileviewer-image">
            <i class="fa fa-arrow-left" style="font-size: 7em"></i>
          </div>
          <div class="fileviewer-label">
            Back
          </div>
        </div>
        <div v-for="(file,index) in files">
          <div class="fileviewer-item"  v-if="parseInt(file.isfile)" @contextmenu="openMenu($event,file,index)">
            <div class="fileviewer-image">
              <div v-if="0" class="fileviewer-icon" :class="['fileviewer-icon-' + file.type]"></div>
              <div v-else class="fileviewer-icon" :style="{ 'background-image': 'url(' + file.image + ')' }"></div>
            </div>
            <div class="fileviewer-label">
              {{file.name}}
            </div>
          </div>
          <div class="fileviewer-item" v-else @click="refresh(file.name)">
            <div class="fileviewer-image">
              <i class="fa fa-folder" style="font-size: 7em;color: #333"></i>
            </div>
            <div class="fileviewer-label">
              {{file.name}}
            </div>
          </div>
        </div>
        <contextmenu :style="{position: 'absolute',top: menuy + 'px',left: menux + 'px'}" :currentFile="this.$parent.currentFile" :isDisplayContext="isDisplayContext" v-if="isDisplayContext"></contextmenu>
      </div>`,
    data() {
      return {
          menux: 0,
          menuy: 0,
          offsetx: 0,
          offsety: 0
      }
    },
    methods: {
      trax: function(e) {
          var boundingbox = this.$el.getBoundingClientRect();
          this.offsetx = boundingbox.x;
          this.offsety = boundingbox.y;

      },
      refresh: function( directory,index ) {
        this.$parent.refresh( directory,index );
      }
      ,back: function( ) {
        this.$parent.back( );
      }
      ,openMenu: function(e,file,index) {
        this.$parent.isDisplayContext = 1;
        this.$parent.isDisplayWindow = '';
        this.$parent.currentFile = file;
        this.$parent.currentFile.index = index;
        this.$parent.currentIndex = index;
        this.menux = e.pageX - this.offsetx;
        this.menuy = e.pageY - this.offsety + 162;

        e.preventDefault();
      }
    }
  });


  const IS_START = 0, IS_SAVE = 1, IS_SUCCESS = 2, IS_FAIL = 3;


  var fileViewer = new Vue({
    el: "#" + self.target,
    template: `
      <div class="fileviewer-wrapper">
        <actionwindow v-if="isDisplayWindow" :isDisplayWindow="isDisplayWindow" :currentFile="currentFile"></actionwindow>
        <div class="fileviewer-breadcrumb">
          <i class="fa fa-home" @click="setDirDepth(-1)"></i>
          <i v-for="(item,index) in foldertree" class="fa fa-angle-double-right fa-padleft" @click="setDirDepth(index)"> {{item}}</i>
        </div>
        <div class="fileviewer-droptarget">
          <form enctype="multipart/form-data" novalidate v-if="isStart || isSave">
            <input type="file" multiple :name="uploadField" :disabled="isSave" @change="filesChanged($event.target.name, $event.target.files);" accept="*.*" class="file-input-field">
            <p v-if="isStart" class="upload-icon">
              <strong>Drag</strong> your files here, or <strong>click</strong> to browse...
            </>
            <p v-if="isSave" class="download-icon">
              Uploading {{fileCount}} files...
              <ul class="fileviewer-uploadedfiles">
                <li v-for="file in uploadedFiles">
                  {{file.name}} ({{Math.floor(file.size/1000)}}k)
                </li>
              </ul>
            </p>
          </form>
        </div>
        <navmenu v-if="response.links" :links="response.links" :itemsper="itemsper" :response="response"></navmenu>
        <filewindow :isDisplayContext="isDisplayContext" :foldertree="foldertree" :files="files" :folders="folders"></filewindow>
        <navmenu v-if="response.links"  :itemsper="itemsper" :isbottomnav=1 :links="response.links" :response="response"></navmenu>
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
      uploadedFiles: [],
      isDisplayContext: 0,
      isDisplayWindow: '',
      uploadField: "uploadFiles",
      error: null,
      menux: 0,
      menuy: 0,
      itemsper: 10,
      editfilelist: self.editfilelist,
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
      isFail() {
        return this.currentState === IS_FAIL;
      }
    },
    methods: {
      updateDelete: function() {
          self.updateDelete(currentFile);
      }
      , renameFile: function() {
        var dir = "";

        for(var i=0;i<this.foldertree.length;i++) {
          dir = dir + "\\" + this.foldertree[i];
        }

          self.doRenameFile( dir,this.currentFile );
      }
      , updateEdit: function() {
          self.updateEdit(currentFile);
      }
      , display: function(response) {
        this.response = response.data;
        this.files = response.data.items;
        this.folders = response.data.folders;
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
          console.log(depth);
          this.foldertree = this.foldertree.slice(0,depth+1);
          this.refresh();
      }
      , editFile: function( onSuccess) {
        var dir = "";

        for(var i=0;i<this.foldertree.length;i++) {
          dir = dir + "\\" + this.foldertree[i];
        }

        self.getEditFile(dir,this.currentFile,onSuccess);

      }
      , viewFile: function( direction ) {

      }
      , deleteFile: function( onSuccess) {
        var dir = "";

        for(var i=0;i<this.foldertree.length;i++) {
          dir = dir + "\\" + this.foldertree[i];
        }

        console.log(this.currentFile);
        console.log(dir);

        self.doDeleteFile(dir,this.currentFile,onSuccess);

      }
      , refresh: function( folder,pageindex ) {
        if(folder && folder.length)
          this.foldertree.push(folder);

        var dir = "";

        isNaN(pageindex) ? 0 : pageindex;

        for(var i=0;i<this.foldertree.length;i++) {
          dir = dir + "\\" + this.foldertree[i];
        }

        self.loaddirectory(dir,pageindex,this.display);
      }
      , back: function() {
        this.foldertree.splice(-1);
        var folder = this.foldertree.length ? "" : this.foldertree[this.foldertree.length-1];
        this.refresh();
      }
      , closeMenu: function( e ) {
        console.log('close menu');
        console.log(e);
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
          dir = dir + "\\" + this.foldertree[i];
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
      , checkFileType: function() {
          for(var i = 0;i<self.editfilelist.length;i++) {
            if(this.currentFile.type == self.editfilelist[i])
              return true;

            return false;
          }
      }
      , checkImageType: function() {
          for(var i = 0;i<self.imagelist.length;i++) {
            if(this.currentFile.type == self.imagelist[i]) {
              return true;
            }
          }
          return false;
      }

    },
    mounted: function() {
        var me = this;
        this.uploadReset();
        self.loadBaseDirectory(this.display);
        var vm = this;
        window.addEventListener('mouseup', function(event) {
          me.isDisplayContext = 0;
        });


    }
  });
}

};
