$(document).ready(function() {
  if ($('div.it.fail, div.it.pend').size() > 0) hidePassingExamples();
});

function hidePassingExamples() {
  var link = $('<a id="togglePassingExamples" href="#"></a>');
  link.insertBefore('div.header').click(togglePassingExamples).click();
}

function togglePassingExamples() {
  var $passes = $('h2.pass, h2.pass + div, div.it.pass');
  var linkText = '';
  $passes.toggle();
  if ($passes.filter(':hidden').size() == 0) {
    linkText = 'hide all passing examples';
  } else {
    linkText = 'show all passing examples';
  }
  $('#togglePassingExamples').text(linkText);
  return false;
}
