/* This file is part of Mura CMS. */

/*    Mura CMS is free software: you can redistribute it and/or modify */
/*    it under the terms of the GNU General Public License as published by */
/*    the Free Software Foundation, Version 2 of the License. */

/*    Mura CMS is distributed in the hope that it will be useful, */
/*    but WITHOUT ANY WARRANTY; without even the implied warranty of */
/*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the */
/*    GNU General Public License for more details. */

/*    You should have received a copy of the GNU General Public License */
/*    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. */



jQuery(document).ready(function() {
	$editor = jQuery('#postcomment');
	$commentsProxyPath = assetpath + "/includes/display_objects/comments/ajax/commentsProxy.cfc";
	$newcommentid=jQuery("#postcomment [name=commentid]").val();
	$name=jQuery("#postcomment [name=name]").val();
	$url=jQuery("#postcomment [name=url]").val();
	$email=jQuery("#postcomment [name=email]").val();
	$currentedit="";
	
	jQuery(".reply a").on('click',function( event ) {
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
	
	jQuery(".editcomment").on('click',function( event ) {
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
	
	jQuery("#postcomment-comment a").click( function( event ) {
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
	
	
});