/* This file is part of Mura CMS. 

	Mura CMS is free software: you can redistribute it and/or modify 
	it under the terms of the GNU General Public License as published by 
	the Free Software Foundation, Version 2 of the License. 

	Mura CMS is distributed in the hope that it will be useful, 
	but WITHOUT ANY WARRANTY; without even the implied warranty of 
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
	GNU General Public License for more details. 

	You should have received a copy of the GNU General Public License 
	along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. 

	Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
	Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.
	
	However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
	or libraries that are released under the GNU Lesser General Public License version 2.1.
	
	In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
	independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
	Mura CMS under the license of your choice, provided that you follow these specific guidelines: 
	
	Your custom code 
	
	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories.
	
	 /admin/
	 /tasks/
	 /config/
	 /requirements/mura/
	 /Application.cfc
	 /index.cfm
	 /MuraProxy.cfc
	
	You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
	under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
	requires distribution of source code.
	
	For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
	modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
	version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS. */

var commentManager = {

	loadSearch: function(values){
		var url = './';
		var pars = 'muraAction=cComments.loadcomments&siteid=' + siteid + '&' + values + '&cacheid=' + Math.random();
		
		var d = $('#commentSearch');
		d.html('<div class="load-inline"></div>');
		$('#commentSearch .load-inline').spin(spinnerArgs2);
		$.get(url + "?" + pars, function(data) {
			$('#commentSearch').html(data);
					
			setDatePickers(".mura-custom-datepicker", dtLocale, dtCh);
			
			setCheckboxTrees();
			
			$('#advancedSearch').find('ul.categories:not(.checkboxTrees)').css("margin-left", "10px");
			
			commentManager.bindEvents();
		});
	},

	bulkEdit: function(){
		var values = $('#frmUpdate').serialize();
		var url = './';
		var pars = 'muraAction=cComments.bulkEdit&siteid=' + siteid + '&' + values + '&cacheid=' + Math.random();
		
		$.get(url + "?" + pars, function(){commentManager.submitSearch();});
	},

	singleEdit: function(commentid, updateaction){
		var url = './';
		var pars = 'muraAction=cComments.singleEdit&siteid=' + siteid + '&commentid=' + commentid + '&updateaction=' + updateaction + '&cacheid=' + Math.random();
		
		$.get(url + "?" + pars, function(){commentManager.submitSearch();});
	},

	submitSearch: function(){
		commentManager.loadSearch($('#commentSearch input, #commentSearch select').serialize());
	},

	setSort: function(k){
		$('#sortBy').val(k.attr('data-sortby'));
		$('#sortDirection').val(k.attr('data-sortdirection'));
		
		commentManager.submitSearch();
	},

	setNextN: function(k){
		$('#nextN').val(k.attr('data-nextn'));
				
		commentManager.submitSearch();
	},

	setPageNo: function(k){
		$('#pageNo').val(k.attr('data-pageno'));
				
		commentManager.submitSearch();
	},

	bindEvents: function(){

		$('#btnSearch').click(function(e){
			e.preventDefault();
			commentManager.submitSearch();
		});

		$('#frmSearch').submit(function(e){
			e.preventDefault();
			commentManager.submitSearch();
		});

		$('a.sort').click(function(e){
			e.preventDefault();
			commentManager.setSort($(this));
		});

		$('a.nextN').click(function(e){
			e.preventDefault();
			commentManager.setNextN($(this));
		});

		$('a.pageNo').click(function(e){
			e.preventDefault();
			commentManager.setPageNo($(this));
		});

		// CHECKBOXES
		$('#checkall').click(function (e) {
			e.preventDefault();
			var checkBoxes = $(':checkbox.checkall');
			checkBoxes.prop('checked', !checkBoxes.prop('checked'));
		});

		// APPROVE
		$('a.bulkEdit').click(function(e) {
			e.preventDefault();
			var k = $(this);
			confirmDialog(
				k.attr('data-alertmessage'),
				function(){
					$('#bulkedit').val(k.attr('data-action'));
					commentManager.bulkEdit();
				}
			)
		});

		// PURGE
		$('a#purge-comments').click(function(e) {
			e.preventDefault();
			var k = $(this);
			console.log('request to purge');
			confirmDialog(
				k.attr('data-alertmessage'),
				function(){
					console.log('purge approved');
					actionModal(function(){commentManager.purgeDeletedComments();});		
				}
			)
		});

		$('a.singleEdit').click(function(e) {
			e.preventDefault();
			$('.modal').modal('hide');
		
			var k = $(this);
			commentManager.singleEdit(k.attr('data-commentid'), k.attr('data-action'));

		});

		$('.modal').on('shown', function(){
			var k = $(this);

			var params = {
				contentID: k.attr('data-contentid'),
				commentID: k.attr('data-commentid')
			};

			k.find('div.modal-body').html('<div class="load-inline"></div>');
			k.find('div.modal-body .load-inline').spin(spinnerArgs2);
			
			commentManager.loadPage(params).success(function(data){
				k.find('div.modal-body').html(data);
				
				var elem = $('#detail-' + k.attr('data-commentid'));
					elem.fadeIn();

				k.find('div.modal-body').animate({ scrollTop: elem.position().top}, 'slow');

				commentManager.bindAjaxEvents(k);
			})
		});

		$('.modal').on('hidden', function(){
			var k = $(this);
			k.find('#commentsPage').remove();
			k.find('div.modal-body').html('<div class="load-inline"></div>');
			k.find('div.modal-body .load-inline').spin(spinnerArgs2);
		});

	},

	bindAjaxEvents: function(k) {
		k.find('#moreCommentsUp').unbind('click').on('click', function(e){
			e.preventDefault();
			var params = {
				contentID: k.attr('data-contentid'),
				upperID: $(this).attr('data-upperid')
			};
			
			commentManager.loadPage(params).success(function(data){
				k.find('#moreCommentsUpContainer').remove();
				//k.find('#commentsPage').prepend(data);
				$(data).prependTo(k.find('#commentsPage')).hide().fadeIn();
				commentManager.bindAjaxEvents(k);
			});
		});

		k.find('#moreCommentsDown').unbind('click').on('click', function(e){
			e.preventDefault();
			var params = {
				contentID: k.attr('data-contentid'),
				lowerID: $(this).attr('data-lowerid')
			};
			
			commentManager.loadPage(params).success(function(data){
				k.find('#moreCommentsDownContainer').remove();
				//k.find('#commentsPage').append(data);
				$(data).appendTo(k.find('#commentsPage')).hide().fadeIn();
				commentManager.bindAjaxEvents(k);
			});
		});

		k.find('.inReplyTo').on('click',function(e){
			e.preventDefault();
			
			var parentid = $(this).attr('data-parentid');

			if($('#detail-' + parentid).length) {
				commentManager.scrollToID($('#detail-' + parentid));
			} else {
				var params = {
					contentID: k.attr('data-contentid'),
					upperID: $(this).attr('data-parentid')
				};

				commentManager.loadPage(params).success(function(data){
					k.find('#moreCommentsUpContainer').remove();
					//k.find('#commentsPage').prepend(data);
					$(data).prependTo(k.find('#commentsPage')).hide().fadeIn();
					commentManager.bindAjaxEvents(k);
					commentManager.scrollToID($('#detail-' + parentid));
				});
			}
			
		});

	},

	scrollToID: function(elem) {
		$('html, body').animate({
			scrollTop: elem.offset().top - 50
		}, 500, function(){
			elem.fadeTo('fast', 0.5, function() {
				elem.fadeTo('fast', 1);
			});
		});
	},

	loadPage: function(ext) {
		var params = {
			muraAction: "ccomments.loadcommentspage",
			sortDirection: 'asc',
			siteid: siteid
		};

		$.extend(params, ext);
		
		return $.ajax({
			url: './',
			data: params,
			cache: false
		});
	},

	purgeDeletedComments: function(){
		var url = './';
		var pars = 'muraAction=cComments.purgeDeletedComments&siteid=' + siteid + '&cacheid=' + Math.random();
		$.get(url + "?" + pars, function(){
			$('#action-modal').remove();
			commentManager.submitSearch();
		});
	}
}
