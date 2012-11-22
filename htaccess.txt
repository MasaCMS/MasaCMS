# This is for rewriting urls "WITHOUT" siteIDs
# To remove the Mura siteID directory and index.cfm from urls you must also set both siteIDInURLS and indexFileInURLs to 0 in your /config/setting.ini.cfm and reload Mura.
Options +FollowSymLinks
RewriteEngine On 
RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-d
RewriteRule ^([a-zA-Z0-9/-]+/tag/.+|tag/.+)$ /index.cfm%{REQUEST_URI} [PT]
RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-d
RewriteRule ^([a-zA-Z0-9/-\s]+)$ /index.cfm%{REQUEST_URI} [PT]

# This is for rewriting urls "WITH" siteIDs
# To remove the Mura siteID directory and index.cfm from urls you must also set siteIDInURLS to 1 and indexFileInURLs to 0 in your /config/setting.ini.cfm and reload Mura.
# RewriteEngine On
# RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-d
# RewriteRule ^([a-zA-Z0-9-]{1,})/^([a-zA-Z0-9/-]+/tag/.+|tag/.+)$ /$1/index.cfm/$2 [PT]
# RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-d
# RewriteRule ^([a-zA-Z0-9-]{1,})/([a-zA-Z0-9/-\s]+)$ /$1/index.cfm/$2 [PT]