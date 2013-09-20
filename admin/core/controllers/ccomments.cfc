/*
	This file is part of Mura CMS.

	Mura CMS is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, Version 2 of the License.

	Mura CMS is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

	Linking Mura CMS statically or dynamically with other modules constitutes 
	the preparation of a derivative work based on Mura CMS. Thus, the terms 
	and conditions of the GNU General Public License version 2 ("GPL") cover 
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant 
	you permission to combine Mura CMS with programs or libraries that are 
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS 
	grant you permission to combine Mura CMS with independent software modules 
	(plugins, themes and bundles), and to distribute these plugins, themes and 
	bundles without Mura CMS under the license of your choice, provided that 
	you follow these specific guidelines: 

	Your custom code 

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

		/admin/
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that 
	meets the above guidelines as a combined work under the terms of GPL for 
	Mura CMS, provided that you include the source code of that other code when 
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not 
	obligated to grant this special exception for your modified version; it is 
	your choice whether to do so, or to make such modified version available 
	under the GNU General Public License version 2 without this exception.  You 
	may, if you choose, apply this exception to your own modified versions of 
	Mura CMS.
*/
component persistent="false" accessors="true" output="false" extends="controller" {

	property name='contentCommentManager';

	public void function setContentCommentManager(required contentCommentManager) {
		variables.contentCommentManager = arguments.contentCommentManager;
	}

	public any function before(required struct rc) {
		param name='rc.siteid' default=session.siteid;

		if ( !variables.permUtility.getModulePerm('00000000000000000000000000000000000',rc.siteid) ) {
			secure(rc);
		}
	}

	// *********************************  PAGES  *******************************************

	public void function default(required struct rc) {
		param name='rc.bulkedit' default='';
		param name='rc.sortby' default='entered';
		param name='rc.sortdirection' default='asc';
		param name='rc.pageno' default=1;
		param name='rc.nextn' default=25; // 25
		param name='rc.isapproved' default=false;

		rc.siteid = StructKeyExists(session, 'siteid') ? session.siteid : 'default';
		rc.sortdirlink = rc.sortdirection == 'asc' ? 'desc' : 'asc';
		rc.sortby = !ListFindNoCase('entered,name', rc.sortby) ? 'entered' : rc.sortby;
		rc.itComments = getContentCommentManager().getCommentsIterator(argumentCollection=rc);

		// Pagination Setup
		rc.nextn = Val(rc.nextn);
		rc.pageno = Val(rc.pageno);
		if ( rc.nextn < 1 ) { 
			rc.nextn = 10; 
		}

		// WriteDump(rc.itComments);
		// abort;

		rc.itComments.setNextN(rc.nextn);
		if ( rc.pageno < 1 || rc.pageno > rc.itComments.pageCount() ) {
			rc.pageno = 1;
		}
		rc.itComments.setPage(rc.pageno);

		rc.totalPages = rc.itComments.pageCount();
		rc.buffer = 3;
		rc.startPage = 1;
		rc.endPage = rc.totalPages;

		if ( rc.buffer < rc.totalPages ) {
			rc.startPage = rc.pageno-rc.buffer;
			rc.endPage = rc.pageno+rc.buffer;

			if ( rc.startPage < 1 ) {
				rc.endPage = rc.endPage + Abs(rc.startPage) + 1;
				rc.startPage = 1;
			} 

			if ( rc.endPage > rc.totalPages ) {
				rc.x = rc.startPage - (rc.endPage - rc.totalPages);
				rc.startPage = rc.x < 1 ? 1 : rc.x;
				rc.endPage = rc.totalPages;
			}
		}
	}


	public void function bulkedit(required struct rc) {
		var local = {};
		rc.processed = true;

		param name='rc.ckupdate' default='';
	
		if ( ListLen(rc.ckupdate) ) {
			try {
				local.arr = ListToArray(rc.ckupdate);
				for ( local.i=1; local.i <= ArrayLen(local.arr); local.i++ ) {
					switch ( rc.bulkedit ) {
						case 'approve' : getContentCommentManager().approve(local.arr[local.i]);
							break;
						case 'disapprove' : getContentCommentManager().disapprove(local.arr[local.i]);
							break;
						case 'delete' : getContentCommentManager().delete(local.arr[local.i]);
							break;
						default : break;
					}
				}
			} catch(any e) {
				rc.processed = false;
			}
		}

		getFW().redirect(action='cComments.default', preserve='processed,isapproved,siteid',path="./");
	}


	public void function approve(required struct rc) {
		rc.processed = false;
		if ( StructKeyExists(arguments.rc, 'commentid') ) {
			rc.processed = getContentCommentManager().approve(arguments.rc.commentid);
		}
		getFW().redirect(action='cComments.default', preserve='processed,isapproved,siteid',path="./");
	}


	public void function disapprove(required struct rc) {
		rc.processed = false;
		if ( StructKeyExists(arguments.rc, 'commentid') ) {
			rc.processed = getContentCommentManager().disapprove(arguments.rc.commentid);
		}
		getFW().redirect(action='cComments.default', preserve='processed,isapproved,siteid',path="./");
	}


	public void function delete(required struct rc) {
		rc.processed = false;
		if ( StructKeyExists(arguments.rc, 'commentid') ) {
			rc.processed = getContentCommentManager().delete(arguments.rc.commentid);
		}
		getFW().redirect(action='cComments.default', preserve='processed,isapproved,siteid',path="./");
	}

}