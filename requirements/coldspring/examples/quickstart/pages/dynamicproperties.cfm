<cfimport taglib="/coldspring/examples/quickstart/layout" prefix="layout" />
<cfoutput>
<layout:layout section="dynamicproperties">
<h1>Dynamic Properties in the ColdSpring Configuration File</h1>
<p>
	A powerful but often underused capability of ColdSpring lies in the ability to specify dynamic values
	to <strong>use in your XML configuration file</strong>. Let's demonstrate how we might use this capability.
</p>

<p>
	You may recall from the constructor argument discussion that our ConfigBean is being passed a datasource
	name. In that previous example, <strong>we were hardcoding a value</strong> of "myDSN" into the XML for this value, like this:
</p>

<p>#getCodeSnippet('codesnippets/constructor1.txt', 'xml')#</p>	

<p>
	To put it bluntly, <strong>that kind of sucks</strong>. Hardcoded values like that should be one of the first things to set off
	warning lights in your head. What if we want to easily reuse this configuration file in more than one application?
	Where the applications need different datasource names? Luckily, there's an easy solution. We can specify
	a special placeholder value in the XML to <strong>tell ColdSpring that this is a dynamic value</strong>:
</p>

<p>#getCodeSnippet('codesnippets/dynamicproperty1.txt', 'xml')#</p>	

<p>
	<strong>Note the special value</strong> with the dollar sign and the brackets. That's the placeholder. Now, when we create our
	ColdSpring factory, we can pass in a structure that defines what we want to use for those dynamic values.
	This would look like:
</p>

<p>#getCodeSnippet('codesnippets/dynamicproperty2.txt')#</p>	

<p>
	As you can see, our structure has a key named "dsnName" and a value of "myDSN". When we give this to ColdSpring
	as a constructor argument, it <strong>automatically will replace the matching placeholder</strong> ${myDSN} with the corresponding
	value in our properties structure. This can lead to much more flexible configuration files.
</p>

<div class="featurebox">	
	<h3>Options for Defining Dynamic Properties</h3>
	<p>
		You might want to save this for later investigation, but there are some other nice ways to define
		the dynamic properties that you pass to ColdSpring beyond building a structure. When you feel up to it,
		have a look at the Environment CFC which is discussed in the <a href="index.cfm?page=extensions">ColdSpring extensions</a> section.
	</p>
</div>	
	
</layout:layout>
</cfoutput>