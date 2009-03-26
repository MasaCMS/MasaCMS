<cfimport taglib="/coldspring/examples/quickstart/layout" prefix="layout" />
<cfoutput>
<layout:layout section="extensions">
<h1>ColdSpring Extensions</h1>

<p>
	As a very popular tool that is easy to use within other frameworks, ColdSpring has a large number of
	extensions available. Some of these are part of the core ColdSpring framework that you have already
	downloaded. Others are available as external options. Let's look at some of the most common extensions.

	<ul>
		<li>
			<strong>Model-Glue</strong>: Model-Glue 2 and Model-Glue 3 are both tightly integrated with ColdSpring. In fact,
			the entire Model-Glue framework is internally configured with ColdSpring! You can use it to
			autowire your Model-Glue Controller CFCs, and more. Check out the 
			<a href="http://www.model-glue.com" target="_blank">Model-Glue
			web site</a></a> for information on how you can use ColdSpring within your Model-Glue applications or
			subscribe to the <a href="http://groups.google.com/group/model-glue" target="_blank">Model-Glue discussion list</a>.
		</li>
		<li>
			<strong>Mach-II</strong>: Mach-II offers built-in options for using ColdSpring to autowire Mach-II Listeners as
			well as automatically generate Remote Proxies. You can find out more at the 
			<a href="http://www.mach-ii.com" target="_blank">Mach-II web site</a> and
			the <a href="http://groups.google.com/group/mach-ii-for-coldfusion" target="_blank">Mach-II discussion list</a>.
		</li>
		<li>
			<strong>Fusebox</strong>: Fusebox offers custom XML lexicons for interacting with ColdSpring. More information
			can be found at the <a href="" target="_blank">Fusebox web site</a> and the 
			<a href="http://tech.groups.yahoo.com/group/fusebox5/" target="_blank">Fusebox discussion list</a>. 
		</li>
		<li>
			<strong>ColdBox</strong>: ColdBox offers tight integration with IoC containers like ColdSpring. It can autowire
			ColdBox components automatically, among other things. For more, head to the <a href="" target="_blank">ColdBox web site</a>
			or the <a href="http://groups.google.com/group/coldbox" target="_blank">ColdBox discussion list</a>.
		</li>
		<li>
			<strong>ColdSpring Bean Utilities</strong>: Brian Kotek has an open-source set of components for working with
			ColdSpring. At some point, some or all of this may be integrated into the ColdSpring repository, but for now
			you can find out more at the 
			<a href="http://coldspringutils.riaforge.org/" target="_blank">ColdSpring Bean Utilities RIAForge project</a>.
			These include:
			<ul>
				<li>
				DynamicXMLBeanFactory: This extends the standard DefaultXMLBeanFactory but allows the ability to 
				replace dynamic properties anywhere in the XML file, as well as in imported XML files.
				</li>
				<li>
				MetadataAwareProxyFactoryBean: This extends the ColdSpring ProxyFactoryBean and automatically injects 
				metadata information into any Advices that extend AbstractMetadataAwareAdvice after the AOP proxy is created.
				</li>
				<li>
				MetadataAwareRemoteFactoryBean: This extends the ColdSpring RemoteFactoryBean and automatically injects 
				metadata information into any Advices that extend AbstractMetadataAwareAdvice after the remote proxy is created.
				</li>
				<li>
				BeanInjector: The component will autowire any other component with ColdSpring-managed beans. 
				Very useful for injecting ColdSpring beans (mainly Singletons) into transient objects.
				</li>
				<li>
				TDOBeanInjectorObserver: This component uses the BeanInjector to automatically autowire Transfer Decorator 
				objects with ColdSpring beans. Transfer is an ORM (object-relational mapping) framework for ColdFusion. 
				Using this observer allows your Transfer Decorators to supply much richer behavior and allows them to 
				act as real Business Objects rather than simple data containers for database data.
				</li>
				<li>
				AbstractMetadataAwareAdvice: An abstract ColdSpring AOP Advice that leverages an XML file to supply 
				metadata to your Advices. This greatly enhances the capabilities of an Advice because you can supply 
				information that the Advice can act upon that it would otherwise be unaware of.
				</li>
				<li>
				VOConverterAdvice: This Advice extends AbstractMetadataAwareAdvice and allows you to specify a 
				converter component that will perform some kind of conversion on the data being returned by the proxied 
				component. It uses the metadata supplied by the superclass to determine what converter to invoke, and 
				passes the metadata into the converter for its use in doing its work.
				</li>
				<li>
				GenericVOConverter: This is a generic Value Object converter that can be used by the VOConverterAdvice 
				that will convert queries, arrays, or structures into objects of the type specified by the metadata. 
				It isn't incredibly useful because it currently returns the structure keys in uppercase but it is 
				meant as a starting point for creating your own converters.
				</li>
			</ul>
		</li>
		<li>
			<strong>Environment Config CFC</strong>: This is a handy way to supply dynamic properties to ColdSpring that avoids having to
			manually create a structure. With this component, you define properties in XML that are used to
			generate a structure automatically for you to pass to ColdSpring. That might not sound like much,
			but it has the very nice ability to load up different sets of properties depending on your server
			environment. So you can automatically get different properties for local, staging, or production
			systems based on host name, custom identifier, or other options. You can try it out through
			the <a href="http://environmentconfig.riaforge.org/" target="_blank">Environment Config RIAForge project</a>.
		</li>
	</ul>
</p>	
</layout:layout>
</cfoutput>