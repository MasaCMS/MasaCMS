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
$(function(){
	var $editor = jQuery('#postcomment');
	var $commentsProxyPath = assetpath + "/includes/display_objects/comments/ajax/commentsProxy.cfc";
	var $newcommentid = jQuery("#postcomment [name=commentid]").val();
	var $name = jQuery("#postcomment [name=name]").val();
	var $url = jQuery("#postcomment [name=url]").val();
	var $email = jQuery("#postcomment [name=email]").val();
	var $currentedit = "";
	var $nextN = 3;
	var params = {
			// empty
	};

	 var initPage=function() {
		loadPage(params).success(function(data){
			jQuery('#commentsPage').html(data);	
			bindEvents();
			handleHash();
		})
			
	}

	var handleHash=function() {
		var hash = window.location.hash;
		if (hash.length > 0) {
			if (jQuery(hash).length != 0) {
				scrollToID(hash);
			} else {
				/* load comments, then scroll to */
				var params = {
					pageNo: jQuery("#moreComments").attr('data-pageno'),
					commentID: hash.replace('#comment-', '')
				};

				loadPage(params).success(function(data){
					jQuery("#moreComments").parent().remove();
					jQuery(data).appendTo('#commentsPage').hide().fadeIn();
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
			contentID: jQuery('#commentsPage').attr('data-contentid'),
			sortDirection: jQuery('#sortDirectionSelector').val(),
			nextN: $nextN
		};

		jQuery.extend(params, ext);
		
		return jQuery.ajax({
			url: $commentsProxyPath,
			data: params
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
		jQuery("a.inReplyTo").on('click', function( event ) {
			event.preventDefault();
			var a = jQuery(this);
			var parentid = a.attr('data-parentid');
			
			if (jQuery('#comment-' + parentid).length != 0) {
				scrollToID(jQuery('#comment-' + parentid));
			} else {
				/* load comments, then scroll to */
				var params = {
					pageNo: jQuery("#moreComments").attr('data-pageno'),
					commentID: parentid
				};

				loadPage(params).success(function(data){
					jQuery("#moreComments").parent().remove();
					jQuery(data).appendTo('#commentsPage').hide().fadeIn();
					bindEvents();
					if (jQuery('#comment-' + parentid).length != 0) {	
						scrollToID(jQuery('#comment-' + parentid));
					}
				})
			}
		});

		jQuery("a.flagAsSpam").on('click', function( event ) {
			event.preventDefault();
			var a = jQuery(this);
			var id = a.attr('data-id');
			
			var actionURL = $commentsProxyPath + "?method=flag&commentID=" + id;
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

		jQuery("#moreComments").on('click', function( event ) {
			event.preventDefault();
			var a = jQuery(this);
			var pageNo = a.attr('data-pageno');
			var contentID = jQuery('#commentsPage').attr('data-contentid');
			var params = {
				pageNo: pageNo
			};
			
			loadPage(params).success(function(data){
				a.parent().remove();
				jQuery(data).appendTo('#commentsPage').hide().fadeIn();
				bindEvents();
			})
			
		});

		jQuery("#sortDirectionSelector").on('change', function( event ) {
			var params = {
				// empty
			};
			
			loadPage(params).success(function(data){
				jQuery('#commentsPage').html(data);	
				bindEvents();
			})
			
		});

		jQuery(document).on('click', '.reply a', function( event ) {
			var id = jQuery(this).attr('data-id');
		
			if($.currentedit != ''){
				jQuery($currentedit).show();
				$currentedit='';
			}
			
			event.preventDefault();
			$editor.hide();
			$editor.detach();
			jQuery("#postcomment-" + id).append($editor);
			jQuery("#postacomment").hide();
			jQuery("#editcomment").hide();
			jQuery("#replytocomment").show();
			jQuery("#postcomment-" + id + " [name=name]").val($name);
			jQuery("#postcomment-" + id + " [name=email]").val($email);
			jQuery("#postcomment-" + id + " [name=url]").val($url);
			jQuery("#postcomment-" + id + " [name=comments]").val("");
			jQuery("#postcomment-" + id + " [name=parentid]").val(id);
			jQuery("#postcomment-" + id + " [name=commentid]").val($newcommentid);
			jQuery("#postcomment-" + id + " [name=commenteditmode]").val("add");
			jQuery("#postcomment-comment").show();
			$editor.slideDown();
		});
		
		jQuery(document).on('click', '.editcomment', function( event ) {
			event.preventDefault();
			var id = jQuery(this).attr('data-id');
			var actionURL=$commentsProxyPath + "?method=get&commentID=" + id;
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
					jQuery("#postcomment-" + id).append($editor);
					jQuery("#postacomment").hide();
					jQuery("#editcomment").show();
					jQuery("#replytocomment").hide();
					
					jQuery("#comment-" + id + " .comment").hide();
					$currentedit="#comment-" + id + " .comment";
					
					jQuery("#postcomment-" + id + " [name=parentid]").val(data.parentid);
					jQuery("#postcomment-" + id + " [name=name]").val(data.name);
					jQuery("#postcomment-" + id + " [name=email]").val(data.email);
					jQuery("#postcomment-" + id + " [name=url]").val(data.url);
					jQuery("#postcomment-" + id + " [name=comments]").val(data.comments);
					jQuery("#postcomment-" + id + " [name=commentid]").val(data.commentid);
					jQuery("#postcomment-" + id + " [name=commenteditmode]").val("edit");
					jQuery("#postcomment-comment").show();
					$editor.slideDown();
				}
			);
		});
		
		jQuery("#postcomment-comment a").on('click', function( event ) {
			jQuery("#postcomment-comment").hide();
			
			if($.currentedit != ''){
				 jQuery($currentedit).show();
				 $currentedit='';
			}
			
			event.preventDefault();
			$editor.hide();
			$editor.detach();
			jQuery("#postcomment-form").append($editor);
			jQuery("#postacomment").show();
			jQuery("#editcomment").hide();
			jQuery("#replytocomment").hide();
			jQuery("#postcomment [name=parentid]").val("");
			jQuery("#postcomment [name=name]").val($name);
			jQuery("#postcomment [name=email]").val($email);
			jQuery("#postcomment [name=url]").val($url);
			jQuery("#postcomment [name=comments]").val("");
			jQuery("#postcomment [name=commentid]").val($newcommentid);
			jQuery("#postcomment [name=commenteditmode]").val("add");
			$editor.slideDown();
		});
	}

	initPage();

});