/* Use this script if you need to support IE 7 and IE 6. */

window.onload = function() {
	function addIcon(el, entity) {
		var html = el.innerHTML;
		el.innerHTML = '<span style="font-family: \'mura-icons\'">' + entity + '</span>' + html;
	}
	var icons = {
			'icon-newspaper' : '&#x21;',
			'icon-copy' : '&#x22;',
			'icon-calendar' : '&#x23;',
			'icon-box-add' : '&#x24;',
			'icon-database' : '&#x25;',
			'icon-cabinet' : '&#x26;',
			'icon-cabinet-2' : '&#x27;',
			'icon-calendar-2' : '&#x28;',
			'icon-calendar-3' : '&#x29;',
			'icon-file' : '&#x2a;',
			'icon-window' : '&#x2b;',
			'icon-file-2' : '&#x2c;',
			'icon-file-3' : '&#x2d;',
			'icon-files' : '&#x2e;',
			'icon-cube' : '&#x2f;',
			'icon-box' : '&#x30;',
			'icon-box-2' : '&#x31;',
			'icon-layout' : '&#x32;',
			'icon-layout-2' : '&#x33;',
			'icon-layout-3' : '&#x34;',
			'icon-layout-4' : '&#x35;',
			'icon-layout-5' : '&#x36;',
			'icon-layout-6' : '&#x37;',
			'icon-zip' : '&#x38;',
			'icon-zip-2' : '&#x39;',
			'icon-code' : '&#x3a;',
			'icon-embed' : '&#x3b;',
			'icon-file-powerpoint' : '&#x3c;',
			'icon-file-excel' : '&#x3d;',
			'icon-file-word' : '&#x3e;',
			'icon-file-openoffice' : '&#x3f;',
			'icon-file-pdf' : '&#x40;',
			'icon-libreoffice' : '&#x41;',
			'icon-file-css' : '&#x42;',
			'icon-file-xml' : '&#x43;',
			'icon-file-zip' : '&#x44;',
			'icon-layers' : '&#x45;',
			'icon-layers-alt' : '&#x46;'
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
		c = c.match(/icon-[^\s'"]+/);
		if (c) {
			addIcon(el, icons[c[0]]);
		}
	}
};