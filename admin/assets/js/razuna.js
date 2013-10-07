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
	
	$(document).on('click','#razuna-search',{}, function() {
		$("#tagTree").jstree('open_all');
		$('#inner-div').hide();
		$('#loader-div').hide();
		$('#tagTree').css("width","835px");
		$('#full_page_loader').css('display','block');
		setTimeout(function(){
			$("#tagTree").jstree("search", $('#razuna-search-box').val());
			$('#full_page_loader').css('display','none');
		}, 2000);  
	});
	
	$(document).on('click','#razuna_insert_filename',{},function(){	
		$("input[name='" + razuna_targetname + "']").val(razuna_current_filename);
		$("input[name='" + razuna_targetname + "']").trigger('change');
		$('#razunaModalWindow').dialog("close");
		razunaRemovAll();
	});
	
	function razunaRemovAll(){
		$('.inner-div').remove();
		$('#loader-div').hide();
		$('#search_div').remove();
		$('#tagTree').css("width","835px");
	}
	
	function renderRazunaWindow(targetname){
		razuna_targetname=targetname;
		$('#razunaModalWindow').html('<div align="center"><img src="'+razuna_folder+'assets/images/ajax-loader.gif"></div>');
		$('#razunaModalWindow').dialog({
	        bgiframe: true,
	        autoOpen: false,
	        width: 860,
			height:450,
	        modal: true,
	        title: "Razuna" ,
	        close: razunaRemovAll
       	});
		
		$('#razunaModalWindow').load(razuna_folder+'?muraAction=razuna.default',function(){
			var loader_div = '<div id="razuna-loader-div"><div align="center" class="razuna-img-div"><img src="'+razuna_folder+'assets/images/ajax-loader.gif"></div></div>';
				$('#razunaModalWindow').before(loader_div);

		$("#razuna-tagTree").jstree({
			"plugins" : [ "json_data", "ui", "types", "search"],
			"types" : {
            	"types" : {
		                "folder" : {
		                    "hover_node" : false,
		                    "select_node" : function () {return false;}
		                },
		                "default" : {
		                    "select_node" : function (target) {
								$('#razuna-tagTree').css("width","266px");
								$('#razuna-inner-div').show();
								$('.razuna-inner-div').remove();
								$('#razuna-loader-div').show();
								$(target).attr('data-cloud_url_thumb',$(target).attr('data-cloud_url'));

								var type = $(target).attr('data-kind');
								if(type == 'aud'){
									var content='<tbody>';
										content+='		<tr>';
										content+='			<td valign="top">';
										content+='				<strong>File name : </strong><span>'+$(target).attr('data-filename_org')+'</span><br>';
										content+='				<strong>Kind : </strong><span>Audio</span><br><table border="0" id="renditions">';
										content+='			</td>';
										content+='		<tr>';
										content+='		<tr>';
										content+='			<td>&nbsp;</td>';
										content+='			<td ><div>';
										content+='					<input type="radio" checked="checked" name="radio_path" class="radio_path radio" value="'+$(target).attr('data-' + razuna_servertype + '_url_org')+'" id="radio_path" data-height="'+$(target).attr('data-height')+'" data-width="'+$(target).attr('data-width')+'">';
										content+='					<label for="radio_path_orig" class="form_labels">Original</label>';
										content+='				</div>';
										content+='			</td>';
										content+='		</tr>';
										content+='	</table>';
										content+='	</td>';
										content+='</tr>';
										content+='<tr>';
										content+='	<td>';
										content+='		<br>';
										content+='		<button type="button" data-id="'+$(target).attr('id')+'" id="insert_into_post" class="btn audio">Insert into Post</button>';
										content+='	</td>';
										content+='</tr>';
										content+='</tbody>';
								}
								else if(type == 'img'){
										razuna_current_filename=$(target).attr('data-' + razuna_servertype + '_url_org');
									var content='<tbody>';
										content+='		<tr>';
										content+='			<td>';
										content+='				<img src="'+$(target).attr('data-' + razuna_servertype + '_url_thumb')+'" id="razuna-show-image">';
										content+='			</td>';
										content+='			<td valign="top">';
										content+='				<strong>Filename : </strong><span>'+$(target).attr('data-filename_org')+'</span><br>';
										content+='				<strong>Type:</strong><span>Image</span><br>';
										content+='				<button id="razuna_insert_filename" class="btn image_org">Select File</button>';
										content+='			</td>';
										content+='		</tr>';
										/*
										content+='		<tr>';
										content+='			<td style="text-align:center;" colspan="3">';
										content+='				<button onclick="'+original+'" class="btn image_org">Select File</button>';
										content+='			</td>';
										content+='		</tr>';
										content+='		<tr>';
										content+='			<td colspan="3" style="text-align:center;">';
										content+='			</td>';
										content+='		</tr>';
										*/
										content+='	</tbody>';
								}
								else if(type == 'doc'){
									var content='<tbody>';
										content+='	<tr><td valign="top">';
										content+='			<strong>File name : </strong><span>'+$(target).attr('data-filename_org')+'</span><br>';
										content+='			<strong>Kind : </strong><span>Document</span><br>';
										content+='			<table border="0" id="renditions">';
										content+='			<tr><td>&nbsp;</td>';
										content+='				<td>';
										content+='					<div><input type="radio" checked="checked" name="radio_path" class="radio_path radio" value="'+$(target).attr('data-' + razuna_servertype + '_url_org')+'" id="radio_path" data-height="'+$(target).attr('data-height')+'" data-width="'+$(target).attr('data-width')+'">';
										content+='					<label for="doc-path-orig" class="form_labels">Original</label>';
										content+='					</div>';
										content+='				</td>';
										content+='			</tr>';
										content+='			</table>';
										content+='		</td>';
										content+='	</tr>';
										content+='	<tr>';
										content+='		<td><strong>Link Text:</strong></td>';
										content+='		<td><input type="text" value="" id="doc_link_text"></td>';
										content+='	</tr>';
										content+='	<tr>';
										content+='		<td>&nbsp;</td>';
										content+='		<td><br><button type="button" id="insert_into_post" class="btn document">Insert into Post</button></td>';
										content+='	</tr>';
										content+='</tbody>';
								}
								else if(type == 'vid'){
									var content='<tbody>';
										content+='	<tr>';
										content+='		<td valign="top"><strong>File name : </strong><span>'+$(target).attr('data-filename_org')+'</span><br>';
										content+='			<strong>Kind : </strong><span>Video</span><br><table border="0" id="renditions"><tr><td>&nbsp;';
										content+='		</td>';
										content+='		<td>';
										content+='			<div class="image-size-item"><input type="radio" checked="checked" name="radio_path" class="image-size-original radio" value="'+$(target).attr('data-' + razuna_servertype + '_url_org')+'" id="radio_path" data-height="'+$(target).attr('data-height')+'" data-width="'+$(target).attr('data-width')+'" data-image-thumb="'+$(target).attr('data-' + razuna_servertype + '_url_thumb')+'">';
										content+='			<label for="radio_path_orig" class="form_labels">Original</label>';
										content+='			</div>';
										content+='		</td>';
										content+='	</tr>';
										content+='	</table>';
										content+='	</td>';
										content+='	</tr>';
										content+='	<tr>';
										content+='		<td><strong>Width:</strong></td>';
										content+='		<td><input type="text" id="width" value="'+$(target).attr('data-width').toString().split(".")[0]+'" class="width"></td>';
										content+='	</tr>';
										content+='	<tr>';
										content+='		<td><strong>Height:</strong></td>';
										content+='		<td><input type="text" value="'+$(target).attr('data-height').toString().split(".")[0]+'" class="height" id="height"></td>';
										content+='	</tr>';
										content+='	<tr>';
										content+='		<td>&nbsp;</td>';
										content+='		<td><br><button type="button" data-id="'+$(target).attr('id')+'" id="insert_into_post" class="btn video">Insert into Post</button></td>';
										content+='	</tr>';
										content+='</tbody>';
								}
								$('.razuna-describe').html(content);
								$('.rend').remove();
								for(x=1; x<=$(target).attr('rend_total'); x++){
									$('#renditions').append("<tr class='rend'><td><strong>&nbsp;</strong></td><td><div class='razuna-image-size-item'><input type='radio' name='radio_path' class='image-size-rend radio' value='"+$(target).attr('rend_' + razuna_servertype + '_url_org'+x)+"' id='radio_path' data-height='"+$(target).attr('rend_height'+x)+"' data-width='"+$(target).attr('rend_width'+x)+"' data-image-thumb='"+$(target).attr('data-' + razuna_servertype + '_url_thumb')+"'><label for='image-size-renditions' class='form_labels'>"+$(target).attr('rend_extension'+x).toUpperCase()+' ('+ parseInt($(target).attr('rend_width'+x))+'px X '+parseInt($(target).attr('rend_height'+x))+'px)'+"</label></div></td></tr>");
								}
								$('#razunaModalWindow').before($('#razunaImageDetails').html());
								$('#razuna-inner-div').addClass('razuna-inner-div');
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
		$('#razunaModalWindow').before($('#razuna-search-div'));
		}).dialog('open');

		return false;
	}


