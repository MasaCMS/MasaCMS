/*
 * Copyright (C) 2005-2008 Razuna Ltd.
 *
 * This file is part of Razuna - Enterprise Digital Asset Management.
 *
 * Razuna is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Razuna is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero Public License for more details.
 *
 * You should have received a copy of the GNU Affero Public License
 * along with Razuna. If not, see <http://www.gnu.org/licenses/>.
 *
 * You may restribute this Program with a special exception to the terms
 * and conditions of version 3.0 of the AGPL as described in Razuna's
 * FLOSS exception. You should have received a copy of the FLOSS exception
 * along with Razuna. If not, see <http://www.razuna.com/licenses/>.
 *
 *
 * HISTORY:
 * Date US Format		User					Note
 * 2013/04/10			CF Mitrah		 	Initial version
*/ 
	$(function(){
			$('body').append('<div id="razunaModalWindow"></div>');
	});
	
	$(document).on('change','input[name=radio_path]',{},function(){
		$('#width').val(parseInt($(this).attr('data-width')));
		$('#height').val(parseInt($(this).attr('data-height')));
	});
	
	$(document).on('click','#search',{}, function() {
		$("#tagTree").jstree('open_all');
		$('#inner-div').hide();
		$('#loader-div').hide();
		$('#tagTree').css("width","835px");
		$('#full_page_loader').css('display','block');
		setTimeout(function(){
			$("#tagTree").jstree("search", $('#search_box').val());
			$('#full_page_loader').css('display','none');
		}, 2000);  
	});
	
	$(document).on('click','#insert_into_post',{},function(){
		
		if ($('.urlfield').val().length){
				url = $('.urlfield').val();
		} else{
			url = $("input[type='radio'][name='radio_path']:checked").val();
		}
		
		$("#" + razunatargetid).val(url);
		$('#razunaModalWindow').dialog("close");
	});
	
	function removAll(){
		$('.inner-div').remove();
		$('#loader-div').hide();
		$('#search_div').remove();
		$('#tagTree').css("width","835px");
	}
	
	function renderRazunaWindow(targetid){
		razunatargetid=targetid;
		$('#razunaModalWindow').html('<div align="center"><img src="'+razuna_folder+'assets/images/ajax-loader.gif"></div>');
		$('#razunaModalWindow').dialog({
	        bgiframe: true,
	        autoOpen: false,
	        width: 860,
			height:450,
	        modal: true,
	        title: "Razuna" 
       	});
		$('.ui-dialog-titlebar-close').click(function(){
			removAll();
		});
		
		$('#razunaModalWindow').load(razuna_folder+'?muraAction=razuna.default',function(){
			var loader_div = '<div id="loader-div"><div align="center" class="img_div"><img src="'+razuna_folder+'assets/images/ajax-loader.gif"></div></div>';
				$('#razunaModalWindow').before(loader_div);

		$("#tagTree").jstree({
			"plugins" : [ "json_data", "ui", "types", "search"],
			"types" : {
            	"types" : {
		                "folder" : {
		                    "hover_node" : false,
		                    "select_node" : function () {return false;}
		                },
		                "default" : {
		                    "select_node" : function (target) {
								$('#tagTree').css("width","266px");
								$('#inner-div').show();
								$('.inner-div').remove();
								$('#loader-div').show();
								$(target).attr('data-cloud_url_thumb',$(target).attr('data-cloud_url'));

								var type = $(target).attr('data-kind');
								if(type == 'aud'){
									var content='<tbody><tr><td valign="top"><strong>File name : </strong><span>'+$(target).attr('data-filename_org')+'</span><br><strong>Kind : </strong><span>Audio</span><br><table border="0" id="renditions"><tr><td>&nbsp;</td><td ><div><input type="radio" checked="checked" name="radio_path" class="radio_path radio" value="'+$(target).attr('data-' + razuna_servertype + '_url_org')+'" id="radio_path" data-height="'+$(target).attr('data-height')+'" data-width="'+$(target).attr('data-width')+'"><label for="radio_path_orig" class="form_labels">Original</label></div></td></tr></table></td></tr><tr><td><br><button type="button" data-id="'+$(target).attr('id')+'" id="insert_into_post" class="btn audio">Insert into Post</button></td></tr></tbody>';
								}
								else if(type == 'img'){
									var content='<tbody><tr><td><img src="'+$(target).attr('data-' + razuna_servertype + '_url_thumb')+'" id="show-image"></td><td valign="top"><strong>File name : </strong><span>'+$(target).attr('data-filename_org')+'</span><br><strong>Kind:</strong><span>Image</span><br></td></tr><td style="text-align:center;" colspan="3"><button onclick="'+original+'" class="btn image_org">Select File</button></td></tr><tr><td colspan="3" style="text-align:center;"></td></tr></tbody>';
								}
								else if(type == 'doc'){
									var content='<tbody><tr><td valign="top"><strong>File name : </strong><span>'+$(target).attr('data-filename_org')+'</span><br><strong>Kind : </strong><span>Document</span><br><table border="0" id="renditions"><tr><td>&nbsp;</td><td ><div><input type="radio" checked="checked" name="radio_path" class="radio_path radio" value="'+$(target).attr('data-' + razuna_servertype + '_url_org')+'" id="radio_path" data-height="'+$(target).attr('data-height')+'" data-width="'+$(target).attr('data-width')+'"><label for="doc-path-orig" class="form_labels">Original</label></div></td></tr></table></td></tr><tr><td><strong>Link Text:</strong></td><td><input type="text" value="" id="doc_link_text"></td></tr><tr><td>&nbsp;</td><td><br><button type="button" id="insert_into_post" class="btn document">Insert into Post</button></td></tr></tbody>';
								}
								else if(type == 'vid'){
									var content='<tbody><tr><td valign="top"><strong>File name : </strong><span>'+$(target).attr('data-filename_org')+'</span><br><strong>Kind : </strong><span>Video</span><br><table border="0" id="renditions"><tr><td>&nbsp;</td><td ><div class="image-size-item"><input type="radio" checked="checked" name="radio_path" class="image-size-original radio" value="'+$(target).attr('data-' + razuna_servertype + '_url_org')+'" id="radio_path" data-height="'+$(target).attr('data-height')+'" data-width="'+$(target).attr('data-width')+'" data-image-thumb="'+$(target).attr('data-' + razuna_servertype + '_url_thumb')+'"><label for="radio_path_orig" class="form_labels">Original</label></div></td></tr></table></td></tr><tr><td><strong>Width:</strong></td><td><input type="text" id="width" value="'+$(target).attr('data-width').toString().split(".")[0]+'" class="width"></td></tr><tr><td><strong>Height:</strong></td><td><input type="text" value="'+$(target).attr('data-height').toString().split(".")[0]+'" class="height" id="height"></td></tr><tr><td>&nbsp;</td><td><br><button type="button" data-id="'+$(target).attr('id')+'" id="insert_into_post" class="btn video">Insert into Post</button></td></tr></tbody>';
								}
								$('.describe').html(content);
								$('.rend').remove();
								for(x=1; x<=$(target).attr('rend_total'); x++){
									$('#renditions').append("<tr class='rend'><td><strong>&nbsp;</strong></td><td><div class='image-size-item'><input type='radio' name='radio_path' class='image-size-rend radio' value='"+$(target).attr('rend_' + razuna_servertype + '_url_org'+x)+"' id='radio_path' data-height='"+$(target).attr('rend_height'+x)+"' data-width='"+$(target).attr('rend_width'+x)+"' data-image-thumb='"+$(target).attr('data-' + razuna_servertype + '_url_thumb')+"'><label for='image-size-renditions' class='form_labels'>"+$(target).attr('rend_extension'+x).toUpperCase()+' ('+ parseInt($(target).attr('rend_width'+x))+'px X '+parseInt($(target).attr('rend_height'+x))+'px)'+"</label></div></td></tr>");
								}
								$('#razunaModalWindow').before($('#razunaImageDetails').html());
								$('#inner-div').addClass('inner-div');
		                        return false;
		                    }
		                }
		            }
		       },
			   "search" : {
					"case_insensitive" : true,
					"show_only_matches": true
				},
			"json_data" : {
				"ajax" : {
					"url" : razuna_folder+'?muraAction=razuna.getnodes',
					"data" : function (n) {
						return {
							"folderid" : n.attr ? n.attr("id") : 0
						};
					}
				}
			}
		});
		$('#razunaModalWindow').before($('#search_div'));
		}).dialog('open');

		return false;
	}


