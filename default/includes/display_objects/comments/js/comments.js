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
initMuraComments=function(config){
	
	var $editor = jQuery('#mura-comment-post-comment');
	var $commentsProxyPath = mura.assetpath + "/includes/display_objects/comments/ajax/commentsProxy.cfc";
	var $newcommentid = jQuery("#mura-comment-post-comment [name=commentid]").val();
	var $name = jQuery("#mura-comment-post-comment [name=name]").val();
	var $url = jQuery("#mura-comment-post-comment [name=url]").val();
	var $email = jQuery("#mura-comment-post-comment [name=email]").val();
	var $currentedit = "";
	var $nextN = 3;
	var params = {
			// empty
	};

	 var initPage=function() {

		loadPage(params).success(function(data){
			data=mura.setLowerCaseKeys(data);
			if (data.count > 0) {
				jQuery('#mura-comments-page').html(data.htmloutput);
				jQuery('#mura-comments-sort').show();
			} else {
				jQuery('#mura-comments-sort').hide();
			}
			bindEvents();
			handleHash();
		})
			
	}

	var handleHash=function() {
		var hash = window.location.hash;

		//Only do this if there is a valid hash and it's not hash based filenames
		if (hash.length > 0 && hash.indexOf("#/")==-1) {
			if (jQuery('' + hash).length != 0) {
				scrollToID(jQuery(hash));
			} else {
				/* load comments, then scroll to */
				var params = {
					pageNo: jQuery("#mura-more-comments").attr('data-pageno'),
					commentID: hash.replace('#mura-comment-', '')
				};

				loadPage(params).success(function(data){
					data=mura.setLowerCaseKeys(data);
					jQuery("#mura-more-comments").parent().remove();
					jQuery(data.htmloutput).appendTo('#mura-comments-page').hide().fadeIn();
					bindEvents();
					if (jQuery(hash).length != 0) {
						scrollToID(jQuery(hash));
					}
				});
			}
		}
	}

	var loadPage=function(ext) {

		var params = {
			method: "renderCommentsPage",
			contentID: jQuery('#mura-comments-page').attr('data-contentid'),
			siteID: jQuery('#mura-comments-page').attr('data-siteid'),
			sortDirection: jQuery('#mura-sort-direction-selector').val(),
			nextN: $nextN
		};

		jQuery.extend(params, ext);

		return jQuery.ajax({
			dataType: "json",
			url: $commentsProxyPath,
			data: params,
			cache: false
		});
	}

	var scrollToID=function(elem) {
		$('html, body').animate({
			scrollTop: elem.offset().top - 50
		}, 500, function(){
			elem.fadeTo('fast', 0.5, function() {
				elem.fadeTo('fast', 1);
			});
		});
	}

	var bindEvents=function(){

		if(typeof customCommentsPageInit == 'function'){
			customCommentsPageInit();
		}

		jQuery("a.mura-in-reply-to").on('click', function( event ) {
			event.preventDefault();
			var a = jQuery(this);
			var parentid = a.attr('data-parentid');
			
			if (jQuery('#mura-comment-' + parentid).length != 0) {
				scrollToID(jQuery('#mura-comment-' + parentid));
			} else {
				/* load comments, then scroll to */
				var params = {
					pageNo: jQuery("#mura-more-comments").attr('data-pageno'),
					commentID: parentid,
					siteID: jQuery("#mura-more-comments").attr('data-siteid')
				};

				loadPage(params).success(function(data){
					data=mura.setLowerCaseKeys(data);
					jQuery("#mura-more-comments").parent().remove();
					jQuery(data.htmloutput).appendTo('#mura-comments-page').hide().fadeIn();
					bindEvents();
					if (jQuery('#mura-comment-' + parentid).length != 0) {	
						scrollToID(jQuery('#mura-comment-' + parentid));
					}
				})
			}
		});

		jQuery("a.mura-comment-flag-as-spam").on('click', function( event ) {
			event.preventDefault();
			var a = jQuery(this);
			var id = a.attr('data-id');
			var siteid = a.attr('data-siteidid')
			
			var actionURL = $commentsProxyPath + "?method=flag&commentID=" + id + "&siteid=" + siteid;
			jQuery.get(
				actionURL,
				function(data){
					a.html('Flagged as Spam');
					a.unbind('click');
					a.on('click', function( event ) {
						event.preventDefault();
					});
				}
			);
		});

		jQuery("#mura-more-comments").on('click', function( event ) {
			event.preventDefault();
			var a = jQuery(this);
			var pageNo = a.attr('data-pageno');
			var contentID = jQuery('#mura-comments-page').attr('data-contentid');
			var params = {
				pageNo: pageNo
			};
			
			loadPage(params).success(function(data){
				data=mura.setLowerCaseKeys(data);
				a.parent().remove();
				jQuery(data.htmloutput).appendTo('#mura-comments-page').hide().fadeIn();
				bindEvents();
				jQuery(".mura-comment-reply-wrapper").hide();
			})
			
		});

		jQuery("#mura-sort-direction-selector").on('change', function( event ) {
			var params = {
				// empty
			};
			
			loadPage(params).success(function(data){
				data=mura.setLowerCaseKeys(data);
				jQuery('#mura-comments-page').html(data.htmloutput);	
				bindEvents();
			})
			
		});

		jQuery(document).on('click', '.mura-comment-reply a', function( event ) {
			var id = jQuery(this).attr('data-id');
			jQuery(".mura-comment-reply-wrapper").hide();
			if($.currentedit != ''){
				jQuery($currentedit).show();
				$currentedit='';
			}
			
			event.preventDefault();
			$editor.hide();
			$editor.detach();
			jQuery("#mura-comment-post-comment-" + id).append($editor).show();
			jQuery("#mura-comment-post-a-comment").changeElementType('div').hide();
			jQuery("#mura-comment-edit-comment").changeElementType('div').hide();
			jQuery("#mura-comment-reply-to-comment").changeElementType('legend').show();
			jQuery("#mura-comment-post-comment-" + id + " [name=name]").val($name);
			jQuery("#mura-comment-post-comment-" + id + " [name=email]").val($email);
			jQuery("#mura-comment-post-comment-" + id + " [name=url]").val($url);
			jQuery("#mura-comment-post-comment-" + id + " [name=comments]").val("");
			jQuery("#mura-comment-post-comment-" + id + " [name=parentid]").val(id);
			jQuery("#mura-comment-post-comment-" + id + " [name=commentid]").val($newcommentid);
			jQuery("#mura-comment-post-comment-" + id + " [name=commenteditmode]").val("add");
			jQuery("#mura-comment-post-comment-comment").show();
			$editor.slideDown();
		});
		
		jQuery(document).on('click', '.mura-comment-edit-comment', function( event ) {
			event.preventDefault();
			jQuery(".mura-comment-reply-wrapper").hide();
			var id = jQuery(this).attr('data-id');
			var siteid = jQuery(this).attr('data-siteid');
			var actionURL=$commentsProxyPath + "?method=get&commentID=" + id + "&siteid=" + siteid;
			jQuery.get(
				actionURL,
				function(data){
					data=eval("(" + data + ")" );
					
					if($.currentedit != ''){
						 jQuery($currentedit).show();
						 $currentedit='';
					}
					
					$editor.hide();
					$editor.detach();
					jQuery("#mura-comment-post-comment-" + id).append($editor).show();
					jQuery("#mura-comment-post-a-comment").changeElementType('div').hide();
					jQuery("#mura-comment-edit-comment").changeElementType('legend').show();
					jQuery("#mura-comment-reply-to-comment").changeElementType('div').hide();
					
					jQuery("#comment-" + id + " .comment").hide();
					$currentedit="#comment-" + id + " .comment";
					
					jQuery("#mura-comment-post-comment-" + id + " [name=parentid]").val(data.parentid);
					jQuery("#mura-comment-post-comment-" + id + " [name=name]").val(data.name);
					jQuery("#mura-comment-post-comment-" + id + " [name=email]").val(data.email);
					jQuery("#mura-comment-post-comment-" + id + " [name=url]").val(data.url);
					jQuery("#mura-comment-post-comment-" + id + " [name=comments]").val(data.comments);
					jQuery("#mura-comment-post-comment-" + id + " [name=commentid]").val(data.commentid);
					jQuery("#mura-comment-post-comment-" + id + " [name=commenteditmode]").val("edit");
					jQuery("#mura-comment-post-comment-comment").show();
					$editor.slideDown();
				}
			);
		});
		
		jQuery("#mura-comment-post-comment-comment").on('click', function( event ) {
			jQuery("#mura-comment-post-comment-comment").hide();
			jQuery(".mura-comment-reply-wrapper").hide();
			if($.currentedit != ''){
				 jQuery($currentedit).show();
				 $currentedit='';
			}
			
			event.preventDefault();
			$editor.hide();
			$editor.detach();
			jQuery("#mura-comment-post-comment-form").append($editor).show();
			jQuery("#mura-comment-post-a-comment").changeElementType('legend').show();
			jQuery("#mura-comment-edit-comment").changeElementType('div').hide();
			jQuery("#mura-comment-reply-to-comment").changeElementType('div').hide();
			jQuery("#mura-comment-post-comment [name=parentid]").val("");
			jQuery("#mura-comment-post-comment [name=name]").val($name);
			jQuery("#mura-comment-post-comment [name=email]").val($email);
			jQuery("#mura-comment-post-comment [name=url]").val($url);
			jQuery("#mura-comment-post-comment [name=comments]").val("");
			jQuery("#mura-comment-post-comment [name=commentid]").val($newcommentid);
			jQuery("#mura-comment-post-comment [name=commenteditmode]").val("add");
			$editor.slideDown();
		});
	}

	initPage();

}
