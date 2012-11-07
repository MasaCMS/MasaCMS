$.fn.spin = function(opts, callback) {
  this.each(function() {
    var $this = $(this),
        data = $this.data();

    if (opts !== false) {
      data.spinner = new Spinner(opts).spin(this);
      callback.call($this);
    }
  });
  return this;
};

$.fn.unspin = function(callback) {
  this.each(function(){
    var $this = $(this),
        data = $this.data();

    if (data.spinner) {
      data.spinner.stop();
      callback.call($this);
      delete data.spinner;
    }
  });
  return this;
}