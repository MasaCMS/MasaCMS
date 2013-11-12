(function(document){

    var ua = navigator.userAgent.toLowerCase();

    var isIE8CompatMode = function() {

		return $.browser.msie &&
		$.browser.version == 7.0 &&
		
		document.documentMode &&
		
		document.documentMode == 8;
	
	}
	
	if(isIE8CompatMode()){
		$(document).ready(function(){
            var oldHtml = document.body.innerHTML,
            css_a = 'text-decoration: underline; color: black; font-weight:bold;',
            warningHtml = '',
            spacerHTML = '',
            oldHTMLWrap = '';

            warningHtml += '<style>';
            warningHtml += 'html, body { ';
            warningHtml += 'overflow-y: hidden!important; ';
            warningHtml += 'height: 100%;';
            warningHtml += 'padding: 0px;';
            warningHtml += 'margin: 0px;';
            warningHtml += '</style>';
            warningHtml += '<div style="position: absolute; top:0px; bottom:auto; left:0px; right:0px; margin: 0px; padding: 3px; font-family: Helvetica, Geneva, Arial, sans-serif; font-size:11px; background-color:#FFFFE1; color:black; border-top: 1px solid #FFFFE1; border-bottom: 1px solid #cccccc; padding-left:15px; margin-left: -15px; z-index: 100000;">';
            warningHtml += '<div style="float:right; text-align:right; width:60px; margin: auto 5px;">';
            warningHtml += '<a style="text-decoration: none; color: black;" href="#close" onclick="this.parentNode.parentNode.style.display=\'none\'; this.parentNode.parentNode.parentNode.childNodes[0].childNodes[0].style.display=\'none\'; return false;">[ close ]</a>';
            warningHtml += '</div>';
            warningHtml += '<div style="text-align:left; margin:auto 10px;">';
            warningHtml += 'It looks like you are running Internet Explorer in "Compatibility Mode". Because Mura CMS is built using web standards, Mura CMS does not support Internet Explorer in this mode. However, it can easily be toggled to "Standards Mode" via "Internet Options" in Internet Explorer. <a style="'+css_a+'" target="_blank" href="http://blogs.msdn.com/b/ie/archive/2008/08/27/introducing-compatibility-view.aspx">Click here</a> to learn more.';
            warningHtml += '</div>';
            warningHtml += '</div>';

            spacerHTML += '<div style="line-height:1.2; font-size:11px; display:block; margin:0px; padding:0px;">';
            spacerHTML += '</div>';

            oldHTMLWrap += '<div style="width:100%; margin:0px; padding:0px; height:100%; overflow-y: scroll; position:relative;">';
            oldHTMLWrap += spacerHTML;
            oldHTMLWrap += oldHtml;
            oldHTMLWrap += '</div>';
            document.body.innerHTML = oldHTMLWrap + warningHtml;
        });

		
	} else if(ua.indexOf('msie 7') > -1 || ua.indexOf('msie 6') > -1){
        $(document).ready(function(){
            var oldHtml = document.body.innerHTML,
            css_a = 'text-decoration: underline; color: black; font-weight:bold;',
            warningHtml = '',
            spacerHTML = '',
            oldHTMLWrap = '';

            warningHtml += '<style>';
            warningHtml += 'html, body { ';
            warningHtml += 'overflow-y: hidden!important; ';
            warningHtml += 'height: 100%;';
            warningHtml += 'padding: 0px;';
            warningHtml += 'margin: 0px;';
            warningHtml += '</style>';
            warningHtml += '<div style="position: absolute; top:0px; bottom:auto; left:0px; right:0px; margin: 0px; padding: 3px; font-family: Helvetica, Geneva, Arial, sans-serif; font-size:11px; background-color:#FFFFE1; color:black; border-top: 1px solid #FFFFE1; border-bottom: 1px solid #cccccc; padding-left:15px; margin-left: -15px; z-index: 100000;">';
            warningHtml += '<div style="float:right; text-align:right; width:60px; margin: auto 5px;">';
            warningHtml += '<a style="text-decoration: none; color: black;" href="#close" onclick="this.parentNode.parentNode.style.display=\'none\'; this.parentNode.parentNode.parentNode.childNodes[0].childNodes[0].style.display=\'none\'; return false;">[ close ]</a>';
            warningHtml += '</div>';
            warningHtml += '<div style="text-align:left; margin:auto 10px;">';
            warningHtml += 'It looks like you are using an out-of-date version of Internet Explorer. In the future, Mura CMS will only support versions of Internet Explorer 9 and above. <a style="'+css_a+'" target="_blank" href="http://www.microsoft.com/windows/Internet-explorer/default.aspx">Click here</a> to download the latest version! Or you could try';
            warningHtml += ' <a style="'+css_a+'" target=_blank" href="http://www.google.com/chrome">Chrome</a> or ';
            warningHtml += ' <a style="'+css_a+'" target="_blank" href="http://www.apple.com/safari/download/">Safari</a>.';
            warningHtml += ' <a style="'+css_a+'" target="_blank" href="http://www.mozilla.com/firefox/">Firefox</a>, ';
            warningHtml += '</div>';
            warningHtml += '</div>';

            spacerHTML += '<div style="line-height:1.2; font-size:11px; display:block; margin:0px; padding:0px;">';
            spacerHTML += '</div>';

            oldHTMLWrap += '<div style="width:100%; margin:0px; padding:0px; height:100%; overflow-y: scroll; position:relative;">';
            oldHTMLWrap += spacerHTML;
            oldHTMLWrap += oldHtml;
            oldHTMLWrap += '</div>';
            document.body.innerHTML = oldHTMLWrap + warningHtml;
        });
    }

})(document);