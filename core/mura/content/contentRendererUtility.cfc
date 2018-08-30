<cfcomponent extends="mura.cfobject" output="false" hint="This provides content rendering utiility methods">

	<cffunction name="init" output="false">
		<cfset variables.intervalManager=getBean('contentIntervalManager')>
		<cfreturn this>
	</cffunction>

	<cffunction name="dspZoomNoLinks" output="false">
		<cfargument name="crumbdata" required="yes" type="array">
		<cfargument name="fileExt" type="string" default="" hint="deprecated, this is now in the crumbData">
		<cfargument name="class" type="string" default="breadcrumb">
		<cfargument name="charLimit" type="numeric" default="0">
		<cfargument name="minLevels" type="numeric" default="0">
		<cfargument name="maxLevels" type="numeric" default="0">
		<cfargument name="renderer">
		<cfset var content = "">
		<cfset var locked = "">
		<cfset var lastlocked = "">
		<cfset var crumbLen = arrayLen(arguments.crumbdata)>
		<cfset var i = 0 />
		<cfset var icon = "">
		<cfset var isFileIcon = false>
		<cfset var charCount = 0>
		<cfset var limited = false>
		<cfif arguments.charLimit>
			<!--- change crumbLen --->
			<cfloop from="1" to="#arrayLen(arguments.crumbdata)#" index="i">
				<cfset charCount = charCount + len(arguments.crumbdata[i].menutitle) + 3> <!--- add 3 to offset the icon width--->
				<cfif charCount gte arguments.charLimit>
					<cfset crumbLen = i - 1>
					<cfset limited = true>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfif arguments.minLevels and crumbLen lt arguments.minLevels and arguments.minLevels lte arrayLen(arguments.crumbdata)>
			<cfset crumbLen = arguments.minLevels>
		</cfif>
		<cfif arguments.maxLevels and crumbLen gt arguments.maxLevels and arguments.maxLevels lte arrayLen(arguments.crumbdata)>
			<cfset crumbLen = arguments.maxLevels>
		</cfif>
		<cfsavecontent variable="content">
		<cfoutput>
		<ul class="#arguments.class#">
		<cfloop from="#crumbLen#" to="2" index="i" step="-1">
			<cfsilent>
				<cfif arguments.crumbdata[i].restricted eq 1><cfset locked="locked"></cfif>
				<cfset icon=arguments.renderer.renderIcon(arguments.crumbdata[i])>
				<cfset isFileIcon=arguments.crumbdata[i].type eq 'File' and listFirst(icon,"-") neq "mi">
			</cfsilent>
			<li class="#icon# #locked#<cfif isFileIcon> file</cfif>"<cfif isFileIcon> data-filetype="#left(icon,4)#"</cfif>> #HTMLEditformat(arguments.crumbdata[i].menutitle)#</li>
		</cfloop>
		<cfsilent>
			<cfif locked eq "locked" or arguments.crumbdata[1].restricted eq 1>
				<cfset lastlocked="locked">
			</cfif>
			<cfset icon=arguments.renderer.renderIcon(arguments.crumbdata[1])>
			<cfset isFileIcon=arguments.crumbdata[1].type eq 'File' and listFirst(icon,"-") neq "mi">
		</cfsilent>
		<li class="#icon# #locked#<cfif isFileIcon> file</cfif>"<cfif isFileIcon> data-filetype="#left(icon,4)#"</cfif>> <strong>#HTMLEditformat(arguments.crumbdata[1].menutitle)#</strong></li>
		</ul></cfoutput></cfsavecontent>

		<cfreturn content />
	</cffunction>

	<cffunction name="renderEditableAttribute" output="false">
		<cfargument name="attribute">
		<cfargument name="type" default="text">
		<cfargument name="required" default="false">
		<cfargument name="validation" default="">
		<cfargument name="message" default="">
		<cfargument name="label">
		<cfargument name="value">
		<cfargument name="enableMuraTag" default="true">
		<cfargument name="renderer">
		<cfscript>
			if(not structKeyExists(arguments,'label')){
				arguments.label=arguments.attribute;
			}

			arguments.attribute=lcase(arguments.attribute);

			if(not structKeyExists(arguments,'value')){
				arguments.value=arguments.renderer.getMuraScope().content(arguments.attribute);
			}

			if(arguments.enableMuraTag){
				arguments.value=arguments.renderer.setDynamicContent(arguments.value);
			}

			var perm=(listFindNoCase('editor,author',arguments.renderer.getMuraScope().event('r').perm) or listFind(getSession().mura.memberships,'S2'));
			var layoutManager=arguments.renderer.useLayoutmanager();

			if(arguments.renderer.getShowToolbar() && arguments.renderer.showInlineEditor && perm){

				var dataString='';
				var inline=' inline';
				var cssClass="";

				dataString=' data-attribute="#arguments.attribute#" data-type="#arguments.type#"';

				if(yesNoFormat(arguments.required)){
					dataString=dataString & ' data-required="true"';
				} else {
					dataString=dataString & ' data-required="false"';
				}

				if(len(arguments.validation)){
					dataString=dataString & ' data-validate="#arguments.validation#"';
				}

				dataString=dataString & ' data-message="#HTMLEditFormat(arguments.message)#"';
				dataString=dataString & ' data-label="#HTMLEditFormat(arguments.label)#"';

				if(arguments.type == 'HTMLEditor' ){
					inline='';

					if(not len(arguments.value)){
						arguments.value="<p></p>";
					}

					if(layoutManager){
						cssClass='mura-region-local ';
						dataString=dataString & ' data-loose="true" data-perm="true" data-inited="false"';

						cssClass=cssClass & "mura-inactive mura-editable-attribute#inline#";

						return '<div class="mura-region mura-region-loose mura-editable mura-inactive#inline#">
							<label class="mura-editable-label">#ucase(arguments.label)#</label>
							<div contenteditable="false" id="mura-editable-attribute-#arguments.attribute#" class="#cssClass#" #dataString#>#arguments.value#</div>
							</div>';
					} else {

						cssClass=cssClass & "mura-inactive mura-editable-attribute#inline#";

						return '<div class="mura-editable mura-inactive#inline#">
							<label class="mura-editable-label">#ucase(arguments.label)#</label>
							<div contenteditable="false" id="mura-editable-attribute-#arguments.attribute#" class="#cssClass#" #dataString#>#arguments.value#</div>
							</div>';

					}

				} else {
					cssClass=cssClass & "mura-inactive mura-editable-attribute#inline#";

					return '<div class="mura-editable mura-inactive#inline#">
						<label class="mura-editable-label">#ucase(arguments.label)#</label>
						<div contenteditable="false" id="mura-editable-attribute-#arguments.attribute#" class="#cssClass#" #dataString#>#arguments.value#</div>
						</div>';

				}
			} else if (layoutManager && arguments.type == 'htmlEditor'){

				return '<div class="mura-region mura-region-loose">
					<div class="mura-region-local">#arguments.value#</div>
					</div>';
			} else {
				return arguments.value;
			}
		</cfscript>
	</cffunction>

	<cffunction name="iconClassByContentType" output="false">
		<cfargument name="type">
		<cfargument name="subtype" default="Default">
		<cfargument name="siteid" default="">

		<cfif len(arguments.siteID)>
			<cfset var iconclass=application.classExtensionManager.getCustomIconClass(siteid=arguments.siteid,type=arguments.type,subtype=arguments.subtype)>

			<cfif len(iconclass)>
				<cfreturn iconclass>
			</cfif>
		</cfif>

		<cfswitch expression="#arguments.type#">
		<cfcase value="Folder">
			<cfreturn "mi-folder-open-o">
		</cfcase>
		<cfcase value="Calendar">
			<cfreturn "mi-calendar">
		</cfcase>
		<cfcase value="Component">
			<cfreturn "mi-align-justify">
		</cfcase>
		<cfcase value="Gallery">
			<cfreturn "mi-th">
		</cfcase>
		<cfcase value="GalleryItem">
			<cfreturn "mi-picture">
		</cfcase>
		<cfcase value="Link">
			<cfreturn "mi-link">
		</cfcase>
		<cfcase value="Quick">
			<cfreturn "mi-upload">
		</cfcase>
		<cfcase value="File">
			<cfreturn "mi-file-text-o">
		</cfcase>
		<cfcase value="Form">
			<cfreturn "mi-toggle-on">
		</cfcase>
		<cfdefaultcase>
			<cfreturn "mi-file">
		</cfdefaultcase>
		</cfswitch>

	</cffunction>

	<cffunction name="generateListImageStyles" output="false">
		<cfargument name="size" default="small">
		<cfargument name="height" default="auto">
		<cfargument name="width" default="auto">
		<cfargument name="padding" default="#this.contentListImagePadding#">
		<cfargument name="setHeight" default="true">
		<cfargument name="setWidth" default="true">
		<cfargument name="renderer">

		<cfset var imageStyles=structNew()>
		<cfset var customImageSize="">
		<cfset imageStyles.markup="">

		<cfif arguments.size eq "" or
			(arguments.size eq "Custom"
			and arguments.width eq "auto"
			and arguments.height eq "auto")>
			<cfset arguments.size="small">
		</cfif>
		<cfif arguments.size eq "large">
			<cfset arguments.size = "main" />
		</cfif>

		<cfif listFindNoCase('small,medium,large',arguments.size)>
			<cfif isNumeric(arguments.renderer.getMuraScope().siteConfig('#arguments.size#ImageWidth'))>
				<cfset imageStyles.paddingLeft=arguments.renderer.getMuraScope().siteConfig('#arguments.size#ImageWidth') + arguments.padding>
			<cfelse>
				<cfset imageStyles.paddingLeft="auto">
			</cfif>
			<cfif isNumeric(arguments.renderer.getMuraScope().siteConfig('#arguments.size#ImageHeight'))>
				<cfset imageStyles.minHeight=arguments.renderer.getMuraScope().siteConfig('#arguments.size#ImageHeight') + arguments.padding>
			<cfelse>
				<cfset imageStyles.minHeight="auto">
			</cfif>
		<cfelseif arguments.size eq 'custom'>
			<cfif isNumeric(arguments.width)>
				<cfset imageStyles.paddingLeft=arguments.width + arguments.padding>
			<cfelse>
				<cfset imageStyles.paddingLeft="auto">
			</cfif>
			<cfif isNumeric(arguments.height)>
				<cfset imageStyles.minHeight=arguments.height + arguments.padding>
			<cfelse>
				<cfset imageStyles.minHeight="auto">
			</cfif>
		<cfelse>
			<cfset customImageSize=getBean('imageSize').loadBy(name=arguments.size,siteID=arguments.renderer.getMuraScope().event('siteID'))>
			<cfset arguments.Width=customImageSize.getWidth() />
			<cfset arguments.Height=customImageSize.getHeight() />

			<cfif isNumeric(arguments.width)>
				<cfset imageStyles.paddingLeft=arguments.width + arguments.padding>
			<cfelse>
				<cfset imageStyles.paddingLeft="auto">
			</cfif>
			<cfif isNumeric(arguments.height)>
				<cfset imageStyles.minHeight=arguments.height + arguments.padding>
			<cfelse>
				<cfset imageStyles.minHeight="auto">
			</cfif>
		</cfif>

		<cfif imageStyles.minHeight neq "auto" and arguments.setHeight>
			<cfset imageStyles.markup="#imageStyles.markup#min-height:#imageStyles.minHeight#px;">
		</cfif>
		<cfif imageStyles.paddingLeft neq "auto" and arguments.setWidth>
			<cfset imageStyles.markup="#imageStyles.markup#padding-left:#imageStyles.paddingLeft#px;">
		</cfif>

		<cfreturn imageStyles.markup>

	</cffunction>

	<cffunction name="getCurrentURLArray" output="false">
		<cfargument name="renderer">
		<cfset var crumbdata=arguments.renderer.getValue('crumbdata')>
		<cfset var topURL=renderer.getMuraScope().createHREF(filename=crumbdata[arrayLen(crumbdata)-arguments.renderer.getNavOffSet()].filename)>
		<cfset var tempUrlArray=arguments.renderer.getMuraScope().getCrumbPropertyArray(property='url',direction="desc")>
		<cfset var i=1>
		<cfset var urlArray=[]>
		<cfset var started=false>

		<cfloop from="1" to="#arrayLen(tempUrlArray)#" index="i">
			<cfif tempUrlArray[i] eq topURL>
				<cfset started=true>
				<cfif i eq arrayLen(tempUrlArray)>
					<cfset arrayAppend(urlArray,tempUrlArray[i])>
				</cfif>
			<cfelseif started>
				<cfset arrayAppend(urlArray,tempUrlArray[i])>
			</cfif>
		</cfloop>

		<cfreturn urlArray>
	</cffunction>

	<cffunction name="getPagesQuery" output="false">
		<cfargument name="str">

		<cfset var pageList=replaceNocase(arguments.str,"[mura:pagebreak]","murapagebreak","ALL")>
		<cfset var rs=queryNew("page")>
		<cfset var i=1>
		<cfset var pageArray=ArrayNew(1)>
		<cfset pageList=replaceNocase(pageList,"${pagebreak}","murapagebreak","ALL")>
		<cftry>
			<cfset pageArray=pageList.split("murapagebreak",-1)>
			<cfcatch>
			<cfset pageArray[1]=arguments.str>
			</cfcatch>
		</cftry>

		<cfloop from="1" to="#arrayLen(pageArray)#"index="i">
	    	<cfset queryAddRow(rs,1)/>
			<cfset querysetcell(rs,"page",pageArray[i],rs.recordcount)/>
		</cfloop>
		<cfreturn rs>
	</cffunction>

	<cffunction name="dspMultiPageContent" output="false">
		<cfargument name="body">
		<cfargument name="renderer">
		<cfset var str="">
		<cfset var rsPages=getPagesQuery(arguments.body)>
		<cfset var currentNextNIndex=1>
		<cfset var event=renderer.getEvent()>

		<cfset event.setValue("currentNextNID",event.getContentBean().getContentID())>

		<cfif not len(event.getValue("nextNID")) or event.getValue("nextNID") eq event.getValue("currentNextNID")>
			<cfset currentNextNIndex=event.getValue("pageNum")>
		</cfif>

		<cfset var nextN=application.utility.getNextN(rsPages,1,currentNextNIndex,5,false)>

		<cfsavecontent variable="str">
		<cfoutput query="rsPages"  startrow="#request.pageNum#" maxrows="#nextn.RecordsPerPage#">
			#arguments.renderer.setDynamicContent(rsPages.page)#
		</cfoutput>
		<cfif nextn.numberofpages gt 1>
			<cfoutput>#arguments.renderer.dspObject_Include(thefile='dsp_nextN.cfm')#</cfoutput>
		</cfif>
		</cfsavecontent>

		<cfreturn str>
	</cffunction>

	<cffunction name="generateEditableHook" output="false">
		<cfargument name="renderer">
		<cfif arguments.renderer.getJSLib() eq "prototype">
			<cfreturn '#arguments.renderer.shadowboxattribute#="shadowbox;width=1050;"'>
		<cfelse>
			<cfreturn 'class="frontEndToolsModal"'>
		</cfif>
	</cffunction>

	<cffunction name="generateEditableObjectControl" output="no">
		<cfargument name="editLink" required="yes" default="">
		<cfargument name="isConfigurator" default="false">
		<cfargument name="showEditableObjects" default="false">
		<cfargument name="enableFrontEndTools" default="false">
		<cfargument name="renderer">
		<cfset var str = "">

		<cfif arguments.showEditableObjects and arguments.enableFrontEndTools>
		<cfsavecontent variable="str">
			<cfoutput>
			<ul class="editableObjectControl">
				<li class="edit"><a href="#arguments.editLink#" data-configurator="#arguments.isConfigurator#" title="#htmlEditFormat('Edit')#" #arguments.renderer.generateEditableHook()#></a></li>
			</ul>
			</cfoutput>
		</cfsavecontent>
		</cfif>

		<cfreturn str>
	</cffunction>

	<cffunction name="renderEditableObjectHeader" output="no">
		<cfargument name="class" required="yes" default="">
		<cfargument name="customWrapperString" required="yes" default="">
		<cfargument name="showEditableObjects" default="false">
		<cfargument name="enableFrontEndTools" default="false">
		<cfargument name="renderer">
		<cfset var str = "">

		<cfif arguments.showEditableObjects and arguments.enableFrontEndTools>
		<cfsavecontent variable="str">
			<cfoutput>
			<span class="editableObject #arguments.class#" #arguments.customWrapperString#><span class="editableObjectContents">
			</cfoutput>
		</cfsavecontent>
		</cfif>

		<cfreturn str>
	</cffunction>

	<cffunction name="renderEditableObjectfooter" output="no">
		<cfargument name="control" required="yes" default="">
		<cfargument name="showEditableObjects" default="false">
		<cfargument name="enableFrontEndTools" default="false">
		<cfargument name="renderer">
		<cfset var str = "">

		<cfif arguments.showEditableObjects and arguments.enableFrontEndTools>
		<cfsavecontent variable="str">
			<cfoutput>
			<cfoutput></span>#arguments.control#</cfoutput></span>
			</cfoutput>
		</cfsavecontent>
		</cfif>

		<cfreturn str>
	</cffunction>

	<cffunction name="getCurrentURL" output="false">
		<cfargument name="complete" required="true" type="boolean" default="true">
		<cfargument name="injectVars" required="true" type="string" default="">
		<cfargument name="filterVars" required="true" type="boolean" default="true">
		<cfargument name="domain" default="#listFirst(cgi.http_host,":")#">
		<cfargument name="renderer">
		<cfargument name="filterVarsList" default="">
		<cfset var qrystr=''>
		<cfset var host=''>
		<cfset var item = "" />
		<cfset var _filterVarsList='NOCACHE,PATH,DELETECOMMENTID,APPROVEDCOMMENTID,LOADLIST,INIT,SITEID,DISPLAY,#ucase(application.appReloadKey)#,#filterVars#'>

		<cfif len(arguments.filterVarsList)>
			<cfset _filterVarsList=_filterVarsList & ',' & arguments.filterVarsList>
		</cfif>

		<cfloop collection="#url#" item="item">
			<cfif not arguments.filterVars and item neq 'path' or (not listFindNoCase(_filterVarsList,item)
				 and not (item eq 'doaction' and url[item] eq 'logout')) >
				<cftry>
				<cfif len(qrystr)>
						<cfset qrystr="#qrystr#&#esapiEncode('url',item)#=#esapiEncode('url',url[item])#">
				<cfelse>
					<cfset qrystr="?#esapiEncode('url',item)#=#esapiEncode('url',url[item])#">
				</cfif>
				<cfcatch ></cfcatch>
				</cftry>
			</cfif>

		</cfloop>

		<cfif len(arguments.injectVars)>
			<cfif len(qrystr)>
				<cfset qrystr=qrystr & "&#arguments.injectVars#">
			<cfelse>
				<cfset qrystr="?#arguments.injectVars#">
			</cfif>
		</cfif>

		<cfif arguments.complete>
			<cfif application.utility.isHTTPS()>
				<cfset host='https://#arguments.domain##arguments.renderer.getMuraScope().siteConfig('ServerPort')#'>
			<cfelse>
				<cfset host='#arguments.renderer.getMuraScope().siteConfig('scheme')#://#arguments.domain##arguments.renderer.getMuraScope().siteConfig('ServerPort')#'>
			</cfif>
		</cfif>

		<cfreturn host & arguments.renderer.getMuraScope().siteConfig('context') & arguments.renderer.getURLStem(request.servletEvent.getValue('siteID'),request.servletEvent.getValue('currentFilename')) & qrystr >

	</cffunction>

	<cffunction name="getPersonalizationID" output="false">
		<cfargument name="renderer">
		<cfset var sessionData=getSession()>
		<cfif arguments.renderer.getPersonalization() eq "user">
		<cfreturn sessionData.mura.userID />
		<cfelse>
		<cfif not structKeyExists(cookie,"pid")>
			<cfset application.utility.setCookie(name="pid", value=application.utility.getUUID()) >
		</cfif>
			<cfreturn cookie.pid />
		</cfif>
	</cffunction>

	<cffunction name="getContentListProperty" output="false">
		<cfargument name="property" default="">
		<cfargument name="contentListPropertyMap">
		<cfargument name="renderer">

		<cfif structKeyExists(arguments.contentListPropertyMap,arguments.property)>
			<cfreturn arguments.contentListPropertyMap[arguments.property]>
		<cfelse>
			<cfreturn arguments.contentListPropertyMap.default>
		</cfif>

	</cffunction>

	<cffunction name="getContentListPropertyValue" output="false">
		<cfargument name="property" default="">
		<cfargument name="value" default="">
		<cfargument name="renderer">
		<cfargument name="contentListPropertyMap">

		<cfset var propStruct=arguments.renderer.getContentListProperty(arguments.property,arguments.contentListPropertyMap)>
		<cfif structKeyExists(propStruct,arguments.value)>
			<cfreturn propStruct[arguments.value]>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>

	<cffunction name="getContentListLabel" output="false">
		<cfargument name="property" default="">
		<cfargument name="renderer">
		<cfargument name="contentListPropertyMap">

		<cfset var propStruct=arguments.renderer.getContentListProperty(arguments.property,arguments.contentListPropertyMap)>
		<cfset var returnString="">

		<cfif structKeyExists(propStruct,"showLabel") and propStruct.showLabel>
			<cfset var labelEl="labelEl">
			<cfif structKeyExists(propStruct,"labelEl")>
				<cfset labelEl=propStruct.labelEl>
			</cfif>
			<cfset returnString="<" & arguments.renderer.getContentListPropertyValue(labelEl,'tag',arguments.contentListPropertyMap) &  arguments.renderer.getContentListAttributes(labelEl,'',arguments.contentListPropertyMap) & ">">
			<cfif structKeyExists(propStruct, "rbKey")>
				<cfset returnString=returnString & htmlEditFormat(arguments.renderer.getMuraScope().rbKey(propStruct.rbkey))>
			<cfelseif structKeyExists(propStruct, "label")>
				<cfset returnString=returnString & htmlEditFormat(propStruct.label)>
			<cfelse>
				<cfset returnString=returnString & arguments.property>
			</cfif>
			<cfif structKeyExists(propStruct, "labelDelim")>
				<cfset returnString=returnString & propStruct.labelDelim>
			</cfif>
			<cfset returnString=returnString & "</" & arguments.renderer.getContentListPropertyValue(labelEl,'tag',arguments.contentListPropertyMap) & ">">
		</cfif>

		<cfreturn returnString>
	</cffunction>

	<cffunction name="getContentListAttributes" output="false">
		<cfargument name="property" default="">
		<cfargument name="class" default="">
		<cfargument name="contentListPropertyMap">
		<cfargument name="renderer">

		<cfset var propStruct=arguments.renderer.getContentListProperty(arguments.property,arguments.contentListPropertyMap)>
		<cfset var returnstring="">
		<cfset var propclass="">

		<cfif structKeyExists(propStruct,"class")>
			<cfset propclass=propStruct.class>
		<cfelseif not listFindNoCase('containerel,itemel',arguments.property)>
			<cfset propclass=lcase(arguments.property)>
		</cfif>

		<cfset arguments.class=trim(propclass & " " & arguments.class)>

		<cfif len(arguments.class)>
			<cfset returnstring=' class="' & arguments.class & '"'>
		</cfif>

		<cfif structKeyExists(propStruct,"attributes")>
			<cfset returnstring= trim(returnstring & " " & propStruct.attributes)>
		</cfif>

		<cfreturn returnstring>
	</cffunction>

	<cffunction name="getListFormat" output="false">
		<cfargument name="contentListPropertyMap">
		<cfargument name="renderer">

		<cfif listFindNoCase("ul,ol",arguments.contentListPropertyMap.containerEl.tag)>
			<cfreturn arguments.contentListPropertyMap.containerEl.tag>
		<cfelse>
			<cfreturn arguments.contentListPropertyMap.itemEl.tag>
		</cfif>
	</cffunction>

	<cffunction name="loadShadowboxJS" output="false">
		<cfargument name="renderer">
		<!---<cfif not cookie.mobileFormat>--->
			<cfswitch expression="#arguments.renderer.getJsLib()#">
				<cfcase value="prototype">
					<cfset arguments.renderer.addToHTMLHeadQueue("shadowbox-prototype.cfm")>
				</cfcase>
				<cfdefaultcase>
					<cfset arguments.renderer.addToHTMLHeadQueue("shadowbox-jquery.cfm")>
				</cfdefaultcase>
			</cfswitch>
			<cfset arguments.renderer.addToHTMLHeadQueue("shadowbox.cfm")>
		<!---</cfif>--->
	</cffunction>

	<cffunction name="allowLink" output="false" returntype="boolean">
		<cfargument name="restrict" type="numeric"  default=0>
		<cfargument name="restrictgroups" type="string" default="" />
		<cfargument name="loggedIn"  type="numeric" default=0 />
		<cfargument name="rspage"  type="query" />
		<cfargument name="renderer">
		<cfset var sessionData=getSession()>

		<cfset var allowLink=true>
		<cfset var G = 0 />
		<cfset var event=arguments.renderer.getEvent()>
		<cfset var hideRestrictedNav=arguments.renderer.getHideRestrictedNav()>
		<cfif hideRestrictedNav and arguments.restrict and not arguments.loggedIn>
			<cfset allowLink = false>
		<cfelseif arguments.loggedIn and (arguments.restrict)>
			<cfif arguments.restrictgroups eq '' or listFind(sessionData.mura.memberships,'S2IsPrivate;#application.settingsManager.getSite(event.getValue('siteID')).getPrivateUserPoolID()#') or listFind(sessionData.mura.memberships,'S2')>
				<cfset allowLink=True>
			<cfelseif arguments.restrictgroups neq ''>
				<cfset allowLink=False>
				<cfloop list="#arguments.restrictgroups#" index="G">
					<cfif listFind(sessionData.mura.memberships,'#G#;#application.settingsManager.getSite(event.getValue('siteID')).getPublicUserPoolID()#;1') or listFind(sessionData.mura.membershipids,g)>
					<cfset allowLink=true>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>

		<cfreturn allowLink>
	</cffunction>

	<cffunction name="getTopId" output="false">
		<cfargument name="useNavOffset" required="true" default="false"/>
		<cfargument name="renderer">
		<cfset var id="homepage">
		<cfset var topId="">
		<cfset var offset=1>

		<cfif arguments.useNavOffset>
			<cfset offset=1+arguments.renderer.getNavOffSet()/>
		</cfif>

		<cfif arrayLen(arguments.renderer.crumbdata) gt offset>
			<cfset topID = replace(arguments.renderer.getCrumbVarByLevel("filename",offset),"_"," ","ALL")>
			<cfset topID = arguments.renderer.setCamelback(topID)>
			<cfset id = Left(LCase(topID), 1)>
			<cfif len(topID) gt 1>
				<cfset id=id & Right(topID, Len(topID)-1)>
			</cfif>
		</cfif>

		<cfif arguments.renderer.getEvent().getValue('contentBean').getIsNew() eq 1>
			<cfset id = "fourzerofour">
		</cfif>

		<cfreturn id>
	</cffunction>

	<cffunction name="getTopVar" output="false">
		<cfargument name="topVar" required="true" default="" type="String">
		<cfargument name="useNavOffset" required="true" type="boolean" default="false">
		<cfargument name="renderer">
		<cfset var theVar="">
		<cfset var offset=1>

		<cfif arguments.useNavOffset>
			<cfset offset=offset+arguments.renderer.getNavOffSet()/>
		</cfif>

		<cfreturn arguments.renderer.getCrumbVarByLevel(arguments.topVar,offset)>
	</cffunction>

	<cffunction name="getCrumbVarByLevel" output="false">
		<cfargument name="theVar" required="true" default="" type="String">
		<cfargument name="level" required="true" type="numeric" default="1">
		<cfargument name="renderer">
		<cfset var crumbdata=arguments.renderer.getValue('crumbdata')>
		<cfif arrayLen(crumbData) gt arguments.level>
			<cfreturn crumbData[arrayLen(crumbData)-arguments.level][arguments.theVar]>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>

	<cffunction name="dspZoomText" output="false">
		<cfargument name="crumbdata" required="yes" type="array">
		<cfargument name="separator" required="yes" default=">">
		<cfargument name="renderer">
		<cfset var crumbLen=arrayLen(arguments.crumbdata)>
		<cfset var I = 0 />
		<cfset var content="">

		<cfoutput>
		<cfloop from="#crumbLen#" to="2" index="I" step="-1">
		<cfset content=content & " #arguments.crumbdata[I].menutitle#  #arguments.separator#">
		</cfloop>
		<cfset content=content & " #arguments.crumbdata[1].menutitle#">
		</cfoutput>

		<cfreturn trim(content) />
	</cffunction>

	<cffunction name="dspZoom" output="false">
		<cfargument name="crumbdata" required="yes" type="array">
		<cfargument name="fileExt" type="string" default="" hint="deprecated, this is now in the crumbData">
		<cfargument name="ajax" type="boolean" default="false">
		<cfargument name="class" type="string" default="breadcrumb">
		<cfargument name="charLimit" type="numeric" default="0">
		<cfargument name="minLevels" type="numeric" default="0">
		<cfargument name="maxLevels" type="numeric" default="0">
		<cfargument name="renderer">
		<cfset var content = "">
		<cfset var locked = "">
		<cfset var lastlocked = "">
		<cfset var crumbLen=arrayLen(arguments.crumbdata)>
		<cfset var I = 0 />
		<cfset var anchorString="">
		<cfset var icon="">
		<cfset var isFileIcon=false>
		<cfset var charCount = 0>
		<cfset var limited = false>
		<cfif arguments.charLimit>
			<!--- change crumbLen --->
			<cfloop from="1" to="#arrayLen(arguments.crumbdata)#" index="i">
				<cfset charCount = charCount + len(arguments.crumbdata[i].menutitle) + 3> <!--- add 3 to offset the icon width--->
				<cfif charCount gte arguments.charLimit>
					<cfset crumbLen = i - 1>
					<cfset limited = true>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfif arguments.minLevels and crumbLen lt arguments.minLevels and arguments.minLevels lte arrayLen(arguments.crumbdata)>
			<cfset crumbLen = arguments.minLevels>
		</cfif>
		<cfif arguments.maxLevels and crumbLen gt arguments.maxLevels and arguments.maxLevels lte arrayLen(arguments.crumbdata)>
			<cfset crumbLen = arguments.maxLevels>
		</cfif>
		<cfsavecontent variable="content"><cfoutput><ul class="#arguments.class#">
		<cfloop from="#crumbLen#" to="2" index="I" step="-1">
			<cfsilent>
				<cfif not structKeyExists(arguments.crumbdata[i],'moduleid')>
					<cfset arguments.crumbdata[i].moduleid="00000000000000000000000000000000000">
				</cfif>
				<cfif arguments.crumbdata[i].restricted eq 1><cfset locked="locked"></cfif>
				<cfset icon=arguments.renderer.renderIcon(arguments.crumbdata[i])>
				<cfset isFileIcon= arguments.crumbdata[i].type eq 'File' and listFirst(icon,"-") neq "mi">
			</cfsilent>
			<li class="#locked#<cfif isFileIcon> file</cfif>"<cfif isFileIcon> data-filetype="#left(icon,4)#"</cfif>>
			<a <cfif arguments.ajax>
				href="" onclick="return siteManager.loadSiteManagerInTab(function(){siteManager.loadSiteManager('#arguments.crumbdata[I].siteid#','#arguments.crumbdata[I].contentid#','#arguments.crumbdata[I].moduleid#','','','#arguments.crumbdata[I].type#',1)});"
			<cfelse>
				href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cArch.list&siteid=#arguments.crumbdata[I].siteid#&topid=#arguments.crumbdata[I].contentid#&moduleid=#arguments.crumbdata[I].moduleid#&activeTab=0"
			</cfif>><i class="#icon#"></i>#HTMLEditformat(arguments.crumbdata[I].menutitle)#</a></li>
		</cfloop>
		<cfsilent>
			<cfif not structKeyExists(arguments.crumbdata[1],'moduleid')>
				<cfset arguments.crumbdata[1].moduleid="00000000000000000000000000000000000">
			</cfif>
			<cfif locked eq "locked" or arguments.crumbdata[1].restricted eq 1>
				<cfset lastlocked="locked">
			</cfif>
			<cfset icon=arguments.renderer.renderIcon(arguments.crumbdata[1])>
			<cfset isFileIcon= arguments.crumbdata[1].type eq 'File' and listFirst(icon,"-") neq "mi">
		</cfsilent>
		<li class="#locked#<cfif isFileIcon> file</cfif>"<cfif isFileIcon> data-filetype="#left(icon,4)#"</cfif>><strong>
		<a <cfif arguments.ajax>
			href="" onclick="return siteManager.loadSiteManagerInTab(function(){siteManager.loadSiteManager('#arguments.crumbdata[1].siteid#','#arguments.crumbdata[1].contentid#','#arguments.crumbdata[1].moduleid#','','','#arguments.crumbdata[1].type#',1)});"
		<cfelse>
			href="#application.configBean.getContext()##application.configBean.getAdminDir()#/?muraAction=cArch.list&siteid=#arguments.crumbdata[1].siteid#&topid=#arguments.crumbdata[1].contentid#&moduleid=#arguments.crumbdata[1].moduleid#&activeTab=0"
		</cfif>><i class="#icon#"></i>#HTMLEditformat(arguments.crumbdata[1].menutitle)#</a></strong></li>
		</ul></cfoutput></cfsavecontent>

		<cfreturn content />
	</cffunction>

	<cffunction name="setParagraphs" output="false">
		<cfargument name="theString" type="string">
		<cfargument name="renderer">
		<cfset var str=arguments.thestring/>
		<cfset var finder=""/>
		<cfset var item=""/>
		<cfset var start=1/>

		<cfset str = replace(str,chr(13)&chr(10),chr(10),"ALL")/>
		<!---now make Macintosh style into Unix style--->
		<cfset str = replace(str,chr(13),chr(10),"ALL")/>
		<!---now fix tabs--->
		<cfset str = replace(str,chr(9),"&nbsp;&nbsp;&nbsp;","ALL")/>

		<cfset finder=refindnocase('https?:\/\/\S+',str,start,"true")>

		<cfloop condition="#finder.len[1]#">
		<cfset item=trim(mid(str, finder.pos[1], finder.len[1])) />
		<cfset str=replace(str,mid(str, finder.pos[1], finder.len[1]),'<a href="#item#" target="_blank">#item#</a>')>
		<cfset start=finder.pos[1] + len('<a href="#item#" target="_blank">#item#</a>') >
		<cfset finder=refindnocase('https?:\/\/\S+',str,start,"true")>
		</cfloop>

		<cfset start=1/>
		<cfset finder=refindnocase("[\w.]+@[\w.]+\.\w+",str,start,"true")>

		<cfloop condition="#finder.len[1]#">
		<cfset item=trim(mid(str, finder.pos[1], finder.len[1])) />
		<cfset str=replace(str,mid(str, finder.pos[1], finder.len[1]),'<a href="mailto:#item#" target="_blank">#item#</a>')>
		<cfset start=finder.pos[1] + len('<a href="mailto:#item#" target="_blank">#item#</a>') >
		<cfset finder=refindnocase("[\w.]+@[\w.]+\.\w+",str,start,"true")>
		</cfloop>

		<cfset str="<p>" & str & "</p>"/>
		<cfset str = replace(str,chr(10),"</p><p>","ALL") />

		<!---now return the text formatted in HTML--->
		<cfreturn str />
	</cffunction>

	<cffunction name="createCSSID"  output="false">
		<cfargument name="title" type="string" required="true" default="">
		<cfargument name="renderer">
		<cfset var id=arguments.renderer.setProperCase(arguments.title)>
		<cfreturn "sys" & rereplace(id,"[^a-zA-Z0-9]","","ALL")>
	</cffunction>

	<cffunction name="createCSSHook"  output="false">
		<cfargument name="text" type="string" required="true">
		<cfreturn application.utility.createCSSHook(arguments.text)>
	</cffunction>

	<cffunction name="getTemplate"  output="false">
		<cfargument name="renderer">
		<cfset var crumbdata=arguments.renderer.getValue('crumbdata')>
		<cfset var I = 0 />
		<cfset var event=arguments.renderer.getEvent()>
		<cfif event.getValue('contentBean').getIsNew() neq 1>
			<cfif len(event.getValue('contentBean').getTemplate())>
				<cfreturn event.getValue('contentBean').getTemplate() />
			<cfelseif arrayLen(crumbdata) gt 1>
				<cfloop from="2" to="#arrayLen(crumbdata)#" index="I">
					<cfif listFindNoCase('cfm,cfml,htm,html,hbs',listLast(crumbdata[I].template,'.'))>
						<cfreturn crumbdata[I].template />
					</cfif>
				</cfloop>
			</cfif>
		</cfif>

		<cfreturn "default.cfm" />
	</cffunction>

	<cffunction name="getMetaDesc"  output="false">
		<cfargument name="renderer">
		<cfset var I = 0 />
		<cfset var crumbdata=arguments.renderer.getValue('crumbdata')>
		<cfloop from="1" to="#arrayLen(crumbdata)#" index="I">
		<cfif  crumbdata[I].metaDesc neq ''>
		<cfreturn crumbdata[I].metaDesc />
		</cfif>
		</cfloop>
		<cfreturn "" />
	</cffunction>

	<cffunction name="getMetaKeyWords"  output="false">
		<cfargument name="renderer">
		<cfset var I = 0 />
		<cfset var crumbdata=arguments.renderer.getValue('crumbdata')>
		<cfloop from="1" to="#arrayLen(crumbdata)#" index="I">
		<cfif crumbdata[I].metaKeyWords neq ''>
		<cfreturn crumbdata[I].metaKeyWords />
		</cfif>
		</cfloop>
		<cfreturn "" />
	</cffunction>

	<cffunction name="stripHTML" output="false">
		<cfargument name="str" type="string">
		<cfreturn ReReplace(arguments.str, "<[^>]*>","","all") />
	</cffunction>

	<cffunction name="addCompletePath" output="false">
		<cfargument name="str" type="string">
		<cfargument name="siteID" type="string">
		<cfset var returnstring=arguments.str/>
		<cfset var $=arguments.renderer.getMuraScope()>
		<cfset returnstring=replaceNoCase(returnstring,'src="/','src="#$.siteConfig('scheme')#://#application.settingsManager.getSite(arguments.siteID).getDomain()##application.configBean.getServerPort()#/','ALL')>
		<cfset returnstring=replaceNoCase(returnstring,"src='/",'src="#$.siteConfig('scheme')#://#application.settingsManager.getSite(arguments.siteID).getDomain()##application.configBean.getServerPort()#/','ALL')>
		<cfset returnstring=replaceNoCase(returnstring,'href="/','href="#$.siteConfig('scheme')#://#application.settingsManager.getSite(arguments.siteID).getDomain()##application.configBean.getServerPort()#/','ALL')>
		<cfset returnstring=replaceNoCase(returnstring,"href='/",'href="#$.siteConfig('scheme')#://#application.settingsManager.getSite(arguments.siteID).getDomain()##application.configBean.getServerPort()#/','ALL')>
		<cfreturn returnstring />
	</cffunction>

	<cffunction name="dspSection" output="false">
		<cfargument name="level" default="1" required="true">
		<cfargument name="renderer">
		<cfset var crumbdata=arguments.renderer.getValue('crumbdata')>
		<cftry>
			<cfreturn crumbdata[arrayLen(crumbdata)-arguments.level].menutitle >
			<cfcatch>
				<cfreturn "">
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="renderObjectInManager" output="false">
		<cfargument name="object">
		<cfargument name="objectid">
		<cfargument name="content">
		<cfargument name="objectParams" default="#structNew()#">
		<cfargument name="showEditable">
		<cfargument name="isConfigurator">
		<cfargument name="objectname">
		<cfargument name="renderer">
		<cfargument name="bodyRender" default="false">
		<cfargument name="returnformat" default="html">

		<cfset var openingDiv='<div class="mura-object'>
		<cfset var $=arguments.renderer.getMuraScope()>

		<cfparam name="arguments.objectparams.instanceid" default="#createUUID()#">
		<cfparam name="arguments.objectparams.render" default="server">

		<cfif arguments.bodyRender or structKeyExists(arguments.objectParams,'isBodyObject')>
			<cfset openingDiv=openingDiv & ' mura-body-object'>
			<cfset structDelete(arguments.objectParams,'isBodyObject')>
		</cfif>

		<cfset structDelete(arguments.objectParams,'undefined')>

		<cfif arguments.bodyRender>
			<cfif $.content('subtype') eq 'Default'>
				<cfset arguments.objectParams.objectname=$.content('type')>
			<cfelse>
				<cfset arguments.objectParams.objectname=$.content('subtype')>
			</cfif>
		<cfelseif not isDefined('arguments.objectParams.objectname')>
			<cfif isDefined('arguments.objectname') and len(arguments.objectname)>
				<cfset arguments.objectParams.objectname=arguments.objectname>
			<cfelse>
				<cfset arguments.objectParams.objectname=ucase(left(arguments.object,1)) & right(arguments.object,len(arguments.object)-1)>
			</cfif>
		</cfif>

		<cfparam name="arguments.objectParams.objecticonclass" default="">

		<cfif arguments.renderer.hasDisplayObject(arguments.object)>
			<cfset var objectConfig=arguments.renderer.getDisplayObject(arguments.object)>

			<cfif (find('class=',arguments.objectParams.objectname) or find('class=',arguments.objectname))>
				<cfset arguments.objectParams.objectname=objectConfig.name>
				<cfset arguments.objectname=arguments.objectParams.objectname>
			</cfif>

			<cfif not len(arguments.objectParams.objecticonclass)>
				<cfset arguments.objectParams.objecticonclass=objectConfig.iconclass>
			</cfif>

		<cfelseif not len(arguments.objectParams.objecticonclass)>
			<cfset arguments.objectParams.objecticonclass="mi-cog">
		</cfif>

		<cfparam name="arguments.objectParams.async" default="false">

		<cfif arguments.objectParams.async>
			<cfset openingDiv=openingDiv & " mura-async-object">
		</cfif>

		<cfif structKeyExists(arguments.objectParams,'class') and len(arguments.objectParams.class)>
			<cfset openingDiv=openingDiv & " " & arguments.objectParams.class>
		</cfif>

		<cfparam name="arguments.objectparams.cssstyles" default="">

		<cfset openingDiv=openingDiv & '" data-object="#esapiEncode('html_attr',lcase(arguments.object))#" data-objectid="#esapiEncode('html_attr',arguments.objectid)#" data-instanceid="#arguments.objectparams.instanceid#" style="#$.renderCssStyles(objectparams.cssstyles)#"'>

		<cfloop collection="#arguments.objectparams#" item="local.i">
			<cfif len(local.i) and not listFindNoCase('runtime,object,objectid,instanceid',local.i)>
				<cfset openingDiv=openingDiv & ' data-#esapiEncode('html_attr',lcase(local.i))#="#esapiEncode('html_attr', serializeObjectParam(arguments.objectparams[local.i]))#"'>
			</cfif>
		</cfloop>

		<cfif arguments.showEditable>
			<cfset openingDiv=openingDiv & ' data-objectname="#esapiEncode('html_attr',arguments.objectname)#" data-perm="author" data-isconfigurator="#esapiEncode('html_attr',arguments.isConfigurator)#">'>
		<cfelse>
			<cfset openingDiv=openingDiv & ">">
		</cfif>

		<cfif arguments.renderer.useLayoutManager()>
			<cfif arguments.objectparams.render eq 'server'>
				<cfset openingDiv="#openingDiv##arguments.renderer.dspObject_include(theFile='object/meta.cfm',params=arguments.objectParams)#">
			</cfif>

			<cfset arguments.content=trim(arguments.content)>
			<cfparam name="arguments.objectparams.contentcssclass" default="">
			<cfparam name="arguments.objectparams.contentcssid" default="">
			<cfparam name="arguments.objectparams.contentcssstyles" default="">

			<cfif arguments.returnFormat eq 'struct'>
				<cfif len(arguments.content)>
					<cfreturn {
								header=openingDiv & '<div id="#esapiEncode('html_attr',trim(arguments.objectparams.contentcssid))#" class="#esapiEncode('html_attr',trim('mura-object-content #arguments.objectparams.contentcssclass#'))#" style="#$.renderCssStyles(objectparams.contentcssstyles)#">',
								footer="</div></div>"
							}>
				<cfelse>
					<cfreturn {
								header=openingDiv,
								footer="</div>"
							}>
				</cfif>
			<cfelse>
				<cfif len(arguments.content)>
					<cfreturn openingDiv & '<div id="#esapiEncode('html_attr',trim(arguments.objectparams.contentcssid))#" class="#esapiEncode('html_attr',trim('mura-object-content #arguments.objectparams.contentcssclass#'))#" style="#$.renderCssStyles(objectparams.contentcssstyles)#">' & arguments.content & '</div></div>'>
				<cfelse>
					<cfreturn openingDiv & '</div>'>
				</cfif>
			</cfif>
		<cfelse>
			<cfreturn '#openingDiv##trim(arguments.content)#</div>'>
		</cfif>

	</cffunction>

	<cffunction name="serializeObjectParam" output="false">
		<cfargument name="paramValue">

		<cfif isSimpleValue(arguments.paramValue)>
			<cfreturn arguments.paramValue>
		<cfelse>
			<cfreturn serializeJSON(arguments.paramValue)>
		</cfif>
	</cffunction>

	<cffunction name="dspObject" output="false">
		<cfargument name="object" type="string">
		<cfargument name="objectid" type="string" required="true" default="">
		<cfargument name="siteid" type="string" required="true" default="">
		<cfargument name="params" required="true" default="">
		<cfargument name="assignmentID" type="string" required="true" default="">
		<cfargument name="regionID" required="true" default="0">
		<cfargument name="orderno" required="true" default="0">
		<cfargument name="hasConfigurator" required="true" default="false">
		<cfargument name="assignmentPerm" required="true" default="none">
		<cfargument name="allowEditable" type="boolean" default="false">
		<cfargument name="cacheKey" type="string" required="false" default="">
		<cfargument name="renderer">
		<cfargument name="showEditableObjects">
		<cfargument name="layoutmanager">
		<cfargument name="objectname">
		<cfargument name="bodyRender" required="true" default="false">
		<cfargument name="include" required="true" default="false">
		<cfargument name="returnFormat" required="true" default="html">
		<cfargument name="RenderingAsRegion" required="true" default="false">

		<cfset var event=arguments.renderer.getEvent()>
		<cfset var $=arguments.renderer.getMuraScope()>
		<cfset var theObject = "" />
		<cfset var cacheKeyContentId = arguments.object & arguments.objectid & event.getValue('contentBean').getcontentID() & $.event('currentfilename') & cgi.query_string & arguments.cachekey />
		<cfset var cacheKeyObjectId = cacheKeyContentId />
		<cfset var showEditable=false/>
		<cfset var editableControl={editLink='',isConfigurator=false}>
		<cfset var historyID="">
		<cfset var tempObject="">
		<cfset var args={}>
		<cfset var sessionData=getSession()>

		<cfif isJSON(arguments.params)>
			<cfset arguments.params=deserializeJSON(arguments.params)>
		<cfelseif not isStruct(arguments.params)>
			<cfset arguments.params={}>
		</cfif>

		<cfset request.muraValidObject=true>
		<cfset request.muraAsyncEditableObject=false>

		<cfif sessionData.mura.isLoggedIn and arguments.showEditableObjects and arguments.allowEditable>

			<cfif $.siteConfig('hasLockableNodes')>
				<cfset var configuratorAction="carch.lockcheck&destAction=">
			<cfelse>
				<cfset var configuratorAction="">
			</cfif>

			<cfswitch expression="#arguments.object#">
				<cfcase value="plugin">
					<cfset showEditable=arguments.showEditableObjects and  (arguments.renderer.useLayoutManager() or arguments.hasConfigurator) and listFindNoCase("editor,author",arguments.assignmentPerm)>
					<cfset editableControl.class="editablePlugin">
					<cfset editableControl.editLink = "#$.globalConfig('context')##$.globalConfig('adminDir')#/?muraAction=#configuratorAction#cArch.frontEndConfigurator">
					<cfset editableControl.isConfigurator=true>
				</cfcase>
				<cfcase value="feed,feed_slideshow,feed_no_summary,feed_slideshow_no_summary">
					<cfset showEditable=arguments.showEditableObjects and listFindNoCase("editor,author",arguments.assignmentPerm)>
					<cfset editableControl.class="editableFeed">
					<cfset editableControl.editLink =  "#$.globalConfig('context')##$.globalConfig('adminDir')#/?muraAction=#configuratorAction#cArch.frontEndConfigurator">
				</cfcase>
				<cfcase value="category_summary,category_summary_rss"><cfset showEditable=arguments.showEditableObjects and listFindNoCase("editor,author",arguments.assignmentPerm)>
					<cfset showEditable=arguments.showEditableObjects and listFindNoCase("editor,author",arguments.assignmentPerm)>
					<cfset editableControl.class="editableCategorySummary">
					<cfset editableControl.editLink =  "#$.globalConfig('context')##$.globalConfig('adminDir')#/?muraAction=#configuratorAction#cArch.frontEndConfigurator">
					<cfset editableControl.isConfigurator=true>
				</cfcase>

				<!--- BEGIN: New Layout Manager Objects --->
				<cfcase value="collection">
					<cfset showEditable=arguments.showEditableObjects and  (arguments.renderer.useLayoutManager() or arguments.hasConfigurator) and listFindNoCase("editor,author",arguments.assignmentPerm)>
					<cfset editableControl.class="editableCollection">
					<cfset editableControl.editLink = "#$.globalConfig('context')##$.globalConfig('adminDir')#/?muraAction=#configuratorAction#cArch.frontEndConfigurator">
					<cfset editableControl.isConfigurator=true>
				</cfcase>
				<cfcase value="text">
					<cfset showEditable=arguments.showEditableObjects and  (arguments.renderer.useLayoutManager() or arguments.hasConfigurator) and listFindNoCase("editor,author",arguments.assignmentPerm)>
					<cfset editableControl.class="editableText">
					<cfset editableControl.editLink = "#$.globalConfig('context')##$.globalConfig('adminDir')#/?muraAction=#configuratorAction#cArch.frontEndConfigurator">
					<cfset editableControl.isConfigurator=true>
				</cfcase>
				<cfcase value="media">
					<cfset showEditable=arguments.showEditableObjects and  (arguments.renderer.useLayoutManager() or arguments.hasConfigurator) and listFindNoCase("editor,author",arguments.assignmentPerm)>
					<cfset editableControl.class="editableMedia">
					<cfset editableControl.editLink = "#$.globalConfig('context')##$.globalConfig('adminDir')#/?muraAction=#configuratorAction#cArch.frontEndConfigurator">
					<cfset editableControl.isConfigurator=true>
				</cfcase>
				<cfcase value="socialembed">
					<cfset showEditable=arguments.showEditableObjects and  (arguments.renderer.useLayoutManager() or arguments.hasConfigurator) and listFindNoCase("editor,author",arguments.assignmentPerm)>
					<cfset editableControl.class="editableSocialembed">
					<cfset editableControl.editLink = "#$.globalConfig('context')##$.globalConfig('adminDir')#/?muraAction=#configuratorAction#cArch.frontEndConfigurator">
					<cfset editableControl.isConfigurator=true>
				</cfcase>
				<cfcase value="container">
					<cfset showEditable=arguments.showEditableObjects and  (arguments.renderer.useLayoutManager() or arguments.hasConfigurator) and listFindNoCase("editor,author",arguments.assignmentPerm)>
					<cfset editableControl.class="editableContainer">
					<cfset editableControl.editLink = "#$.globalConfig('context')##$.globalConfig('adminDir')#/?muraAction=#configuratorAction#cArch.frontEndConfigurator">
					<cfset editableControl.isConfigurator=true>
				</cfcase>
				<!--- END: New Layout Manager Objects --->

				<cfcase value="tag_cloud">
					<cfif Len($.siteConfig('customTagGroups'))>
						<cfset showEditable=arguments.showEditableObjects and listFindNoCase("editor,author",arguments.assignmentPerm)>
						<cfset editableControl.class="editableTagCloud">
						<cfset editableControl.editLink =  "#$.globalConfig('context')##$.globalConfig('adminDir')#/?muraAction=#configuratorAction#cArch.frontEndConfigurator">
						<cfset editableControl.isConfigurator=true>
					</cfif>

					<cfif isJSON(arguments.params)>
						<cfset args=deserializeJSON(arguments.params)>
					</cfif>
				</cfcase>
				<cfcase value="site_map">
					<cfset showEditable=arguments.showEditableObjects and listFindNoCase("editor,author",arguments.assignmentPerm)>
					<cfset editableControl.class="editableSiteMap">
					<cfset editableControl.editLink =  "#$.globalConfig('context')##$.globalConfig('adminDir')#/?muraAction=#configuratorAction#cArch.frontEndConfigurator">
					<cfset editableControl.isConfigurator=true>

					<cfif isJSON(arguments.params)>
						<cfset args=deserializeJSON(arguments.params)>
					</cfif>
				</cfcase>
				<cfcase value="related_content,related_section_content">
					<cfset showEditable=arguments.showEditableObjects and listFindNoCase("editor,author",arguments.assignmentPerm)>
					<cfset editableControl.class="editableRelatedContent">
					<cfset editableControl.editLink =  "#$.globalConfig('context')##$.globalConfig('adminDir')#/?muraAction=#configuratorAction#cArch.frontEndConfigurator">
					<cfset editableControl.isConfigurator=true>
				</cfcase>
				<cfcase value="component,form">
					<cfset arguments.params.perm=listFindNoCase("editor,author",application.permUtility.getDisplayObjectPerm(arguments.siteID,arguments.object,arguments.objectID))>
					<cfset showEditable=arguments.params.perm>
					<cfif showEditable>
						<cfset historyID = $.getBean("contentGateway").getContentHistIDFromContentID(contentID=arguments.objectID,siteID=arguments.siteID)>
						<cfif arguments.object eq "component">
							<cfset editableControl.class="editableComponent">
						<cfelse>
							<cfset editableControl.class="editableForm">
						</cfif>

						<cfset editableControl.editLink = "#$.globalConfig('context')##$.globalConfig('adminDir')#/?muraAction=#configuratorAction#cArch.edit">

						<cfif len($.event('previewID'))>
							<cfset editableControl.editLink = editableControl.editLink & "&amp;contenthistid=" & $.event('previewID')>
						<cfelse>
							<cfset editableControl.editLink = editableControl.editLink & "&amp;contenthistid=" & historyID>
						</cfif>
						<cfset editableControl.editLink = editableControl.editLink & "&amp;siteid=" & arguments.siteID>
						<cfset editableControl.editLink = editableControl.editLink & "&amp;contentid=" & arguments.objectID>
						<cfset editableControl.editLink = editableControl.editLink & "&amp;topid=00000000000000000000000000000000001">
						<cfif arguments.object eq "component">
							<cfset editableControl.editLink = editableControl.editLink & "&amp;type=Component">
							<cfset editableControl.editLink = editableControl.editLink & "&amp;moduleid=00000000000000000000000000000000003">
							<cfset editableControl.editLink = editableControl.editLink & "&amp;parentid=00000000000000000000000000000000003">
						<cfelse>
							<cfset editableControl.editLink = editableControl.editLink & "&amp;type=Form">
							<cfset editableControl.editLink = editableControl.editLink & "&amp;moduleid=00000000000000000000000000000000004">
							<cfset editableControl.editLink = editableControl.editLink & "&amp;parentid=00000000000000000000000000000000004">
						</cfif>
						<cfset editableControl.isConfigurator=false>
					</cfif>
				</cfcase>
			</cfswitch>
		</cfif>


		<cfif arguments.renderer.useLayoutManager() and listFindNoCase("editor,author",arguments.assignmentPerm)>
			<cfset showEditable=true>
		</cfif>

		<cfif showEditable>
			<cfif len(application.configBean.getAdminDomain())>
				<cfif application.configBean.getAdminSSL()>
					<cfset editableControl.editLink="https://#application.configBean.getAdminDomain()#" & editableControl.editLink/>
				<cfelse>
					<cfset editableControl.editLink="#application.settingsManager.getSite(arguments.siteID).getScheme()#://#application.configBean.getAdminDomain()#" & editableControl.editLink/>
				</cfif>
			</cfif>

			<cfset editableControl.editLink = editableControl.editLink & "&amp;compactDisplay=true">

			<cfif not arguments.layoutmanager>
				<cfset editableControl.editLink = editableControl.editLink & "&amp;homeID=" & $.content("contentID")>

				<cfif not listFindNoCase("Form,Component",arguments.object)>
					<cfset editableControl.editLink = editableControl.editLink & "&amp;contenthistID=" & arguments.assignmentID>
					<cfset editableControl.editLink = editableControl.editLink & "&amp;regionID=" & arguments.regionID>
					<cfset editableControl.editLink = editableControl.editLink & "&amp;orderno=" & arguments.orderno>
					<cfset editableControl.editLink = editableControl.editLink & "&amp;siteID=" & arguments.siteID>
					<cfset editableControl.editLink = editableControl.editLink & "&amp;contenttype=" & esapiEncode('url',$.content('type'))>
					<cfset editableControl.editLink = editableControl.editLink & "&amp;contentsubtype=" & esapiEncode('url',$.content('subtype'))>
				</cfif>
			<cfelse>
				<cfset editableControl.editLink = editableControl.editLink & "&amp;siteID=" & arguments.siteID>
			</cfif>

			<cfset arguments.renderer.setHasEditableObjects(true)>
		</cfif>

		<cfif $.siteConfig().hasDisplayObject(arguments.object)>
			<cfif arguments.object eq 'tag_cloud'>
					<cfsavecontent variable="tempObject"><cf_CacheOMatic key="#cacheKeyObjectId#" nocache="#event.getValue('nocache')#"><cfoutput>#arguments.renderer.dspTagCloud(argumentCollection=arguments)#</cfoutput></cf_CacheOMatic></cfsavecontent>
					<cfset theObject=trim(tempObject)>
					<cfif arguments.renderer.useLayoutmanager()>
						<cfif not arguments.include and request.muraFrontEndRequest>

								<cfset theObject=renderObjectInManager(object=arguments.object,
									objectid=arguments.objectid,
									content=theObject,
									objectname=arguments.objectname,
									objectParams=arguments.params,
									showEditable=showEditable,
									isConfigurator=editableControl.isConfigurator,
									objectname=arguments.objectname,
									renderer=arguments.renderer,
									bodyRender=arguments.bodyRender,
									returnformat=arguments.returnformat)>
						</cfif>
					</cfif>
					<cfreturn theObject>
			<cfelse>
				<cfset var displayobject=$.siteConfig().getDisplayObject(arguments.object)>

				<!--- Standardizing display object rendering via .cfm files--->

				<cfset var filePath=''>

				<cfif len(displayobject.legacyObjectFile) and len($.siteConfig().lookupDisplayObjectFilePath(filePath=displayobject.legacyObjectFile,customOnly=true))>
					<cfset filePath=displayobject.legacyObjectFile>
				<cfelse>
					<cfset filePath=displayobject.displayObjectFile>
				</cfif>

				<cfparam name="displayobject.cacheoutput" default="true">

				<cfif listLast(filePath,".") neq "cfm">
					<cfset var theDisplay1=''>
					<cfset var theDisplay2=''>
					<cfset var componentPath="#filePath#">
					<cfset var eventHandler=createObject(componentPath).init()>
					<cfset var tracePoint=initTracePoint("#getMetaData(eventHandler).name#.#displayobject.displaymethod#")>
					<cfsavecontent variable="theDisplay1">
					<cfinvoke component="#eventHandler#" method="#displayobject.displaymethod#" returnvariable="theDisplay2">
						<cfinvokeargument name="event" value="#event#">
						<cfinvokeargument name="$" value="#$#">
						<cfinvokeargument name="mura" value="#$#">
					</cfinvoke>
					</cfsavecontent>
					<cfset commitTracePoint(tracePoint)>
					<cfif isdefined("theDisplay2")>
						<cfreturn trim(theDisplay2)>
					<cfelse>
						<cfreturn trim(theDisplay1)>
					</cfif>
				<cfelse>
					<cfset var objectargs={regionid=arguments.regionid,siteID=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename=filePath,params=arguments.params,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,bodyRender=arguments.bodyRender,returnformat=arguments.returnformat,include=arguments.include,RenderingAsRegion=arguments.RenderingAsRegion}>

					<cfif objectargs.object neq 'plugin' and displayobject.cacheoutput  and not ( isdefined('form') and not structIsEmpty(form) )>
						<cfset objectargs.cacheKey=cacheKeyContentId>
					</cfif>

					<cfset theObject=arguments.renderer.dspObject_Render(argumentCollection=objectArgs)>
				</cfif>
			</cfif>
		<cfelse>

			<cfswitch expression="#arguments.object#">
				<cfcase value="sub_nav"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="nav/dsp_sub.cfm",cachekey=cacheKeyContentId,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat,params=arguments.params)></cfcase>
				<cfcase value="peer_nav"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="nav/dsp_peer.cfm",cachekey=cacheKeyContentId,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat,params=arguments.params)></cfcase>
				<cfcase value="standard_nav"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="nav/dsp_standard.cfm",cachekey=cacheKeyContentId,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat,params=arguments.params)></cfcase>
				<cfcase value="portal_nav"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="nav/dsp_portal.cfm",cachekey=cacheKeyContentId,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat,params=arguments.params)></cfcase>
				<cfcase value="folder_nav"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="nav/dsp_folder.cfm",cachekey=cacheKeyContentId,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat,params=arguments.params)></cfcase>
				<cfcase value="multilevel_nav"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="nav/dsp_multilevel.cfm",cachekey=cacheKeyContentId,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat,params=arguments.params)></cfcase>
				<cfcase value="seq_nav"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="nav/dsp_sequential.cfm",cachekey=cacheKeyContentId & event.getValue('startRow'),showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat,params=arguments.params)></cfcase>
				<cfcase value="top_nav"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="nav/dsp_top.cfm",cachekey=cacheKeyContentId,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat,params=arguments.params)></cfcase>
				<cfcase value="contact"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_contact.cfm",params=arguments.params)></cfcase>
				<cfcase value="calendar_nav"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="nav/calendarNav/index.cfm",showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat,params=arguments.params)></cfcase>
				<cfcase value="plugin"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,params=arguments.params,objectid=arguments.objectid,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)></cfcase>
				<cfcase value="mailing_list"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_mailing_list.cfm",showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat,params=arguments.params)></cfcase>
				<cfcase value="mailing_list_master"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_mailing_list_master.cfm",showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat,params=arguments.params)></cfcase>
				<cfcase value="site_map"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_site_map.cfm",cacheKey=cacheKeyObjectId,params=arguments.params,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)></cfcase>
				<cfcase value="category_summary">
					<cfif isValid('uuid',arguments.objectid)>
						<cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteID=arguments.siteid,object=arguments.object,objectID=arguments.objectid,filename="dsp_category_summary.cfm",cacheKey=cacheKeyObjectId & event.getValue('categoryID'),params=arguments.params,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)>
					<cfelse>
						<cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteID=arguments.siteid,object=arguments.object,objectID=arguments.objectid,filename="dsp_category_summary.cfm",params=arguments.params,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)>
					</cfif>
				</cfcase>
				<cfcase value="archive_nav">
					<cfif isValid('uuid',arguments.objectid)>
						<cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="nav/dsp_archive.cfm",cachekey=cacheKeyObjectId,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)>
					<cfelse>
						<cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="nav/dsp_archive.cfm",showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)>
					</cfif>
				</cfcase>
				<cfcase value="form"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="datacollection/index.cfm",cachekey=cacheKeyObjectId,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)></cfcase>
				<cfcase value="form_responses"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dataresponses/index.cfm",cachekey=cacheKeyObjectId & event.getValue("responseID") & event.getValue("startrow"),showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)></cfcase>
				<cfcase value="component"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectID=arguments.objectid,filename="dsp_template.cfm",cacheKey=cacheKeyObjectId,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)></cfcase>
				<cfcase value="ad"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_ad.cfm",showEditable=showEditable,isConfigurator=editableControl.isConfigurator)></cfcase>
				<cfcase value="comments"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_comments.cfm",showEditable=showEditable,isConfigurator=editableControl.isConfigurator)></cfcase>
				<cfcase value="event_reminder_form"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_event_reminder_form.cfm",cachekey=cacheKeyContentId,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)></cfcase>
				<cfcase value="forward_email"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_forward_email.cfm",showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)></cfcase>
				<cfcase value="adzone"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_adZone.cfm",showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)></cfcase>
				<cfcase value="feed">
					<cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteID=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_feed.cfm",cacheKey=cacheKeyObjectId  & arguments.renderer.getListFormat() & "startrow#request.startrow#",params=arguments.params,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)>
				</cfcase>
				<cfcase value="feed_slideshow">
					<cfif not request.muraMobileTemplate>
						<cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteID=arguments.siteid,object=arguments.object,objectID=arguments.objectid,filename="feedslideshow/index.cfm",params=arguments.params,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)>
					<cfelse>
						<cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteID=arguments.siteid,object=arguments.object,objectID=arguments.objectid,filename="dsp_feed.cfm",params=arguments.params,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)>
					</cfif>
				</cfcase>
				<cfcase value="feed_table"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="feedtable/index.cfm",cachekey=arguments.object,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat,params=arguments.params)></cfcase>
				<cfcase value="payPalCart"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="paypalcart/index.cfm",showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat,params=arguments.params)></cfcase>
				<cfcase value="rater"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="rater/index.cfm",showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat,params=arguments.params)></cfcase>
				<cfcase value="favorites"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="favorites/index.cfm",showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat,params=arguments.params)></cfcase>
				<cfcase value="dragable_feeds"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dragablefeeds/index.cfm",showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat,params=arguments.params)></cfcase>
				<cfcase value="related_content">
					<cfparam name="arguments.params.relatedContentSetName" default="default">
					<cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteID=arguments.siteid,object=arguments.object,objectID=arguments.objectid,filename="dsp_related_content.cfm",cacheKey=cacheKeyContentId & arguments.renderer.getListFormat() & arguments.params.relatedContentSetName,params=arguments.params,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)>
				</cfcase>
				<cfcase value="related_section_content">
					<cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteID=arguments.siteid,object=arguments.object,objectID=arguments.objectid,filename="dsp_related_section_content.cfm",cachekey=cacheKeyContentId & arguments.renderer.getListFormat(),params=arguments.params,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)>
				</cfcase>
				<cfcase value="user_tools"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_user_tools.cfm",showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat,params=arguments.params)></cfcase>
				<cfcase value="tag_cloud">
					<cfsavecontent variable="tempObject"><cf_CacheOMatic key="#cacheKeyObjectId#" nocache="#event.getValue('nocache')#"><cfoutput>#arguments.renderer.dspTagCloud(argumentCollection=arguments)#</cfoutput></cf_CacheOMatic></cfsavecontent>
					<cfset tempObject=trim(tempObject)>
					<cfset theObject=tempObject>
					<cfif arguments.renderer.useLayoutmanager()>
						<cfif request.muraFrontEndRequest>
								<cfset theObject=renderObjectInManager(object=arguments.object,
									objectid=arguments.objectid,
									content=theObject,
									objectParams=arguments.params,
									objectname=arguments.objectname,
									showEditable=showEditable,
									isConfigurator=editableControl.isConfigurator,
									objectname=arguments.objectname,
									renderer=arguments.renderer,
									returnformat=arguments.returnformat)>
								<cfif isStruct(theObject)>
									<cfset theObject.html=tempObject>
								</cfif>
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="goToFirstChild"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="act_goToFirstChild.cfm",showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)></cfcase>
				<!--- BEGIN DEPRICATED --->
				<cfcase value="submit_event"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_submit_event.cfm",cachekey=cacheKeyContentId,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)></cfcase>
				<cfcase value="promo"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_promo.cfm",showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)></cfcase>
				<cfcase value="public_content_form"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_public_content_form.cfm",showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)></cfcase>
				<cfcase value="category_summary_rss"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,fileName="dsp_category_summary.cfm",showEditable=showEditable,cacheKey=cacheKeyObjectId & event.getValue('categoryID'),useRss=true,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)></cfcase>
				<cfcase value="feed_no_summary">
					<cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteID=arguments.siteid,object=arguments.object,objectID=arguments.objectid,fileName="dsp_feed.cfm",cacheKey=cacheKeyObjectId & "startrow#request.startrow#",hasSummary=false,params=arguments.params,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)>
				</cfcase>
				<cfcase value="feed_slideshow_no_summary">
					<cfif not request.muraMobileTemplate>
						<cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,fileName="feedslideshow/index.cfm",hasSummary=false,params=arguments.params,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)>
					<cfelse>
						<cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteID=arguments.siteid,object=arguments.object,objectID=arguments.objectid,fileName="dsp_feed.cfm",cacheKey=cacheKeyObjectId & "startrow#request.startrow#",hasSummary=false,params=arguments.params,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)>
					</cfif>
				</cfcase>
				<cfcase value="related_section_content_no_summary">
					<cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_related_section_content.cfm",cachekey=cacheKeyContentId,hasSummary=false,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)>
				</cfcase>
				<cfcase value="features">
					<cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_features.cfm",cachekey=cacheKeyObjectId,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)>
				</cfcase>
				<cfcase value="features_no_summary">
					<cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_features.cfm",cachekey=cacheKeyObjectId,hasSummary=false,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)>
				</cfcase>
				<cfcase value="category_features"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_category_features.cfm",cachekey=cacheKeyObjectId,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)></cfcase>
				<cfcase value="category_features_no_summary"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_category_features.cfm",cachekey=cacheKeyObjectId,hasSummary=false,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)></cfcase>
				<cfcase value="category_Folder_features"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_category_Folder_features.cfm",cachekey=cacheKeyObjectId,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)></cfcase>
				<cfcase value="category_Folder_features_no_summary"><cfset theObject=arguments.renderer.dspObject_Render(regionid=arguments.regionid,siteid=arguments.siteid,object=arguments.object,objectid=arguments.objectid,filename="dsp_category_Folder_features.cfm",cachekey=cacheKeyObjectId,hasSummary=false,showEditable=showEditable,isConfigurator=editableControl.isConfigurator,objectname=arguments.objectname,returnformat=arguments.returnformat)></cfcase>
				<!--- END DEPRICATED --->
			</cfswitch>
		</cfif>

		<cfif not arguments.layoutmanager and request.muraValidObject and showEditable and ((request.muraFrontEndRequest and not request.muraAsyncEditableObject) or (not request.muraFrontEndRequest and request.muraAsyncEditableObject))>
			<cfif isSimpleValue(theObject)>
				<cfset theObject=$.renderEditableObjectHeader(editableControl.class) & theObject & $.renderEditableObjectFooter($.generateEditableObjectControl(editableControl.editLink,editableControl.isConfigurator))>
			<cfelseif isStruct(theObject)>
				<cfset theObject.header=$.renderEditableObjectHeader(editableControl.class)>
				<cfset theObject.footer=$.renderEditableObjectFooter($.generateEditableObjectControl(editableControl.editLink,editableControl.isConfigurator))>
			</cfif>
		<cfelseif not request.muraValidObject>
			<cfset theObject="<!-- Invalid Display Object (Type: #arguments.object#, ID: #arguments.objectid#) -->">
			<cfset request.muraValidObject=true>
		</cfif>
		<cfif isSimpleValue(theObject)>
			<cfreturn trim(theObject) />
		<cfelse>
			<cfreturn theObject />
		</cfif>
	</cffunction>

	<cffunction name="dspObjects" output="false">
		<cfargument name="columnID" required="yes" type="numeric" default="1">
		<cfargument name="ContentHistID" required="yes" type="string" default="#event.getValue('contentBean').getcontenthistid()#">
		<cfargument name="returnFormat" default="string">
		<cfargument name="renderer">
		<cfargument name="layoutmanager">
		<cfargument name="allowInheritance" default="true">
		<cfargument name="label" default="">

		<cfset var event=arguments.renderer.getEvent()>
		<cfset var $=arguments.renderer.getMuraScope()>
		<cfset var rsObjects="">
		<cfset var theRegion={header='',footer='',inherited={header='',footer='',items=[]},local={header='',footer='',items=[]}}/>
		<cfset var theObject="">
		<cfset var perm=(listFindNoCase('author,editor',$.event('r').perm))?true:false>
		<cfset var i=''>
		<cfset var html=''>
		<cfset var objectReturnFormat=(arguments.returnFormat eq 'Array')?'struct':'default'>

		<cfparam name="request.muraActiveRegions" default="">
		<cfparam name="request.muraRegionObjectCounts" default="#structNew()#">

		<cfset request.muraActiveRegions=listAppend(request.muraActiveRegions,arguments.columnid)>

		<cfif arguments.renderer.uselayoutmanager()>
			<cfset var inheritedObjectsPerm='none'>
		<cfelse>
			<cfset var inheritedObjectsPerm=event.getValue("inheritedObjectsPerm")>
		</cfif>

		<cfset request.muraRegionID=arguments.columnID>
		<cfset request.muraRegionObjectCounts['region#arguments.columnID#']=0>

		<cfif perm and arguments.renderer.getShowToolbar() and arguments.renderer.showInlineEditor>
			<cfif len(arguments.label)>
				<cfset var regionLabel=UCASE(arguments.label)>
			<cfelseif listLen($.siteConfig('columnnames'),'^') gte arguments.columnid>
				<cfset var regionLabel=UCASE(listGetAt($.siteConfig('columnnames'),arguments.columnid,'^'))>
			<cfelse>
				<cfset var regionLabel=arguments.columnid>
			</cfif>
			<cfset theRegion.header='<div class="mura-region">'>
			<cfset theRegion.footer='</div>'>

			<cfset theRegion.local.header='<div class="mura-editable mura-inactive"><div class="mura-region-local mura-inactive mura-editable-attribute" data-loose="false" data-regionid="#arguments.columnid#" data-inited="false" data-perm="#perm#"><label style="display:none" class="mura-editable-label">DISPLAY REGION : #regionLabel#</label>'>
			<cfset theRegion.local.footer='</div></div>'>

			<cfset theRegion.inherited.header='<div class="mura-region-inherited">'>
			<cfset theRegion.inherited.footer='</div>'>

		<cfelse>
			<cfset theRegion.header='<div class="mura-region">'>
			<cfset theRegion.footer='</div>'>

			<cfset theRegion.local.header='<div class="mura-region-local">'>
			<cfset theRegion.local.footer='</div>'>

			<cfset theRegion.inherited.header='<div class="mura-region-inherited">'>
			<cfset theRegion.inherited.footer='</div>'>
		</cfif>

		<cfif (event.getValue('isOnDisplay')
				and ((not event.getValue('r').restrict)
					or (event.getValue('r').restrict and event.getValue('r').allow)))
						and not (listFindNoCase('search,editprofile,login',event.getValue('display')) and arguments.renderer.getSite().getPrimaryColumn() eq arguments.columnid)>

			<cfif arguments.allowInheritance and event.getValue('contentBean').getinheritObjects() eq 'inherit'
				and event.getValue('inheritedObjects') neq ''
				and event.getValue('contentBean').getcontenthistid() eq arguments.contentHistID>
					<cfset rsObjects=getBean('contentGateway').getObjectInheritance(arguments.columnID,event.getValue('inheritedObjects'),event.getValue('siteID'))>
					<cfset request.muraRegionObjectCounts['region#arguments.columnID#']=rsObjects.recordcount>
					<cfloop query="rsObjects">
						<cfset theObject=arguments.renderer.dspObject(object=rsObjects.object,objectid=rsObjects.objectid,siteid=event.getValue('siteID'), params=rsObjects.params, assignmentid=event.getValue('inheritedObjects'), regionid=arguments.columnID, orderno=rsObjects.orderno, hasConfigurator=len(rsObjects.configuratorInit),assignmentPerm=inheritedObjectsPerm,objectname=rsObjects.name,returnformat=objectReturnFormat)>
						<cfif isSimpleValue(theObject)>
							<cfset theObject={html=theObject}>
						</cfif>
						<cfset arrayAppend(theRegion.inherited.items,theObject) />
						<cfset request.muraRegionID=arguments.columnID>
					</cfloop>
			</cfif>

			<cfset rsObjects=getBean('contentGateway').getObjects(arguments.columnID,arguments.contentHistID,event.getValue('siteID'))>
			<cfset request.muraRegionObjectCounts['region#arguments.columnID#']=request.muraRegionObjectCounts['region#arguments.columnID#'] + rsObjects.recordcount>
			<cfloop query="rsObjects">
				<cfset theObject=arguments.renderer.dspObject(object=rsObjects.object,objectid=rsObjects.objectid,siteid=event.getValue('siteID'), params=rsObjects.params, assignmentid=arguments.contentHistID, regionid=arguments.columnID, orderno=rsObjects.orderno, hasConfigurator=len(rsObjects.configuratorInit),assignmentPerm=$.event('r').perm,objectname=rsObjects.name,returnformat=objectReturnFormat,RenderingAsRegion=true)>
				<cfif isSimpleValue(theObject)>
					<cfset theObject={html=theObject}>
				</cfif>
				<cfset arrayAppend(theRegion.local.items,theObject) />
				<cfset request.muraRegionID=arguments.columnID>
			</cfloop>
		</cfif>
		<cfset request.muraRegionID=0>

		<cfif arguments.returnFormat eq 'array'>
			<cfreturn theRegion >
		<cfelse>
			<cfif arguments.layoutmanager>
				<cfset html=html & theRegion.header>
			</cfif>

			<cfif arrayLen(theRegion.inherited.items)>
				<cfif arguments.layoutmanager>
					<cfset html=html & theRegion.inherited.header>
				</cfif>

				<cfloop array="#theRegion.inherited.items#" index="i">
					<cfif isDefined('i.html')>
						<cfset html=html & i.html>
					</cfif>
				</cfloop>

				<cfif arguments.layoutmanager>
					<cfset html=html & theRegion.inherited.footer>
				</cfif>
			</cfif>

			<cfif arguments.layoutmanager>
				<cfset html=html & theRegion.local.header>
			</cfif>

			<cfloop array="#theRegion.local.items#" index="i">
				<cfif isDefined('i.html')>
					<cfset html=html & i.html>
				</cfif>
			</cfloop>

			<cfif arguments.layoutmanager>
				<cfset html=html & theRegion.local.footer>
				<cfset html=html & theRegion.footer>
			</cfif>

			<cfreturn html>
		</cfif>

	</cffunction>

	<cffunction name="createHREF" output="false">
		<cfargument name="type" required="true" default="Page">
		<cfargument name="filename" required="true">
		<cfargument name="siteid" required="true" default="">
		<cfargument name="contentid" required="true" default="">
		<cfargument name="target" required="true" default="">
		<cfargument name="targetParams" required="true" default="" hint="deprecated, does not do anything.  May come be re-introduced for modal params">
		<cfargument name="querystring" required="true" default="">
		<cfargument name="context" type="string" required="true" default="#application.configBean.getContext()#" hint="deprecated">
		<cfargument name="stub" type="string" required="true" default="#application.configBean.getStub()#" hint="deprecated">
		<cfargument name="indexFile" type="string" required="true" default="" hint="deprecated">
		<cfargument name="complete" type="boolean" required="true" default="false">
		<cfargument name="showMeta" type="string" required="true" default="0">
		<cfargument name="bean" hint="The contentBean that link is being generated for">
		<cfargument name="secure" default="false">
		<cfargument name="renderer">
		<cfargument name="hashURLS">

		<cfset var href=""/>
		<cfset var tp=""/>
		<cfset var q=''>
		<cfset var qsa="">
		<cfset var qq="">

		<cfif arguments.renderer.hasMuraScope() and len(arguments.renderer.getMuraScope().event('siteID')) and arguments.renderer.getMuraScope().event('siteID') neq arguments.siteID>
			<cfif not len(arguments.siteid)>
				<cfset arguments.siteid=arguments.renderer.getMuraScope().event('siteID')>
			</cfif>
			<cfif arguments.siteid neq arguments.renderer.getMuraScope().event('siteID')>
				<cfset arguments.complete=1>
				<cfreturn getBean('settingsManager').getSite(arguments.siteid).getContentRenderer().createHREF(argumentCollection=arguments)>
			</cfif>
		</cfif>

		<cfset var begin=getBean('settingsManager').getSite(arguments.siteid).getWebPath(argumentCollection=arguments)>

		<cfif len(arguments.querystring)>
			<cfif not arguments.hashURLS and not left(arguments.querystring,1) eq "?">
				<cfset arguments.querystring="?" & arguments.querystring>
			<cfelseif arguments.hashURLS>
				<cfset qsa="_">
				<cfset arguments.queryString=listFirst(arguments.querystring,"?")>
				<cfloop list="#arguments.queryString#" index="q" delimiters="&">
					<cfset qq=listToArray(q,"=")>
					<cfif arrayLen(qq) eq 2>
						<cfset qsa=qsa & "/#urlEncodedFormat(qq[1])#/#qq[2]#">
					<cfelse>
						<cfset qsa=qsa & "/#urlEncodedFormat(qq[1])#/true">
					</cfif>
				</cfloop>
				<cfset arguments.queryString=qsa>
			</cfif>
		</cfif>

		<cfif not isDefined('arguments.bean')
			and (
					(
						not len(arguments.filename)
						and len(arguments.contentID)
						and arguments.contentid neq '00000000000000000000000000000000001'
					)
				or
					request.muraExportHTML and listFindNoCase("Link,File",arguments.type)
				)
			>
			<cfset arguments.bean=getBean("content").loadBy(contentID=arguments.contentID,siteID=arguments.siteID)>
			<cfset arguments.filename=arguments.bean.getFilename()>
		</cfif>

		<cfif arguments.hashURLS and len(arguments.queryString) and right(arguments.filename,1) neq "/">
			<cfset arguments.queryString="/" & arguments.queryString>
		</cfif>

		<cfswitch expression="#arguments.type#">
			<cfcase value="Link,File">
				<cfif not request.muraExportHTML>
					<cfif arguments.hashURLS>
						<cfset href=HTMLEditFormat("#begin##arguments.renderer.getURLStem(arguments.siteid,'#arguments.filename##arguments.querystring#')#") />
					<cfelse>
						<cfset href=HTMLEditFormat("#begin##arguments.renderer.getURLStem(arguments.siteid,'#arguments.filename#')##arguments.querystring#") />
					</cfif>
				<cfelseif arguments.type eq "Link">
					<cfset href=arguments.bean.getBody()>
				<cfelse>
					<cfset href="#getBean('configBean').getContext()#/#arguments.siteID#/cache/file/#arguments.bean.getFileID()#/#arguments.bean.getBody()#">
				</cfif>
			</cfcase>
			<cfdefaultcase>
				<cfif arguments.hashURLS>
					<cfset href=HTMLEditFormat("#begin##arguments.renderer.getURLStem(arguments.siteid,'#arguments.filename##arguments.querystring#')#") />
				<cfelse>
					<cfset href=HTMLEditFormat("#begin##arguments.renderer.getURLStem(arguments.siteid,'#arguments.filename#')##arguments.querystring#") />
				</cfif>
			</cfdefaultcase>
		</cfswitch>

		<cfreturn href />
	</cffunction>

	<cffunction name="createHREFforRSS" output="false">
		<cfargument name="type" required="true" default="Page">
		<cfargument name="filename" required="true">
		<cfargument name="siteid" required="true">
		<cfargument name="contentid" required="true" default="">
		<cfargument name="target" required="true" default="">
		<cfargument name="targetParams" required="true" default="" hint="deprecated">
		<cfargument name="context" type="string" default="#application.configBean.getContext()#" hint="deprecated">
		<cfargument name="stub" type="string" default="#application.configBean.getStub()#" hint="deprecated">
		<cfargument name="indexFile" type="string" default="">
		<cfargument name="showMeta" type="string" default="0">
		<cfargument name="fileExt" type="string" default="" required="true">
		<cfargument name="secure" default="false">
		<cfargument name="renderer">

		<cfset var href=""/>
		<cfset var tp=""/>

		<cfset var site=getBean('settingsManager').getSite(arguments.siteid)>

		<cfif arguments.renderer.hasMuraScope() and len(arguments.renderer.getMuraScope().event('siteID')) and arguments.renderer.getMuraScope().event('siteID') neq arguments.siteID>
			<cfreturn site.getContentRenderer().createHREFforRSS(argumentCollection=arguments)>
		</cfif>

		<cfswitch expression="#arguments.type#">
				<cfcase value="Link">
					<cfset arguments.queryString="showMeta=#arguments.showMeta#">
				</cfcase>
				<cfcase value="File">
					<cfset arguments.queryString="showMeta=#arguments.showMeta#&fileExt=.#arguments.fileExt#">
				</cfcase>
				<cfdefaultcase>
					<cfset arguments.queryString="">
				</cfdefaultcase>
		</cfswitch>

		<cfreturn arguments.renderer.createHREF(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="createHREFForImage" output="false">
		<cfargument name="siteID">
		<cfargument name="fileID">
		<cfargument name="fileExt">
		<cfargument name="size" required="true" default="undefined">
		<cfargument name="direct" required="true" default="#this.directImages#">
		<cfargument name="complete" type="boolean" required="true" default="false">
		<cfargument name="height" default=""/>
		<cfargument name="width" default=""/>
		<cfargument name="secure" default="false">
		<cfreturn getBean("fileManager").createHREFForImage(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="addlink" output="false">
		<cfargument name="type" required="true">
		<cfargument name="filename" required="true">
		<cfargument name="title" required="true">
		<cfargument name="target" type="string"  default="">
		<cfargument name="targetParams" type="string"  default="">
		<cfargument name="contentid" required="true">
		<cfargument name="siteid" required="true">
		<cfargument name="querystring" type="string" required="true" default="">
		<cfargument name="context" type="string" required="true" default="#application.configBean.getContext()#">
		<cfargument name="stub" type="string" required="true" default="#application.configBean.getStub()#">
		<cfargument name="indexFile" type="string" required="true" default="">
		<cfargument name="showMeta" type="string" required="true" default="0">
		<cfargument name="showCurrent" type="string" required="true" default="1">
		<cfargument name="class" type="string" required="true" default="">
		<cfargument name="complete" type="boolean" required="true" default="false">
		<cfargument name="id" type="string" required="true" default="">
		<cfargument name="aHasKidsClass" required="true" default="#this.aHasKidsClass#">
		<cfargument name="aHasKidsAttributes" required="true" default="#this.aHasKidsAttributes#">
		<cfargument name="aCurrentClass" required="true" default="#this.aCurrentClass#">
		<cfargument name="aCurrentAttributes" required="true" default="#this.aCurrentAttributes#">
		<cfargument name="isParent" required="true" default="false">
		<cfargument name="aNotCurrentClass" required="true" default="#this.aNotCurrentClass#">
		<cfargument name="secure" default="false">
		<cfargument name="isBreadCrumb" default="false">
		<cfargument name="renderer">

		<cfset var link ="">
		<cfset var href ="">
		<cfset var theClass =arguments.class>
		<cfset var event=arguments.renderer.getEvent()>
		<!--- Supporting Old Arguments--->
		<cfif structKeyExists(arguments,'aHasKidsCustomString')>
			<cfset arguments.aHasKidsAttributes=arguments.aHasKidsCustomString>
		</cfif>
		<cfif structKeyExists(arguments,'aCurrentCustomString')>
			<cfset arguments.aCurrentAttributes=arguments.aCurrentCustomString>
		</cfif>
		<!--- --->

		<cfif arguments.showCurrent>
			<cfset arguments.showCurrent=listFind(event.getValue('contentBean').getPath(),"#arguments.contentID#")>
		</cfif>
		<cfif arguments.showCurrent>
			<cfset theClass=listAppend(theClass,arguments.aCurrentClass," ") />
		<cfelseif len(arguments.aNotCurrentClass)>
			<cfset theClass=listAppend(theClass,arguments.aNotCurrentClass," ") />
		</cfif>
		<cfif arguments.isParent>
			<cfset theClass=listAppend(theClass,arguments.aHasKidsClass," ") />
		</cfif>

		<cfset href=arguments.renderer.createHREF(type=arguments.type,filename=arguments.filename,siteid=arguments.siteid,contentid=arguments.contentid,target=arguments.target,targetparams=iif(arguments.filename eq event.getValue('contentBean').getfilename(),de(''),de(arguments.targetParams)),querystring=arguments.queryString,context=arguments.context,stub=arguments.stub,indexfile=arguments.indexFile,complete=arguments.complete,showmeta=arguments.showMeta,secure=arguments.secure)>
		<cfif arguments.isBreadCrumb>
			<cfset link='<a itemprop="item" href="#href#"#iif(len(arguments.target) and arguments.target neq '_self',de(' target="#arguments.target#"'),de(""))##iif(len(theClass),de(' class="#theClass#"'),de(""))##iif(len(arguments.id),de(' id="#arguments.id#"'),de(""))##iif(arguments.showCurrent,de(' #replace(arguments.aCurrentAttributes,"##","####","all")#'),de(""))##iif(arguments.isParent and len(arguments.aHasKidsAttributes),de(' #replace(arguments.aHasKidsAttributes,"##","####","all")#'),de(""))#><span itemprop="name">#HTMLEditFormat(arguments.title)#</span></a>' />
		<cfelse>
			<cfset link='<a href="#href#"#iif(len(arguments.target) and arguments.target neq '_self',de(' target="#arguments.target#"'),de(""))##iif(len(theClass),de(' class="#theClass#"'),de(""))##iif(len(arguments.id),de(' id="#arguments.id#"'),de(""))##iif(arguments.showCurrent,de(' #replace(arguments.aCurrentAttributes,"##","####","all")#'),de(""))##iif(arguments.isParent and len(arguments.aHasKidsAttributes),de(' #replace(arguments.aHasKidsAttributes,"##","####","all")#'),de(""))#>#HTMLEditFormat(arguments.title)#</a>' />
		</cfif>

		<cfreturn link>
	</cffunction>

	<cffunction name="dspCrumblistLinks"  output="false">
		<cfargument name="id" type="string" default="crumblist">
		<cfargument name="separator" type="string" default="">
		<cfargument name="class" type="string" default="">
		<cfargument name="renderer">
		<cfset var crumbdata=arguments.renderer.getValue('crumbdata')>
		<cfset var thenav="" />
		<cfset var theOffset=arrayLen(arguments.renderer.crumbdata)- arguments.renderer.getNavOffSet() />
		<cfset var I = 0 />
		<cfset var event=arguments.renderer.getEvent()>
		<cfset var counter=0 />
		<cfif not len(arguments.class)>
			<cfset arguments.class=arguments.renderer.navBreadcrumbULClass>
		</cfif>
		<cfif arrayLen(crumbdata) gt (1 + arguments.renderer.getNavOffSet())>
			<cfsavecontent variable="theNav">
				<cfoutput><ol itemscope itemtype="http://schema.org/BreadcrumbList"<cfif len(arguments.id)> id="#arguments.id#"</cfif> class="mura-breadcrumb<cfif Len(arguments.class)> #arguments.class#</cfif>">
					<cfloop from="#theOffset#" to="1" index="I" step="-1">
						<cfif I neq 1>
							<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem" class="<cfif len(arguments.renderer.liBreadcrumbNotCurrentClass)><cfif I eq theOffset>first </cfif>#arguments.renderer.liBreadcrumbNotCurrentClass#<cfelseif I eq theOffset>first</cfif>">
								<cfif I neq theOffset>#arguments.separator#</cfif>
								#arguments.renderer.addlink(
									type=crumbdata[I].type,
									filename=crumbdata[I].filename,
									title=crumbdata[I].menutitle,
									target='_self',
									targetparams='',
									contentid=crumbdata[I].contentid,
									siteid=crumbdata[I].siteid,
									queryString='',
									context=application.configBean.getContext(),
									stub=application.configBean.getStub(),
									indexFile=application.configBean.getIndexFile(),
									showMeta=event.getValue('showMeta'),
									showCurrent=0,
									isBreadCrumb=true,
									aCurrentClass=arguments.renderer.aBreadcrumbCurrentClass,
									aNotCurrentClass=arguments.renderer.aBreadcrumbNotCurrentClass)#
									<cfset counter=counter+1>
									<meta itemprop="position" content="#counter#" />
							</li>
						<cfelse>
							<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem" class="<cfif arraylen(crumbdata)>last<cfelse>first</cfif><cfif len(arguments.renderer.liBreadcrumbNotCurrentClass)> #arguments.renderer.liBreadcrumbCurrentClass#</cfif>">
								#arguments.separator#
								#arguments.renderer.addlink(type=crumbdata[1].type,
									filename=crumbdata[1].filename,
									title=crumbdata[1].menutitle,
									target='_self',
									targetparams='',
									contentid=crumbdata[1].contentid,
									siteid=crumbdata[1].siteid,
									queryString='',
									context=application.configBean.getContext(),
									stub=application.configBean.getStub(),
									indexfile=application.configBean.getIndexFile(),
									showMeta=event.getValue('showMeta'),
									showCurrent=0,
									isBreadCrumb=true,
									aCurrentClass=arguments.renderer.aBreadcrumbCurrentClass,
									aNotCurrentClass=arguments.renderer.aBreadcrumbNotCurrentClass
								)#
								<meta itemprop="position" content="#arrayLen(crumbdata)#" />
							</li>
						</cfif>
					</cfloop>
				</ol></cfoutput>
			</cfsavecontent>
		</cfif>

		<cfreturn trim(theNav)>
	</cffunction>

	<cffunction name="renderIcon" output="false">
		<cfargument name="data">
		<cfargument name="renderer">

		<cfset var iconclass=application.configBean.getClassExtensionManager().getIconClass(argumentCollection=arguments.data)>

		<cfif len(iconclass)>
			<cfreturn iconclass>
		</cfif>

		<cfif arguments.data.type eq 'File'>
			<cfif structKeyExists(arguments.data,"fileExt")>
				<cfreturn lcase(arguments.data.fileExt)>
			<cfelse>
				<cfreturn "page">
			</cfif>
		<cfelse>
			<cfreturn lcase(arguments.data.type)>
		</cfif>
	</cffunction>

	<cffunction name="addToHTMLHeadQueue" output="false">
		<cfargument name="text">
		<cfargument name="action" default="append">
		<cfargument name="renderer">
		<cfset var event=arguments.renderer.getEvent()>
		<cfset var q=event.getValue(property='HTMLHeadQueue',defaultValue=[])>
		<cfif not arrayFind(q,arguments.text)>
			<cfif arguments.action eq "append">
				<cfset arrayAppend(q,arguments.text)>
			<cfelse>
				<cfset arrayPrepend(q,arguments.text)>
			</cfif>
			<cfset event.setValue('HTMLHeadQueue',q) />
		</cfif>
	</cffunction>

	<cffunction name="addToHTMLFootQueue" output="false">
		<cfargument name="text">
		<cfargument name="action" default="append">
		<cfargument name="renderer">
		<cfset var event=arguments.renderer.getEvent()>
		<cfset var q=event.getValue(property='HTMLFootQueue',defaultValue=[])>
		<cfif not arrayFind(q,arguments.text)>
			<cfif arguments.action eq "append">
				<cfset arrayAppend(q,arguments.text)>
			<cfelse>
				<cfset arrayPrepend(q,arguments.text)>
			</cfif>
			<cfset event.setValue('HTMLFootQueue',q) />
		</cfif>
	</cffunction>

	<cffunction name="renderObjectClassOption" output="false">
		<cfargument name="object">
		<cfargument name="objectid" default="">
		<cfargument name="objectname" default="">
		<cfargument name="objectlabel">
		<cfargument name="objecticonclass" default="mi-cog">

		<cfif not isDefined('arguments.objectlabel')>
			<cfset arguments.objectlabel=arguments.objectname>
		</cfif>
		<cfreturn '<div class="mura-sidebar__objects-list__object-item mura-objectclass" data-object="#esapiEncode('html_attr',arguments.object)#" data-objectid="#esapiEncode('html_attr',arguments.objectid)#" data-objectname="#esapiEncode('html_attr',arguments.objectname)#" data-objecticonclass="#esapiEncode('html_attr',arguments.objecticonclass)#"><i class="#esapiEncode('html_attr',arguments.objecticonclass)#"></i> #esapiEncode('html',arguments.objectlabel)#</div>'>
	</cffunction>

	<cffunction name="renderIntervalDesc" output="false">
		<cfargument name="content">
		<cfargument name="renderer">
		<cfargument name="showTitle" default="true">

		<cfset var displayInterval=arguments.content.getDisplayInterval().getAllValues()>
		<cfset var returnstring=''>
		<cfset var sessionData=getSession()>

		<cfif not isDate(arguments.content.getdisplayStart())>
			<cfreturn ''>
		<cfelseif arguments.showTitle and content.hasParent()>
			<cfset returnstring=esapiEncode('html',UCase(arguments.content.getParent().getMenuTitle())) & ': '>
		</cfif>

		<cfset var allday=displayInterval.allday or variables.intervalManager.isAllDay(arguments.content.getdisplayStart(),arguments.content.getdisplayStop())>

		<cfif isDate(arguments.content.getdisplayStart()) and isDate(arguments.content.getdisplayStop())
			and month(arguments.content.getdisplayStart()) eq month(arguments.content.getdisplayStop())
			and day(arguments.content.getdisplayStart()) eq day(arguments.content.getdisplayStop())
			and year(arguments.content.getdisplayStart()) eq year(arguments.content.getdisplayStop())>
			<cfif allday>
				<cfreturn returnstring & LSDateFormat(arguments.content.getdisplayStart(timezone=displayInterval.timezone),sessionData.dateKeyFormat) & ' ' & application.rbFactory.getKeyValue(sessionData.rb,'sitemanager.content.fields.displayinterval.allday')>
			<cfelse>
				<cfreturn returnstring & LSDateFormat(arguments.content.getdisplayStart(timezone=displayInterval.timezone),sessionData.dateKeyFormat) & ' ' & application.rbFactory.getKeyValue(sessionData.rb,'sitemanager.content.fields.displayinterval.from') & ' ' & LSTimeFormat(arguments.content.getDisplayStart(timezone=displayInterval.timezone)) & ' ' & application.rbFactory.getKeyValue(sessionData.rb,'sitemanager.content.fields.displayinterval.to') & ' ' & LSTimeFormat(arguments.content.getDisplayStop(timezone=displayInterval.timezone)) & " (" & getJavaTimezone(displayInterval.timezone).getDisplayName() & ")">
			</cfif>
		<cfelse>
			<cfif dateCompare(now(),arguments.content.getDisplayStart(),'d') eq -1>
				<cfset returnstring= returnstring & application.rbFactory.getKeyValue(sessionData.rb,'sitemanager.content.fields.displayinterval.starting') & ' ' & LSDateFormat(arguments.content.getdisplayStart(timezone=displayInterval.timezone),sessionData.dateKeyFormat) & ', '>
			</cfif>
			<cfset returnstring= returnstring & application.rbFactory.getKeyValue(sessionData.rb,'sitemanager.content.fields.displayinterval.#displayInterval.type#')>
		</cfif>

		<cfif listFindNoCase('weekly,bi-weekly,monthly,week1,week2,week3,week4,weeklast',displayInterval.type)>
			<cfset returnstring=returnstring & ' ' & lcase(application.rbFactory.getKeyValue(sessionData.rb,'sitemanager.content.fields.displayinterval.on')) & ' '>
			<cfset var started=false>
			<cfloop list="#displayInterval.daysofweek#" index="local.i">
				<cfif started><cfset returnstring=returnstring & ', '></cfif>
				<cfset started=true>
				<cfset returnstring=returnstring & listGetAt(application.rbFactory.getKeyValue(sessionData.rb,'calendar.weekdaylong'),local.i)>
			</cfloop>
		</cfif>

		<cfif isDate(arguments.content.getDisplayStop())>
			<cfif allday>
				<cfset returnstring=returnstring & ' ' & application.rbFactory.getKeyValue(sessionData.rb,'sitemanager.content.fields.displayinterval.allday')>
			<cfelse>
				<cfset returnstring=returnstring & ' ' & application.rbFactory.getKeyValue(sessionData.rb,'sitemanager.content.fields.displayinterval.from')>
				<cfset returnstring=returnstring & ' ' & LSTimeFormat(arguments.content.getDisplayStart(timezone=displayInterval.timezone)) & ' ' & application.rbFactory.getKeyValue(sessionData.rb,'sitemanager.content.fields.displayinterval.to') & ' ' & LSTimeFormat(arguments.content.getDisplayStop(timezone=displayInterval.timezone))>
			</cfif>
		<cfelse>
			<cfif allday>
				<cfset returnstring=returnstring & ' ' & application.rbFactory.getKeyValue(sessionData.rb,'sitemanager.content.fields.displayinterval.allday')>
			<cfelse>
				<cfset returnstring=returnstring & ' ' & application.rbFactory.getKeyValue(sessionData.rb,'sitemanager.content.fields.displayinterval.at') & ' ' & LSTimeFormat(arguments.content.getDisplayStart(timezone=displayInterval.timezone))>
			</cfif>
		</cfif>

		<cfif displayInterval.end eq 'on'>
			<cfset returnstring=returnstring & ',  ' & arguments.renderer.setProperCase(application.rbFactory.getKeyValue(sessionData.rb,'sitemanager.content.fields.displayinterval.until')) & ' ' & LSDateFormat(displayinterval.endon,sessionData.dateKeyFormat)>
		<cfelseif displayInterval.end eq 'after'>
			<cfset returnstring=returnstring & ', ' & arguments.renderer.setProperCase(application.rbFactory.getKeyValue(sessionData.rb,'sitemanager.content.fields.displayinterval.until')) & ' ' & displayinterval.endafter & ' ' & application.rbFactory.getKeyValue(sessionData.rb,'sitemanager.content.fields.displayinterval.occurrences')>
		</cfif>

		<cfset returnstring=returnstring & " (" & getJavaTimezone(displayInterval.timezone).getDisplayName() & ")">

		<cfreturn returnstring>
	</cffunction>

	<cffunction name="lookupCustomContentTypeBody" output="false" hint="This is for looking up overrides in dspBody">
		<cfargument name="$">

		<cfset var safesubtype=REReplace(arguments.$.content().getSubType(), "[^a-zA-Z0-9_]", "", "ALL")>
		<cfset var eventOutput="">
		<cfset var displayObjectKey='#arguments.$.content().getType()#_#safesubtype#'>
		<cfset var filePath="">

		<!--- START Checking for Override via Event Model --->
		<cfset eventOutput=arguments.$.renderEvent("onBodyRender")>

		<!--- For backwards compatibility --->
		<cfif not len(eventOutput) and arguments.$.content().getType() eq 'Folder'>
			<cfset eventOutput=arguments.$.renderEvent("onPortalBodyRender")>
			<cfif not len(eventOutput)>
				<cfset eventOutput=arguments.$.renderEvent("onPortal#arguments.$.content().getSubType()#BodyRender")>
			</cfif>
		</cfif>
		<!--- --->

		<cfif not len(eventOutput)>
			<cfset eventOutput=arguments.$.renderEvent("on#arguments.$.content().getType()##arguments.$.content().getSubType()#BodyRender")>
		</cfif>
		<cfif not len(eventOutput)>
			<cfset eventOutput=arguments.$.renderEvent("on#arguments.$.content().getType()#BodyRender")>
		</cfif>

		<cfif len(eventOutput)>
			<cfreturn {eventOutput=eventOutput}>
		</cfif>

		<!--- END Checking for Override via Event Model --->

		<!--- START Checking for Override via File  --->
		<cfset filePath=$.siteConfig().lookupDisplayObjectFilePath('#arguments.$.content().getType()#_#safesubtype#/index.cfm')>
		<cfif len(filePath)>
			<cfreturn {filepath=filePath}>
		</cfif>

		<cfset filePath=$.siteConfig().lookupDisplayObjectFilePath('#arguments.$.content().getType()##safesubtype#/index.cfm')>
		<cfif len(filePath)>
			<cfreturn {filepath=filePath}>
		</cfif>

		<cfset filePath=$.siteConfig().lookupDisplayObjectFilePath('custom/extensions/dsp_#arguments.$.content().getType()#_#safesubtype#.cfm')>

		<cfif len(filePath)>
			<cfreturn {filepath=filePath}>
		<cfelseif $.content('type') eq 'folder'>
			<cfset filePath=$.siteConfig().lookupDisplayObjectFilePath('custom/extensions/dsp_Portal_#safesubtype#.cfm')>
			<cfif len(filePath)>
				<cfreturn {filepath=filePath}>
			</cfif>
		</cfif>

		<cfset filePath=$.siteConfig().lookupDisplayObjectFilePath('extensions/dsp_#arguments.$.content().getType()#_#safesubtype#.cfm')>

		<cfif len(filePath)>
			<cfreturn {filepath=filePath}>
		<cfelseif $.content('type') eq 'folder'>
			<cfset filePath=$.siteConfig().lookupDisplayObjectFilePath('extensions/dsp_Portal_#safesubtype#.cfm')>
			<cfif len(filePath)>
				<cfreturn {filepath=filePath}>
			</cfif>
		</cfif>

		<!--- END Checking for Override via File  --->

		<!--- START Checking for Override via content_types includes  --->

		<cfset filePath=$.siteConfig().lookupContentTypeFilePath(lcase('#arguments.$.content().getType()#_#safesubtype#/index.cfm'))>
		<cfif len(filePath)>
			<cfreturn {filepath=filePath}>
		</cfif>

		<cfset filePath=$.siteConfig().lookupContentTypeFilePath(lcase('#arguments.$.content().getType()##safesubtype#/index.cfm'))>
		<cfif len(filePath)>
			<cfreturn {filepath=filePath}>
		</cfif>

		<cfset filePath=$.siteConfig().lookupContentTypeFilePath(lcase('#arguments.$.content().getType()#/index.cfm'))>
		<cfif len(filePath)>
			<cfreturn {filepath=filePath}>
		</cfif>

		<cfif not arguments.$.siteConfig().hasDisplayObject(arguments.$.content().getType())>
			<cfset filePath=$.siteConfig().lookupDisplayObjectFilePath('#arguments.$.content().getType()#/index.cfm')>
			<cfif len(filePath)>
				<cfreturn {filepath=filePath}>
			</cfif>
		</cfif>

		<!--- END Checking for Override via content_types includes--->

		<!--- START Checking for Override via Display Object --->

		<cfif arguments.$.siteConfig().hasDisplayObject(displayObjectKey)>
			<cfset var params=$.content().getObjectParams()>
			<cfset params.isBodyObject=true>
			<cfif not isdefined('params.objectname')>
				<cfset var objectDef=arguments.$.siteConfig().getDisplayObject(displayObjectKey)>
				<cfset params.objectname=objectDef.name>
			</cfif>
			<cfreturn {eventOutput=$.dspObject(objectid=$.content('contentid'),object=displayObjectKey,params=params,bodyRender=true)}>
		</cfif>

		<!---
		<cfset displayObjectKey='#arguments.$.content().getType()##safesubtype#'>

		<cfif arguments.$.siteConfig().hasDisplayObject(displayObjectKey)>
		<cfset var params=$.content().getObjectParams()>
		<cfset params.isBodyObject=true>
		<cfif not isdefined('params.objectname')>
			<cfset var objectDef=arguments.$.siteConfig().getDisplayObject(displayObjectKey)>
			<cfset params.objectname=objectDef.name>
		</cfif>
			<cfreturn {eventOutput=$.dspObject(objectid=$.content('contentid'),object=displayObjectKey,params=params,bodyRender=true)}>
		</cfif>

		<cfset displayObjectKey=arguments.$.content().getType()>

		<cfif arguments.$.siteConfig().hasDisplayObject(displayObjectKey) and arguments.$.siteConfig().getDisplayObject(displayObjectKey).custom>
		<cfset var params=$.content().getObjectParams()>
		<cfset params.isBodyObject=true>
		<cfif not isdefined('params.objectname')>
			<cfset var objectDef=arguments.$.siteConfig().getDisplayObject(displayObjectKey)>
			<cfset params.objectname=objectDef.name>
		</cfif>
			<cfreturn {eventOutput=$.dspObject(objectid=$.content('contentid'),object=displayObjectKey,params=params,bodyRender=true)}>
		</cfif>
		--->
		<!--- END Checking for Override via Display Object --->

		<cfreturn {}>
	</cffunction>

</cfcomponent>
