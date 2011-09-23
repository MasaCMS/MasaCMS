INSTALLING A THEME

Unzip the theme folder and upload it to the "/SITE_ID/includes/themes/" directory of your chosen site.

You should end up with a directory structure similar to this:

/SITE_ID/ (folder)
/SITE_ID/includes/ (folder)
/SITE_ID/includes/themes/ (folder)
/SITE_ID/includes/themes/NAME_OF_THEME/ (folder)
/SITE_ID/includes/themes/NAME_OF_THEME/css/ (folder)
/SITE_ID/includes/themes/NAME_OF_THEME/images/ (folder)
/SITE_ID/includes/themes/NAME_OF_THEME/README.txt
/SITE_ID/includes/themes/NAME_OF_THEME/templates/ (folder)

Note: There may be additional files/folders in this directory (this may vary from theme to theme)

In the Mura admin, go to 'Site Settings' and choose the site that you uploaded the theme to in step 1.
Under the 'Basic' tab of the Site Settings, locate the 'Theme' dropdown, and select the name of the theme, then press the 'Update' button at the bottom of the page.

Once a theme is installed and selected in the admin (step 3 above), Mura will look for template files in '/SITE_ID/includes/themes/THEME_NAME/templates/' rather than '/SITE_ID/includes/templates/'

Keep in mind that if you'd like multiple sites to use the same theme files, templates, display objects, etc, you can change the "Display Object Pool" found in Site Settings > Shared Resources to use another sites' files.


RECREATING THE HOMEPAGE

Recreating this home page in Mura is fairly easy. Follow these steps, and you'll be up and running in no time.

Step 1: Assign the Correct Template
The template used is aptly named home.cfm. To make sure you are using the correct template, edit the home page and select home.cfm from the "Layout Template" dropdown in the "Advanced" Tab.

Step 2: Create Local Indexes
The majority of content on the homepage is created via Local Indexes, a way to output custom navigation based on very specific criteria such as Release Date, Most Commented, Highest Rated, etc. The slideshow and sidebar content is made up of 3 Local Indexes. Create these in "Content Collections.

Step 3: Create a "Features" Component
The "Features" content in the three columns below is static content that can be copied out of home_static.cfm. Once copied, create a new "Component" called "Features" and paste in the copied content as HTML source. Toggle source view using the top left button in the editor.

Step 4: Add Content Objects to the Page
Place your Local Indexes into Display Regions by editing the home page and selecting the "Content Objects" tab. Use the dropdown menu to select your Local Indexes, then use the arrow buttons to move them to the appropriate regions. Hit "Publish" and you're done!