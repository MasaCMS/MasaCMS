# Mura Resource Bundles

Mura utilizes [resource bundles](https://en.wikipedia.org/wiki/Java_resource_bundle) to internationalize various areas of the user interface, making the code locale-independent.

Resource bundles are `.properties` files, located under specified directories in Mura. These `.properties` files, or resource bundles, are named to indicate the language code, and country code. For example, the language code for English (en) and the country code for United States (US) would be represented as `en_us.properties`. If Mura cannot find a direct language and region match, it will search for a language match. If a locale's language cannot be found, Mura will fall back to its default of English, or `en.properties`.

The file itself is comprised of key-value pairs. The keys remain the same throughout each of the `.properties` files, and the value is translated into the file's designated language. If Mura is searching for a specific key-value pair within a translation, and cannot locate it, Mura will fall back to the English translation.

## Lookup Hierarchy

Mura automatically searches for resource bundles under specific&nbsp;directories, and uses the key-value pair(s) found in the order outlined below. If a `resource_bundles` directory does not exist in the following locations, you may safely create one, and place your resource bundle files there.

* **Module**
    * `../{module}/resource_bundles/`
    * Module (aka "Display Object") resource bundles are used for the specified module itself.
* **Theme**
    * `../{ThemeName}/resource_bundles/`
    * Theme resource bundles are only used when the specified theme is actively assigned to a site.
* **Site**
    * `{context}/sites/{SiteName}/resource_bundles/`
    * Site resource bundles are shared across all themes within the specified site.
* **Global**
    * `{context}/resource_bundles/`
    * Global resource bundles are shared across all sites under a single Mura instance.
* **Core Modules**
    * `{context}/core/modules/v1/core_assets/resource_bundles/`
    * If the requested key-value pair is not found in any of the locations above, Mura will use the default resource bundles located here for Mura's modules.

### Note
Admin-area resource bundles are stored under `{context}/core/mura/resourceBundle/resources/`. However, as of v7.1, many key-value pairs are not able to be overwritten using the technique described above at this time. Allowing for this option is under consideration for a future version.

## Contribute
If you would like to contribute to the translations project, please visit https://crowdin.com/project/muracms. Your help will be greatly appreciated!

## More Info
More information on resources bundles, including how to customize and create your own key-value pairs, is covered in the [Mura Developer Guide](http://docs.getmura.com/v7-1/mura-developers/mura-rendering/internationalization-localization/).


