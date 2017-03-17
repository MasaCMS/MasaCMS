<!---
	EMBED:

	<script src="https://domain.com/{siteid}/variation" async>
--->
<cfcontent reset="yes" type="application/javascript">
<cfset isIeSix=FindNoCase('MSIE 6','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>
<cfset $=application.serviceFactory.getBean("MuraScope").init(url.siteID)>
<cfset $.getBean('utility').suppressDebugging()>
<cfparam name="session.siteid" default="#url.siteid#">
<cfparam name="url.contenttype" default="">
<cfif not structKeyExists(session,"rb")>
	<cfset application.rbFactory.resetSessionLocale()>
</cfif>
<cfcontent reset="true"><cfparam name="Cookie.fetDisplay" default="">
<cfinclude template="/muraWRM/default/js/dist/mura.min.js">

    /*
    	BEGIN Mura VARIATION TOOLS
    */

    (function (exports) {
      	<cfoutput>
      	var self=this;
      	var apiEndpoint="#$.siteConfig().getApi().getEndpoint()#";
      	var requirementspath="#$.siteConfig().getRequirementsPath(complete=1)#";
      	var loginurl="#$.globalConfig().getAdminPath()#/?muraAction=clogin.main";
      	var content=null;
      	var variations=[];
      	var origvariations=[];
      	var adminpath="#$.globalConfig('adminpath')#";
      	var assetpath="#$.siteConfig().getResourcePath(complete=1)#" + "#$.siteConfig().getAssetPath()#";
      	var themepath="#$.siteConfig().getResourcePath(complete=1)#" + "#$.siteConfig().getThemeAssetPath()#";
    	var context="#$.siteConfig().getResourcePath(complete=1)#";
      	var editableSelector='.mxp-editable';
      	var currentId='';
    	var theme="#$.siteConfig().getTheme()#";
      	</cfoutput>

        function loadScript(url, callback) {

            var script = document.createElement("script")
            script.type = "text/javascript";

            if (script.readyState) { //IE
                script.onreadystatechange = function () {
                    if (script.readyState == "loaded" || script.readyState == "complete") {
                        script.onreadystatechange = null;
                        callback();
                    }
                };
            } else { //Others
                script.onload = function () {
                    callback();
                };
            }

            script.src = url;
            document.getElementsByTagName("head")[0].appendChild(script);
        }

        var pathname=location.pathname.split('/');

        if(pathname[pathname.length-1].split('.')[0]=='index'){
        	pathname.pop();
        	pathname=pathname.join('/');
        	pathname=pathname + '/';
        } else {
        	pathname=pathname.join('/');
        }

        var loc=[location.host, pathname].join('');
        var remoteurl=[location.protocol,'//',location.host, pathname].join('');
    	var lochash=Mura.hashCode(loc);

    	var initVariations=function(fn,leadprops){

    		if(location.search.indexOf("doaction=logout") > -1){
    			Mura.ajax({
    		        type:"POST",
    		        dataType: 'json',
    		        xhrFields:{ withCredentials: true },
    		        crossDomain:true,
    		        url:apiEndpoint + '/logout',
    		        success:function(){
    		        	location.href=remoteurl;
    		        }
    		    });
    		}

    		var init=function(data){


    			content=data.data;

    			if(!content.remoteid || !content.remoteurl){
    				content.remoteid=lochash;
    				content.remoteurl=remoteurl;
    			}

    			if(!content.title){
    				content.title=loc;
    			}

    			content.config=Mura.extend({
    				content:content,
    				loginurl:loginurl,
    				variations:variations,
    				origvariations:origvariations,
    				editableSelector:editableSelector,
    				siteid:content.siteid,
    				contentid:content.contentid,
    				contenthistid:content.contenthistid,
    				moduleid:content.moduleid,
                    parentid:content.parentid,
    				type:content.type,
    				subtype:content.subtype,
    				preloaderMarkup:'',
    				apiEndpoint:apiEndpoint + '/',
    				remoteid:content.remoteid,
    				remoteurl:content.remoteurl,
    				title:content.title,
    				context:context
    			});


    			if(content.targetingjs){
    				try{
    					var selectors=eval('(' + content.targetingjs + ')');

    					if(typeof selectors =='object'){
    						for(var i=0, len=selectors.length; i < len; i++){
    							var item=Mura(selectors[i]);
    							if(item.length){
    								item.addClass('mxp-editable');
    							}
    						}
    					}
    				} catch(e) {
    					console.error(e);
    				}
    			}

    			if(content.initjs){
    				try{
    				eval('(' + content.initjs + ')');
    				} catch(e) {
    					console.error(e);
    				}
    			}

    			Mura.init(content.config);

    			var footer=document.createElement('DIV');
    			footer.setAttribute('id','mura-remote-footer');
    			window.document.body.appendChild(footer);
    			Mura('#mura-remote-footer').html(content.htmlheadqueue + content.htmlfootqueue);

    			Mura
    				.loader()
    				.loadcss(assetpath + '/css/mura.7.0.min.css')
    				.loadcss(assetpath + '/css/mura.7.0.skin.css')
    				.loadcss(themepath + '/css/theme/theme.min.css');


    			if(content.body){
    				try{
    					Mura.variations=eval('(' + content.body + ')');
    					Mura.origvariations=variations.slice();
    				} catch(e){
    					try{
    						Mura.variations=eval('(' + decodeURIComponent(content.body) + ')');
    						Mura.origvariations=variations.slice();
    					} catch(e){
    						console.log(e)
    						Mura.variations=[];
    						Mura.origvariations=[];
    					}
    				}
    			} else {
    				Mura.variations=[];
    				Mura.origvariations=[];
    			}

				<cfif getServiceFactory().containsBean('marketingManager')>
    			if(typeof ga == 'undefined'){
    			  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    			  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    			  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    			  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
    			}

    			ga('create', content.ga.trackingid, 'auto','mxpGATracker');
    			ga('mxpGATracker.send','pageview', content.ga.trackingvars);

    			Mura.loader().loadjs(
    				context + '/plugins/MXP/assets/js/metrics/scrolldepth.js',
    				context + '/plugins/MXP/assets/js/metrics/riveted.js',
    				function(){
    					//ScrollDepth
    					scrollDepth.init({
    					  gaGlobal: false
    					  // Uncomment to manually send scroll data to MA and GA
    					  ,eventHandler: function(scrollDepth) {

    						if(typeof mxpMktoData != 'undefined'){
    						    if (scrollDepth.event == 'ScrollDistance' && scrollDepth.eventAction == 'Percentage'){
    						    	//Send to Mkto
    						    	mxpMktoData({
    							    	'scrollDepth':scrollDepth.eventLabel
    						    	});
    						    }

    							if(typeof mxpData != 'undefined'){
    								mxpData({
    							    	'activeTime':data
    						    	});
    							}
    						}

    					    //Send to GA
    						var eventData= { eventCategory: scrollDepth.eventCategory, eventAction: scrollDepth.eventAction, eventLabel: scrollDepth.eventLabel, nonInteraction:true};
    						Mura.extend(eventData,content.ga.trackingvars);
    						ga('mxpGATracker.send', 'event', eventData);

    					  }
    					});

    					// Riveted (Active Time)
    					riveted.init({
    						reportInterval: 10
    						// Uncomment to manually send active time data to MA and GA
    						,eventHandler: function(data) {

    							if(typeof mxpMktoData != 'undefined'){
    							    mxpMktoData({
    							    	'activeTime':data
    						    	});
    							}

    							if(typeof mxpData != 'undefined'){
    								mxpData({
    							    	'activeTime':data
    						    	});
    							}

    					    	//Send to GA
    							var eventData= { eventCategory: 'Active Time', eventAction: 'Seconds', eventLabel: data.toString(), eventValue: data, nonInteraction:true};
    							Mura.extend(eventData,content.ga.trackingvars);
    							ga('mxpGATracker.send', 'event', eventData);
    						}
    					});
    				}
    			);
				</cfif>

    			Mura('.mxp-editable').each(function(){
    				var item=Mura(this);
    				if(!item.attr('id')){
    					item.attr('id','mxp' + Mura.hashCode(item.selector()));
    					item.addClass('mxp-dynamic-id');
    				}
    			});

    			var applyVariations=function(){

    				for(var i=0;i<Mura.variations.length;i++){
    					var item=Mura(Mura.variations[i].selector);
    					//if(item.html().replace(/\s+/g,' ')==Mura.variations[i].original.replace(/\s+/g,' ')){
    						Mura.variations[i].original=item.html();
    						item.html(Mura.variations[i].adjusted);
    					//}

    				}
    			};

    			applyVariations();
    		}

    		leadprops=leadprops || '';

    		function readCookie(name) {
    			var nameEQ = name + "=";
    			var ca = document.cookie.split(';');
    			for(var i=0;i < ca.length;i++) {
    				var c = ca[i];
    				while (c.charAt(0)==' ') c = c.substring(1,c.length);
    				if (c.indexOf(nameEQ) == 0) return decodeURIComponent(c.substring(nameEQ.length,c.length));
    			}
    			return "";
    		}

    		var trackingparams='&cb=' + Math.random();

    		var mkto_trk=readCookie('_mkto_trk');

    		if(mkto_trk){
    			console.log('_mkto_trk=' + mkto_trk);
    			trackingparams+='&mkto_trk=' + encodeURIComponent(mkto_trk);
    		}

    		var sp_trk=readCookie('com.silverpop.iMAWebCookie');

    		if(sp_trk){
    			console.log('com.silverpop.iMAWebCookie=' + sp_trk);
    			trackingparams+='&sp_trk=' + encodeURIComponent(sp_trk);
    		}

    		var mautic_trk=readCookie('mtc_id');

    		if(mautic_trk){
    			console.log('mautic_trk=' + mautic_trk);
    			trackingparams+='&mautic_trk=' + encodeURIComponent(mautic_trk);
    		}

    		Mura.ajax({
    	        type:"GET",
    	        dataType: 'json',
    	        xhrFields:{ withCredentials: true },
    	        crossDomain:true,
    	        url:apiEndpoint + '/content/_variation/'+ lochash + '?' + location.search.slice(1) + '&leadprops=' + leadprops + trackingparams,
    	        success:function(resp){
    	        	//console.log(resp)
    	        	init(resp);
    	        	if(typeof fn == 'function'){
    	        		fn(resp.data);
    	        	}

    	        	Mura('.mxp-loader').hide();
    	        }
    	    });

    	}

    	//legacy support
    	Mura.initVariations=function(){};

    	initVariations(function(data){
    		//Look for callback method
    		if(typeof mxpInitCallback =='function'){
    			mxpInitCallback(data);
    		}
     	});


    })(window);
