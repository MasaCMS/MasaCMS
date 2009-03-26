<circuit access="public">
<prefuseaction>
<set name="attributes.subTypeID" value="" overwrite="false" />
<set name="attributes.extendSetID" value="" overwrite="false" />
<set name="attributes.attibuteID" value="" overwrite="false" />
<set name="attributes.siteID" value="" overwrite="false" />

<if condition="not isUserInRole('S2IsPrivate')">
	<true>
		<relocate url="index.cfm?fuseaction=cLogin.main&amp;returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false"/>
	</true>
</if>
<if condition="not isUserInRole('S2')">
	<true>
		<relocate url="index.cfm" addtoken="false"/>
	</true>
</if>

</prefuseaction>


<fuseaction name="listSubTypes">
<do action="vExtend.listSubTypes" contentvariable="fusebox.layout" />
<do action="layout.display"/>
</fuseaction>

<fuseaction name="editSubType">
<do action="vExtend.ajax" contentvariable="fusebox.ajax"/>
<do action="vExtend.editSubType" contentvariable="fusebox.layout" />
<do action="layout.display"/>
</fuseaction>

<fuseaction name="editAttributes">
<do action="vExtend.ajax" contentvariable="fusebox.ajax"/>
<do action="vExtend.editAttributes" contentvariable="fusebox.layout" />
<do action="layout.display"/>
</fuseaction>

<fuseaction name="listSets">
<do action="vExtend.ajax" contentvariable="fusebox.ajax"/>
<do action="vExtend.listSets" contentvariable="fusebox.layout" />
<do action="layout.display"/>
</fuseaction>

<fuseaction name="editSet">
<do action="vExtend.editSet" contentvariable="fusebox.layout" />
<do action="layout.display"/>
</fuseaction>


<fuseaction name="updateSubType">
	
	 <invoke object="application.classExtensionManager" methodcall="getSubTypeByID(attributes.subTypeID)" returnVariable="request.subtype" />
	  <invoke object="request.subtype" methodcall="set(attributes)" />
	  <if condition="attributes.action eq 'Update'">
	  <true>
	  	<invoke object="request.subtype" methodcall="save()" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Delete'">
	  <true>
	  	<invoke object="request.subtype" methodcall="delete()" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Add'">
	  <true>
	  	<invoke object="request.subtype" methodcall="save()" />
	  </true>
	  </if> 
	
	  <if condition="attributes.action neq 'delete'">
	  <true>
	  	<relocate url="index.cfm?fuseaction=cExtend.listSets&amp;subTypeID=#request.subType.getSubTypeID()#&amp;siteid=#attributes.siteid#" addtoken="false"/>
	  </true>
	  <false>
	  	<relocate url="index.cfm?fuseaction=cExtend.listSubTypes&amp;siteid=#attributes.siteid#" addtoken="false"/>
	  </false>
	  </if>
	  	<!--<relocate url="index.cfm?fuseaction=cExtend.editAttributes&amp;subTypeID=#request.subType.getSubTypeID()#&amp;siteid=#attributes.siteid#&amp;action=#attributes.action#" addtoken="false"/>-->
</fuseaction>


<fuseaction name="updateSet">
	 <invoke object="application.classExtensionManager" methodcall="getSubTypeBean().getExtendSetBean()" returnVariable="request.extendSetBean" />
	  <invoke object="request.extendSetBean" methodcall="set(attributes)" />
	  
	  <if condition="attributes.action eq 'Update'">
	  <true>
	  	<invoke object="request.extendSetBean" methodcall="save()" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Delete'">
	  <true>
	  	<invoke object="request.extendSetBean" methodcall="delete()" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Add'">
	  <true>
	  	<invoke object="request.extendSetBean" methodcall="save()" />
	  </true>
	  </if> 
	
	  <if condition="attributes.action neq 'delete'">
	  <true>
	  	<relocate url="index.cfm?fuseaction=cExtend.editAttributes&amp;subTypeID=#attributes.subTypeID#&amp;extendSetID=#attributes.extendSetID#&amp;siteid=#attributes.siteid#" addtoken="false"/>
	  </true>
	  <false>
	  	<relocate url="index.cfm?fuseaction=cExtend.listSets&amp;siteid=#attributes.siteid#&amp;subTypeID=#attributes.subTypeID#" addtoken="false"/>
	  </false>
	  </if>
	  	
</fuseaction>

<fuseaction name="updateAttribute">
	
	  <invoke object="application.classExtensionManager" methodcall="getSubTypeBean().getExtendSetBean().getattributeBean()" returnVariable="request.attributeBean" />
	  <invoke object="request.attributeBean" methodcall="set(attributes)" />

	  <if condition="attributes.action eq 'Update'">
	  <true>
	  	<invoke object="request.attributeBean" methodcall="save()" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Delete'">
	  <true>
	  	<invoke object="request.attributeBean" methodcall="delete()" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Add'">
	  <true>
	  	<invoke object="request.attributeBean" methodcall="save()" />
	  </true>
	  </if> 
	
	  <relocate url="index.cfm?fuseaction=cExtend.editAttributes&amp;subTypeID=#attributes.subTypeID#&amp;extendSetID=#attributes.extendSetID#&amp;siteid=#attributes.siteid#" addtoken="false"/>
	  
</fuseaction>

<fuseaction name="saveAttributeSort">
	<invoke object="application.classExtensionManager" methodcall="saveAttributeSort(attributes.attributeID)" />
</fuseaction>

<fuseaction name="saveExtendSetSort">
	<invoke object="application.classExtensionManager" methodcall="saveExtendSetSort(attributes.extendSetID)" />
</fuseaction>

</circuit>
