
// Define the template class.
function DataSet( dataObject,id,isDirty ) {
	this.isDirty	= false;
	this.id			= 0;
	this.data		= {};

	this.create( dataObject,id );
	this.setIsDirty( false );
	
	return this;
};

// Define the template class methods.
DataSet.prototype = {
	// I load the data for the dataset
	create: function( dataObject,id ){
		var self	= this;
		self.id		= id;
		self.data	= dataObject;
	},
	get: function() {
		var self	= this;
		return self.data;
	},
	setIsDirty: function( status ){
		var self	= this;
		self.isDirty = status == false ? false : true;
	},
	getIsDirty: function( status ){
		var self	= this;
		return self.isDirty;
	}
};


