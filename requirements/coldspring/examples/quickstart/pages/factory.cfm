<cfimport taglib="/coldspring/examples/quickstart/layout" prefix="layout" />
<cfset createColdSpring('coldspring_factory.xml') />

<cfoutput>
<layout:layout section="factory">
<h1>Using ColdSpring Factory Beans</h1>
<p>
	The ability to <strong>use your own Factory CFCs</strong> from within ColdSpring is a very powerful feature. It makes it easy to
	create your own custom Factories, or to leverage other CFC frameworks such as Object-Relational Mapping (ORM)
	frameorks.
</p>

<p>
	As already mentioned in the section on Singletons, ColdSpring isn't idea for managing Domain Objects like
	Users or Products. So how can we deal with this, since Domain Objects like those are quite possibly the most
	important part of our application?
</p>

<p>
	ColdSpring provides support for Factory Beans, which are <strong>special kinds of objects that create and return other
	objects</strong>. This example is a bit contrived for the sake of simplicity in demonstrating how factory beans work,
	so bear with us. We'll look at a more real-world usage in a moment. For example, say we wanted to be able
	to create a new Product object that our ProductService can do something with. Let's look at the code:
</p>

<h3>ProductService.cfc</h3>
<p>#getCodeSnippet('components/ProductService.cfc')#</p>	

<h3>Product.cfc</h3>
<p>#getCodeSnippet('components/Product.cfc')#</p>	

<h3>GenericFactory.cfc</h3>
<p>#getCodeSnippet('components/GenericFactory.cfc')#</p>	

<h3>ProductFactory.cfc</h3>
<p>#getCodeSnippet('components/ProductFactory.cfc')#</p>	

<p>
	In a nutshell, what we want to do here is:
	<ul>
		<li>Ask the service for a Product based on a specified Product ID.</li>
		<li>The service will ask the ProductFactory for the right Product.</li>
		<li>
			The ProductFactory is supplied to the ProductService by using a GenericFactory that can create factories for different
			kinds of domain objects (so it could give us a ProductFactory, an AddressFactory, etc.)
		</li>
	</ul>
	The idea being that the GenericFactory knows how to create lots of different kinds of Factories for us.
	That's all that is important for now. Lets have a look at the ColdSpring XML configuration that would allow
	us to do this:
</p>

<p>#getCodeSnippet('config/coldspring_factory.xml', 'xml')#</p>	

<p>
	Note the special <strong>"factory-bean" and "factory-method" attributes</strong> on the XML for "productFactory". Also note
	that it doesn't have a "class" attribute, where we would normally specify what CFC that bean is. What this means
	is that when ColdSpring creates the ProductFactory, it actually calls whatever bean is specified
	in the "factory-bean" and invokes whatever method is specified in the "factory-method". It also passes
	in any arguments that we specify. So in this case, when ColdSpring creates the ProductFactory, it does so 
	by calling "genericFactory.createFactory('Product')". Whatever that gives back is what becomes the "productFactory"
	bean. 
</p>

<p>
	As promised, we'll show a more "real world" example in a minute. But just to prove that this works, we
	can run the following code:
</p>

<p>#getCodeSnippet('codesnippets/factory1.txt')#</p>	

<p>When we run that, we get:<br />
<cfset productService = beanFactory.getBean('productService') />
<cfset product = productService.getProduct(14) />
Should return 14 since that is the Product ID we used to create the Product: #product.getProductID()#
</p>

<p>
	A more "real world" version of this can be shown by adding in the Transfer ORM framework. If you
	have no idea what Transfer is, don't worry. The real point is just to show how we can use ColdSpring's
	factory method capabilities to make use of external factories. Transfer just happens to be a very common
	use case.
</p>

<p>
	As we've said, Transfer is an ORM, which means it can help create Domain Objects. I might want to use
	it in a UserGateway to create User objects (and their related objects) for me. Here is how we could
	make use of Transfer as part of our ColdSpring configuration:
</p>

<p>#getCodeSnippet('codesnippets/factory2.txt', 'xml')#</p>	

<p>
	So here is a classic use for ColdSpring factory beans. When ColdSpring creates the UserGateway, it sees that it
	has a dependency on the Transfer bean. In order to create the Transfer bean, <strong>ColdSpring calls
	"getTransfer()" on the TransferFactory bean</strong>. It gives back an instance of the Transfer CFC, and that is
	what gets injected into the UserGateway. The UserGateway now has a handle on Transfer, and can use it
	however it needs to. 
</p>

<p>
	You'll find that people use ColdSpring factory beans in a number of places where they need to make
	use of other code libraries or custom factories to help create things that ColdSpring isn't meant for.
	This might take a bit to sink in, so just have a look at the code and check around on the web for
	many more examples of using factory beans.
</p>

</layout:layout>
</cfoutput>