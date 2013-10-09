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
	
	$(document).on('change','input[name=razuna-selected-url]',{},function(){
		$('#razuna-width').val(parseInt($(this).attr('data-width')));
		$('#razuna-height').val(parseInt($(this).attr('data-height')));
	});
	
	$(document).on('click','#razuna-search',{}, function() {
		$("#razuna-tagTree").jstree('open_all');
		$('#razuna-inner-div').hide();
		$('#razuna-loader-div').hide();
		$('#razuna-tagTree').css("width","835px");
		$('#razuna-full_page_loader').css('display','block');
		setTimeout(function(){
			$("#razuna-tagTree").jstree("razuna-search", $('#razuna-search-box').val());
			$('#razuna-full_page_loader').css('display','none');
		}, 2000);  
	});
	
	$(document).on('click','#razuna-insert',{},function(){	

		var url=$('input[name="razuna-selected-url"]:checked').val();

		if(typeof razuna_target == 'string'){
			$("input[name='" + razuna_target + "']").val($('input[name="razuna-selected-url"]:checked').val());
			$("input[name='" + razuna_target + "']").trigger('change');
		} else {
			var add_to_editor='';
		
			if($(this).hasClass('image')) {
				if($('#razuna-urlfield').val() != ''){
					add_to_editor = "<a href='"+ $('#razuna-urlfield').val() +"'><img title='" + $('#razuna-img-title-text').val() + "' src='" + url + "' alt='"+$('#razuna-alt-text').val()+"'></a>";
				} else {
					add_to_editor = "<img title='" + $('#razuna-img-title-text').val() + "' src='" + url + "' alt='" + $('#razuna-alt-text').val() + "'>";
				}
				
			}
			else if ($(this).hasClass('audio')) {
				add_to_editor = "<div>[mura]$.razunaMediaPlayer.dspMedia(file='" + url + "',width=450,height=30,sharecode=true,embedlink=true)[/mura]</div>";
			}
			else if ($(this).hasClass('video')) {
				add_to_editor = "<div>[mura]$.razunaMediaPlayer.dspMedia(file='" + url + "',width='" + $('#razuna-width').val() + "',height='" + $('#razuna-height').val() + "',image='"+$('input[type="radio"][name="razuna-selected-url"]:checked').attr('data-image-thumb')+"',sharecode=true,embedlink=true)[/mura]</div>";
			}
			else if ($(this).hasClass('document')) {
				if ($('#razuna-link-text').val() == "") {
					$('.razuna-doc-link-error').remove();
					$('#razuna-link-text').css({'border':'1px solid red'}).after('<span class="razuna-doc-link-error" style="color:red;"> This field is required<span>');
					return false;
				}
				else {
					add_to_editor = "<a href = '" + url + "' target='_blank'>" + $('#razuna-link-text').val() + "</a>";
				}
			}
			
			razuna_target.insertHtml(add_to_editor);
		}

		$('#razunaModalWindow').dialog("close");
		razunaRemovAll();
	});
	
	function razunaRemovAll(){
		$('.razuna-inner-div').remove();
		$('#razuna-loader-div').hide();
		$('#razuna-search-div').remove();
		$('#razuna-tagTree').css("width","835px");
	}

	function renderRazunaWindow(target){
		razuna_target=target;
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
										content+='			<td>';
										content+='				&nbsp;';
										content+='			</td>';
										content+='			<td valign="top">';
										content+='				<strong>Filename : </strong><span>'+$(target).attr('data-filename_org')+'</span><br>';
										content+='				<strong>Type : </strong><span>Audio</span><br>';
										content+='				<table border="0" id="renditions">';
										content+='				<tr class="rend">';
										content+='					<td>&nbsp;</td>';
										content+='					<td><label class="radio inline">';
										content+='						<input type="radio" checked="checked" name="razuna-selected-url" value="'+$(target).attr('data-' + razuna_servertype + '_url_org')+'" data-height="'+$(target).attr('data-height')+'" data-width="'+$(target).attr('data-width')+'">';
										content+='						Original</label>';
										content+='					</td>';
										content+='				</tr>';
										content+='				</table>';
										content+='				<br><button type="button" id="razuna-insert" class="btn audio">Select File</button>';
										content+='			</td>';
										content+='		</tr>';
										content+='</tbody>';
								}
								else if(type == 'img'){
								
									var content='<tbody>';
										content+='		<tr>';
										content+='			<td valign="top">';
										content+='				<img src="'+$(target).attr('data-' + razuna_servertype + '_url_thumb')+'" id="razuna-show-image">';
										content+='			</td>';
										content+='			<td valign="top">';
										content+='				<strong>Filename : </strong><span>'+$(target).attr('data-filename_org')+'</span><br>';
										content+='				<strong>Type : </strong><span>Image</span><br>';
										content+='				<table border="0" id="renditions">';
										if(typeof razuna_target == 'object'){
										content+='				<tr class="rend">';
										content+='					<td><strong>Size:</strong></td>';
										content+='					<td><label class="radio inline">';
										content+='						<input type="radio" id="razuna-image-size" checked="checked" name="razuna-selected-url" value="'+$(target).attr('data-' + razuna_servertype + '_url_thumb')+'"  data-height="'+$(target).attr('data-height')+'" data-width="'+$(target).attr('data-width')+'">Thumbnail</label>';
										content+='					</td>';
										content+='				</tr>';
										}
										content+='				<tr class="rend">';
										content+='					<td>&nbsp;</td>';
										content+='					<td><label class="radio inline">';
										content+='						<input type="radio"';
										if(typeof razuna_target != 'object'){
										content+='						checked="checked";'
										}  
										content+='						name="razuna-selected-url" value="'+$(target).attr('data-' + razuna_servertype + '_url_org')+'" data-height="'+$(target).attr('data-height')+'" data-width="'+$(target).attr('data-width')+'">';
										content+='						Original</label>';
										content+='					</td>';
										content+='				</tr>';
										content+='				</table>';
										if(typeof razuna_target == 'object'){
										content+='				<table border="0">';
										content+='				<tr><td><strong>Width:</strong></td><td><input type="text" id="razuna-width" value="'+$(target).attr('data-width').toString().split(".")[0]+'"></td></tr>';
										content+='				<tr><td><strong>Height:</strong></td><td><input type="text" value="'+$(target).attr('data-height').toString().split(".")[0]+'" id="razuna-height"></td></tr>'
										content+='				<tr><td><strong>Alternate text:</strong></td><td><input type="text" id="razuna-alt-text" value="'+$(target).attr('data-filename_org')+'"></td></tr>';
										content+='				<tr><td><strong>Title:</strong></td><td><input type="text" value="" id="razuna-img-title-text"></td></tr>';
										content+='				<tr><td><strong>Link URL:</strong></td><td><input type="text" id="razuna-urlfield"></td></tr>';
										content+='				</table>';
										}
										
										content+='				<br><button type="button" id="razuna-insert" class="btn image">Select File</button>';
										content+='			</td>';
										content+='		</tr>';
										content+='</tbody>';
								}
								else if(type == 'doc'){
									var content='<tbody>';
										content+='		<tr>';
										content+='			<td>';
										content+='				&nbsp;';
										content+='			</td>';
										content+='			<td valign="top">';
										content+='				<strong>Filename : </strong><span>'+$(target).attr('data-filename_org')+'</span><br>';
										content+='				<strong>Type : </strong><span>Document</span><br>';
										content+='				<table border="0" id="renditions">';
										content+='				<tr class="rend">';
										content+='					<td>&nbsp;</td>';
										content+='					<td><label class="radio inline">';
										content+='						<input type="radio" checked="checked" name="razuna-selected-url" value="'+ $(target).attr('data-' + razuna_servertype + '_url_org') +'" data-height="'+$(target).attr('data-height')+'" data-width="'+$(target).attr('data-width')+'">';
										content+='						Original</label>';
										content+='					</td>';
										content+='				</tr>';
										content+='				</table>';
										if(typeof razuna_target == 'object'){
										content+='				<table border="0">';
										content+='				<tr><td><strong>Link Text:</strong></td><td><input type="text" value="" id="razuna-link-text"></td></tr>';
										content+='				</table>';
										}
										content+='				<br><button type="button" id="razuna-insert" class="btn document">Select File</button>';
										content+='			</td>';
										content+='		</tr>';
										content+='</tbody>';
								}
								else if(type == 'vid'){
									var content='<tbody>';
										content+='		<tr>';
										content+='			<td>';
										content+='				&nbsp;';
										content+='			</td>';
										content+='			<td valign="top">';
										content+='				<strong>Filename : </strong><span>'+$(target).attr('data-filename_org')+'</span><br>';
										content+='				<strong>Type : </strong><span>Video</span><br>';
										content+='				<table border="0" id="renditions">';
										content+='				<tr class="rend">';
										content+='					<td>&nbsp;</td>';
										content+='					<td><label class="radio inline">';
										content+='						<input type="radio" checked="checked" name="razuna-selected-url" value="'+$(target).attr('data-' + razuna_servertype + '_url_org')+'" data-height="'+$(target).attr('data-height')+'" data-width="'+$(target).attr('data-width')+'" data-image-thumb="'+$(target).attr('data-' + razuna_servertype + '_url_thumb')+'">';
										content+='						Original</label>';
										content+='					</td>';
										content+='				</tr>';
										content+='				</table>';
										content+='				<br><button type="button" id="razuna-insert" class="btn video">Select File</button>';
										content+='			</td>';
										content+='		</tr>';
										content+='</tbody>';

								}
								$('.razuna-describe').html(content);
								//$('.rend').remove();
								for(x=1; x<=$(target).attr('rend_total'); x++){
									$('#renditions').append("<tr class='rend'><td><strong>&nbsp;</strong></td><td><label class='radio inline'><input type='radio' name='razuna-selected-url' value='"+$(target).attr('rend_' + razuna_servertype + '_url_org'+x)+"' data-height='"+$(target).attr('rend_height'+x)+"' data-width='"+$(target).attr('rend_width'+x)+"' data-image-thumb='"+$(target).attr('data-' + razuna_servertype + '_url_thumb')+"'>"+$(target).attr('rend_extension'+x).toUpperCase()+' ('+ parseInt($(target).attr('rend_width'+x))+'px X '+parseInt($(target).attr('rend_height'+x))+'px)'+"</label></td></tr>");
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


