<cfimport taglib="/coldspring/examples/quickstart/layout" prefix="layout" />
<cfoutput>
<layout:layout section="constructor">
<h1>ColdSpring Constructor Arguments</h1>
<p>
	Many ColdFusion developers have standardized on a method named init() that acts as a <strong>constructor for the component</strong>.
	ColdSpring will automatically call the constructor for any components that it manages. In cases where the constructor
	requires arguments to be passed into it, <strong>you can specify constructor arguments</strong> in your ColdSpring XML file, like this:
</p>

<p>#getCodeSnippet('codesnippets/constructor1.txt', 'xml')#</p>	

<p>
	This will ensure that when ColdSpring creates the ConfigBean and calls its constructor, <strong>it will pass in an
	argument named "datasourceName"</strong> with a value of "myDSN" to the init() method. For reference, the init() method for our 
	ConfigBean CFC looks similar to:
</p>

<p>#getCodeSnippet('codesnippets/constructor.txt', 'coldfusion')#</p>	

<p>
	In addition to defining simple values, you can also <strong>specify other ColdSpring-managed components as constructor arguments</strong>:
</p>

<p>#getCodeSnippet('codesnippets/constructor2.txt', 'xml')#</p>	

<p>
	With this code, when ColdSpring calls the constructor on the UserGateway, it will pass in an argument named "configBean",
	and <strong>its value will be the actual ConfigBean instance</strong> that ColdSpring is also managing. For reference,
	a constructor that requires passing a component as a constructor argument might look like:
</p>

<p>#getCodeSnippet('codesnippets/constructor3.txt', 'coldfusion')#</p>
	
<div class="featurebox">	
	<h3>When Should I Use Constructor Arguments vs. Setter Injection?</h3>
	<p>
	You may have noticed that there are essentially <strong>two ways</strong> to feed data into the CFCs that ColdSpring is managing. One
	is through <strong>constructor arguments</strong>, and the other is by calling <strong>setter methods</strong> like we saw in the ColdSpring in 5 Minutes
	example. So which way should you do it?
	</p>
	<p>
	For CFC data that are simple values, using a constructor argument to set the value is often fine.
	However, when passing dependent CFCs into a component, setter injection is often preferable.
	This has to do with the idea of <strong>circular dependencies</strong>.
	</p>
	<p>
	A circular dependency can happen when <strong>two CFC's actually depend on each other</strong>. i.e., ComponentA depends on
	ComponentB, but ComponentB depends on ComponentA! Now what do we do? When using constructor arguments we can
	be in a bit of trouble. But using setter injection means that ColdSpring can create the two components
	and then use setter methods to inject them into each other. This way we don't run into a deadlock where neither
	component can be created because they both need each other to have their constructors called.
	</p>
	<p>
	If that doesn't make much sense, don't worry. Just remember that <strong>as a general rule, using setter injection
	is often more flexible than using constructor arguments to inject dependent components</strong>.
	</p>
</div>	
	
</layout:layout>
</cfoutput>