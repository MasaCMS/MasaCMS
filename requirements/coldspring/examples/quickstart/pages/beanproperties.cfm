<cfimport taglib="/coldspring/examples/quickstart/layout" prefix="layout" />
<cfoutput>
<layout:layout section="beanproperties">
<h1>ColdSpring Bean Properties</h1>
<p>
	In the ColdSpring in 5 Minutes example, you saw how you can use the XML attribute 'default-autowire="byName"' to tell ColdSpring
	to try and resolve the dependencies in your components automatically. However, if your setter method names don't all match
	your ColdSpring beanID values, or if you prefer to have a more explicit description of the dependencies, you can
	<strong>explicitly define properties for your ColdSpring beans</strong>.
</p>

<div class="featurebox">	
	<h3>When The Heck is a Bean?</h3>
	<p>
		It's probably time we covered this since we'll be using the term more and more. Since ColdSpring is a port of the Spring
		framework for Java, it has adopted many of its naming conventions for consistency. One of these is the idea of
		a "bean".
	</p>
	<p>
		Simply put, <strong>a bean is a CFC that has getters and setters for its properties</strong>. That's all. So that means if we
		have a UserGateway that has an instance variable named "configBean", that the CFC also has a setConfigBean() and
		getConfigBean() method. There's nothing more to it than that. If a CFC has getter and setter methods for its
		properties, it's a bean.
	</p>
</div>	

<p>
	If we wanted to <strong>use bean properties to define a dependency</strong> in the ColdSpring XML configuration file, we would do
	it like this:
</p>
<p>#getCodeSnippet('codesnippets/property.txt', 'xml')#</p>	

<p>
	With that XML, ColdSpring knows that there is a property on the UserGateway named "configBean". So we're telling it to call
	"setConfigBean()" and pass in our ConfigBean CFC. 
</p>

<div class="featurebox">	
	<h3>Why Would I Specify Bean Properties Instead of Using the Automatic Autowiring?</h3>
	<p>
		Some people might wonder why one would take the extra step of manually defining the dependencies instead
		of letting ColdSpring work its magic with "default-autowire". There are actually a few reasons one might
		do this.
	</p>
	<p>
		First, as we noted, <strong>your setter names may not line up exactly with your beanIDs</strong>. In cases like that, ColdSpring
		can't guess, so you have to tell it how to handle the dependency.
	</p>
	<p>
		Second, many developers actually find a large benefit to having the dependencies between their CFCs
		explicitly defined in one place. If you define the dependencies yourself, <strong>your ColdSpring XML becomes a very
		useful "map" of your components and what they depend on</strong>. Without this, knowing what depends on what can
		become rather murky and require opening up individual CFCs to look for setter methods and figure out
		what the dependencies are.
	</p>
	<p>
		Third, there is a certain amount of, shall we say, danger, in just <strong>letting ColdSpring run riot</strong> through
		your CFCs and autowire every setter that happens to have a matching beanID. You may very well not want it to do this!
		If a CFC happens to have a setConfig() method that you use for something unrelated to another CFC, but there also happens
		to be a bean with an ID of "config", you might see the problem. With 'default-autowire="true"' set globally in your XML,
		ColdSpring will try to handle this dependency <strong>whether you want it to or not</strong>.
	</p>
</div>	

<p>
	Keep in mind that you have the flexibility to <strong>mix and match the autowiring feature if you choose to</strong>. For example,
	you could set 'default-autowire="byName"' in your root beans XML element, but then override that setting on individual
	beans where you need to specify a dependency explicitly:
</p>

<p>#getCodeSnippet('codesnippets/property2.txt', 'xml')#</p>	

<p>
	Which gives you the flexibility to specify dependencies explicitly if you need to, but leverage the automatic autowiring
	if you choose to.
</p>

</layout:layout>
</cfoutput>