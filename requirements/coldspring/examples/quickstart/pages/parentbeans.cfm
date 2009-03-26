<cfimport taglib="/coldspring/examples/quickstart/layout" prefix="layout" />
<cfoutput>
<layout:layout section="parentbeans">
<h1>Defining and Using Parent Beans</h1>
<p>
	One issue that some people eventually run into when using ColdSpring is <strong>duplication in their XML configuration file</strong>.
	Consider something like this:
</p>

<p>#getCodeSnippet('codesnippets/parentbean1.txt', 'xml')#</p>	

<p>
	In this case, we have three Gateway components that all depend on the ConfigBean. But <strong>we're duplicating the dependency
	in all three Gateway definitions</strong> in the configuration file. That's not good, and if we had 20 Gateway's it would be
	even worse.
</p>

<p>
	ColdSpring allows us to eliminate the duplication by <strong>defining a parent bean</strong>. What this lets us do is move the
	dependency to one central bean, and then tell ColdSping that our Gateways all require the dependencies
	defined in that common parent bean:
</p>

<p>#getCodeSnippet('codesnippets/parentbean2.txt', 'xml')#</p>	

<p>
	You can see we <strong>got rid of all the duplicate XML</strong>. Now, all of our Gateways will still have the ConfigBean injected
	into them, but we only needed to define that dependency in the parent bean. This can be very handy with similar
	CFCs that have common dependencies.
</p>

<div class="featurebox">	
	<h3>Parent Beans vs. CFC Inheritance</h3>
	<p>
		People commonly get confused by the parent bean functionality because on the surface it resembles
		CFC inheritance. While the two are similar in concept, they actually have <strong>nothing to do with each other</strong>.
	</p>
	<p>
		In CFCs, one component can extend another component. This is called <strong>inheritance</strong>, and is a common part
		of object-oriented development. We can define data and methods in the superclass (the object being extended) which
		will be available in the subclasses (the children).
	</p>
	<p>
		<strong>ColdSpring parent beans are not tied to CFC inheritance</strong>. In fact, it is very possible to define a parent bean
		in ColdSpring that has no corresponding CFC at all. It exists for no other purpose than to reduce duplication
		in the XML configuration file.
	</p>
	<p>
		Now under the hood, our Gateway CFCs might actually extend a "BaseGateway", and the setConfigBean() method may
		be defined in the BaseGateway and inherited by all of the concrete Gateways. But this is <strong>not required</strong>
		for the parent bean functionality to work.
	</p>
	<p>
		To summarize, whether our Gateway CFCs inherit the setConfigBean() method from a base CFC, or whether each one defines 
		its own setConfigBean() method, has no connection to the ColdSpring parent bean we defined. <strong>All the parent bean does is 
		eliminate the duplicate XML in our Gateway bean definitions</strong>. 
	</p>
</div>	
	
</layout:layout>
</cfoutput>