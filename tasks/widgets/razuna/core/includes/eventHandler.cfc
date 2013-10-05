/*
 *
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
component persistent="false" accessors="true" output="true" extends="mura.plugin.pluginGenericEventHandler" {

	// framework variables
	include 'fw1config.cfm';
	
	// ========================== Mura CMS Specific Methods ==============================
	// Add any other Mura CMS Specific methods you need here.

	public void function onApplicationLoad(required struct $) {
		
		/*
		variables.pluginConfig.addEventHandler(this);

		var rs=variables.pluginConfig.getAssignedSites();

		if(rs.recordcount){
			for(var s=1;s <= rs.recordcount;s++){
				$.getBean('settingsManager').getSite(rs.siteid[s]).setValue('hasRazuna',true);	
			}
		}

		getServiceFactory().declareBean(beanName="razunaSettings",dottedPath="razuna.lib.razunaSettings",isSingleton=false);
		getBean('razunaSettings').checkSchema();
		*/
	}
	
	function onAdminRequestStart(required struct $) {
		If( not checkAjaxRequest() ){
			pluginConfig.addToHTMLHeadQueue("includes/htmlhead.cfm");
		}
	}

	
	public void function onSiteRequestStart(required struct $) {
		arguments.$.setCustomMuraScopeKey(variables.framework.package, getApplication());
	}

	public void function onContentEdit(required struct $){
		writeDump(arguments.$);abort;
	}
	
	public any function onRenderStart(required struct $ ) {
		$.setCustomMuraScopeKey('rmp',this);
		$.setCustomMuraScopeKey('razunaMediaPlayer',this);
		variables.pluginpath="/plugins/#pluginconfig.getdirectory()#/";
	}
	
	function checkAjaxRequest(){
		var httpData = getHttpRequestData();
		var isAjaxRequest = ( structKeyExists(httpData, "headers") 
					AND structKeyExists(httpData.headers, "X-Requested-With") 
					AND httpData.headers["X-Requested-With"] EQ "XMLHttpRequest" );
		return isAjaxRequest;			 
	} 
	// ========================== Helper Methods ==============================
	
	public any function dspMedia(string file,numeric height, string image, numeric width){
			var local = structNew();
			if ( structKeyExists(variables, 'pluginConfig') ) {
				arguments.streamer = variables.pluginConfig.getSetting('streamurl');
			};
			savecontent variable="local.mediaplayer"{
				include "scripts.cfm";
			
				switch(listLast(arguments.file, '.')){
					case 'mp3':{
						writeoutput('<div class="flowplayerdetail" style="display:block;width:450px;height:20px;" href="#urlencodedformat(arguments.file)#"></div><script language="javascript" type="text/javascript">flowplayer("div.flowplayerdetail", "#pluginPath#assets/videoplayer/flowplayer-3.2.7.swf", {plugins: {controls: {fullscreen: false,height: 20}},clip: {autoPlay: false,onBeforeBegin: function() {$f("player").close();}}});</script>');
						break;
					}
					case 'ogg':{
						writeoutput('<audio controls="controls"><source src="#arguments.file#" type="audio/ogg" />Your browser does not support the <code>HTML5 video</code> element</audio><br>');
						break;
					}
					case 'wav':{
						writeOutput('<script language="JavaScript" type="text/javascript">QT_WriteOBJECT("#arguments.file#","450","30","","target","myself","controller","true","autoplay", "false","loop","false","bgcolor","##FFFFFF");</script>');
						break;
					}
					case 'ogv':{
						writeOutput('<video controls="true" poster="arguments.image"><source src="#arguments.file#" type="video/ogg" /></video>');
						break;
					}
					case 'webm':{
						writeOutput('<video controls="true" poster="arguments.image"><source src="#arguments.file#" type="video/webm" /></video>');
						break;
					}
					case 'mp4':{
						writeOutput('<a class="flowplayerdetail" href="#arguments.file#" style="display:block;width:#arguments.width#px;height:#arguments.width#px;"><img src="#arguments.image#" border="0"></a><script language="javascript" type="text/javascript">flowplayer("a.flowplayerdetail", "#variables.pluginpath#assets/videoplayer/flowplayer-3.2.7.swf",{clip: {autoBuffering: false,autoPlay: true,plugins: {controls: {all: false,play: true,scrubber: true,volume: true,mute: true,time: true,stop: true,fullscreen: true}}}});</script>');
						break;
					}
					case 'mov':{
						writeOutput('<a class="flowplayerdetail" href="#arguments.file#" style="display:block;width:#arguments.width#px;height:#arguments.width#px;"><img src="#arguments.image#" border="0"></a><script language="javascript" type="text/javascript">flowplayer("a.flowplayerdetail", "#variables.pluginpath#assets/videoplayer/flowplayer-3.2.7.swf",{clip: {autoBuffering: false,autoPlay: true,plugins: {controls: {all: false,play: true,scrubber: true,volume: true,mute: true,time: true,stop: true,fullscreen: true}}}});</script>');
						break;
					}
					case '3gp':{
						writeOutput('<a class="flowplayerdetail" href="#arguments.file#" style="display:block;width:#arguments.width#px;height:#arguments.width#px;"><img src="#arguments.image#" border="0"></a><script language="javascript" type="text/javascript">flowplayer("a.flowplayerdetail", "#variables.pluginpath#assets/videoplayer/flowplayer-3.2.7.swf",{clip: {autoBuffering: false,autoPlay: true,plugins: {controls: {all: false,play: true,scrubber: true,volume: true,mute: true,time: true,stop: true,fullscreen: true}}}});</script>');
						break;
					}
					case 'mpg4':{
						writeOutput('<a class="flowplayerdetail" href="#arguments.file#" style="display:block;width:#arguments.width#px;height:#arguments.width#px;"><img src="#arguments.image#" border="0"></a><script language="javascript" type="text/javascript">flowplayer("a.flowplayerdetail", "#variables.pluginpath#assets/videoplayer/flowplayer-3.2.7.swf",{clip: {autoBuffering: false,autoPlay: true,plugins: {controls: {all: false,play: true,scrubber: true,volume: true,mute: true,time: true,stop: true,fullscreen: true}}}});</script>');
						break;
					}
					case 'm4v':{
						writeOutput('<a class="flowplayerdetail" href="#arguments.file#" style="display:block;width:#arguments.width#px;height:#arguments.width#px;"><img src="#arguments.image#" border="0"></a><script language="javascript" type="text/javascript">flowplayer("a.flowplayerdetail", "#variables.pluginpath#assets/videoplayer/flowplayer-3.2.7.swf",{clip: {autoBuffering: false,autoPlay: true,plugins: {controls: {all: false,play: true,scrubber: true,volume: true,mute: true,time: true,stop: true,fullscreen: true}}}});</script>');
						break;
					}
					case 'swf':{
						writeOutput('<a class="flowplayerdetail" href="#arguments.file#" style="display:block;width:#arguments.width#px;height:#arguments.width#px;"><img src="#arguments.image#" border="0"></a><script language="javascript" type="text/javascript">flowplayer("a.flowplayerdetail", "#variables.pluginpath#assets/videoplayer/flowplayer-3.2.7.swf",{clip: {autoBuffering: false,autoPlay: true,plugins: {controls: {all: false,play: true,scrubber: true,volume: true,mute: true,time: true,stop: true,fullscreen: true}}}});</script>');
						break;
					}
					case 'flv':{
						writeOutput('<a class="flowplayerdetail" href="#arguments.file#" style="display:block;width:300px;height:500px;"><img src="#arguments.image#" border="0"></a><script language="javascript" type="text/javascript">flowplayer("a.flowplayerdetail", "#variables.pluginpath#assets/videoplayer/flowplayer-3.2.7.swf",{clip: {autoBuffering: false,autoPlay: true,plugins: {controls: {all: false,play: true,scrubber: true,volume: true,mute: true,time: true,stop: true,fullscreen: true}}}});</script>');
						break;
					}
					case 'f4v':{
						writeOutput('<a class="flowplayerdetail" href="#arguments.file#" style="display:block;width:#arguments.width#px;height:#arguments.width#px;"><img src="#arguments.image#" border="0"></a><script language="javascript" type="text/javascript">flowplayer("a.flowplayerdetail", "#variables.pluginpath#assets/videoplayer/flowplayer-3.2.7.swf",{clip: {autoBuffering: false,autoPlay: true,plugins: {controls: {all: false,play: true,scrubber: true,volume: true,mute: true,time: true,stop: true,fullscreen: true}}}});</script>');
						break;
					}
					default:{
						writeoutput('<p style="color:red;font-weight:bold;margin:10px 0px;">Unsupported Media!</p>');
					}
				}
				} // Save Content end
				return local.mediaplayer;
	}
	
	private any function getApplication() {
		if( !StructKeyExists(request, '#variables.framework.applicationKey#Application') ) {
			request['#variables.framework.applicationKey#Application'] = new '#variables.framework.package#.Application'();
		};
		return request['#variables.framework.applicationKey#Application'];
	}
	
}

