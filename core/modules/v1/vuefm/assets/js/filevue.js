Vue.component('contextmenu', {
  props: ["isDisplayContext","currentFile"],
  template: `
    <div class="filewindow-context">
      <ul>
        <li @click="editFile()" v-if="checkFileType()"><i class="fa fa-pencil"> Edit</i></li>
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
    editFile: function() {
      console.log("EDIT: " + fileViewer.currentFile.name);
      this.$parent.$parent.editFile(this.successEditFile);
    }
    , successEditFile: function( response ) {
      console.log("RESP");
      console.log(response);
      this.currentFile.content = response.data.content;
      this.$parent.$parent.isDisplayWindow = "EDIT";
    }
    , renameFile: function() {
      console.log("RENAME: " + fileViewer.currentFile.name);
      this.$parent.$parent.isDisplayWindow = "RENAME";
    //  fileViewer.currentFile.name = "JOHN";
    }
    , downloadFile: function() {
      console.log("DOWNLOAD: " + fileViewer.currentFile.name);
      this.$parent.$parent.isDisplayWindow = "DOWNLOAD";

    }
    , deleteFile: function() {
      console.log("DELETE: " + fileViewer.currentFile.name);
      this.$parent.$parent.isDisplayWindow = "DELETE";
    }
    , checkFileType: function() {
        for(var i = 0;i<self.editfilelist.length;i++) {
          if(this.currentFile.type == self.editfilelist[i])
            return true;

          return false;
        }
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
      this.$parent.$parent.renameFile();

      this.$parent.$parent.isDisplayWindow = '';
      //this.$parent.updateRename();
    }
    , cancel: function() {
      this.$parent.$parent.isDisplayWindow = '';
      //this.$parent.updateRename();
    }
  },
  mounted: function() {
    this.filename = this.currentFile.name;
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
      this.$parent.$parent.deleteFile(  this.$parent.$parent.refresh);
      this.$parent.$parent.isDisplayWindow = '';
      //this.$parent.updateRename();
    }
    , successDeleteFile: function() {
      this.$parent.$parent.isDisplayWindow = '';
      //this.$parent.updateRename();
    }
    , cancel: function() {
      this.$parent.$parent.isDisplayWindow = '';
      //this.$parent.updateRename();
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
      this.$parent.$parent.isDisplayWindow = '';
      //this.$parent.updateRename();
    }
    , cancel: function() {
      this.$parent.$parent.isDisplayWindow = '';
      //this.$parent.updateRename();
    }
  }
  , mounted: function() {
    console.log(this.currentFile);
    this.filecontent = this.currentFile.content;
  }
});

Vue.component('navmenu', {
  props: ["links","isbottomnav"],
  template: `
      <div class="filewindow-navmenu">
        <p v-if="isbottomnav">
        {{this.$parent.response.pageindex}} of {{this.$parent.response.totalpages}} <!-- ({{this.$parent.response.totalitems}}) includes folders -->
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
          <select name="itemsper" class="itemsper" @change="applyItemsPer">
            <option value='10' :selected="this.$parent.itemsper == 10 ? 'selected' : null">10</option>
            <option value='20' :selected="this.$parent.itemsper == 20 ? 'selected' : null">20</option>
            <option value='50' :selected="this.$parent.itemsper == 50 ? 'selected' : null">50</option>
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
      this.menux = e.pageX - this.offsetx;
      this.menuy = e.pageY - this.offsety + 162;


      e.preventDefault();
    }
  }
});
