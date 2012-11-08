/* Use this script if you need to support IE 7 and IE 6. */

window.onload = function() {
	function addIcon(el, entity) {
		var html = el.innerHTML;
		el.innerHTML = '<span style="font-family: \'mura-icons\'">' + entity + '</span>' + html;
	}
	var icons = {
			'mico-file' : '&#x21;',
			'mico-file-2' : '&#x22;',
			'mico-copy' : '&#x23;',
			'mico-folder' : '&#x24;',
			'mico-folder-2' : '&#x25;',
			'mico-database' : '&#x26;',
			'mico-cube' : '&#x27;',
			'mico-briefcase' : '&#x28;',
			'mico-feed' : '&#x29;',
			'mico-libreoffice' : '&#x2a;',
			'mico-file-pdf' : '&#x2b;',
			'mico-file-openoffice' : '&#x2c;',
			'mico-file-word' : '&#x2d;',
			'mico-file-excel' : '&#x2e;',
			'mico-file-powerpoint' : '&#x2f;',
			'mico-file-zip' : '&#x30;',
			'mico-file-xml' : '&#x31;',
			'mico-file-css' : '&#x32;',
			'mico-locked' : '&#x33;',
			'mico-file-3' : '&#x34;',
			'mico-window' : '&#x35;',
			'mico-document-alt-stroke' : '&#x36;',
			'mico-document-alt-fill' : '&#x37;'
		},
		els = document.getElementsByTagName('*'),
		i, attr, html, c, el;
	for (i = 0; i < els.length; i += 1) {
		el = els[i];
		attr = el.getAttribute('data-icon');
		if (attr) {
			addIcon(el, attr);
		}
		c = el.className;
		c = c.match(/mico-[^\s'"]+/);
		if (c) {
			addIcon(el, icons[c[0]]);
		}
	}
};