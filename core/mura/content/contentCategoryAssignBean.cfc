/*
This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without
Mura CMS under the license of your choice, provided that you follow these specific guidelines:

Your custom code

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

	/admin/
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
*/
component extends="mura.bean.beanORM" table="tcontentcategoryassign" entityname="contentCategoryAssign" bundleable=false hint="This provides content category assignment functionality"{

    property name="content" fieldtype="many-to-one" cfc="content" fkcolumn="contenthistid" loadkey="contenthistid";
    property name="activeContent" fieldtype="many-to-one" cfc="content" fkcolumn="contentid" loadkey="contentid";
    property name="category" fieldtype="many-to-one" cfc="category" fkcolumn="categoryid";
		property name="parent" fieldtype="many-to-one" cfc="category" fkcolumn="parentid" persistent=false;
		property name="kids" fieldtype="one-to-many" cfc="category" fkcolumn="categoryid" loadkey="parentid" nested=true orderby="name asc";
    property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteid";
    property name="isfeature" datatype="int" default=0;
    property name="featureStart" datatype="datetime";
    property name="featureSop" datatype="datetime";
		property name="categoryName" datatype="varchar" length=250 persistent=false default="";
		property name="parentName" datatype="varchar" length=250 persistent=false default="";
		property name="filename" datatype="varchar" length=250 persistent=false default="";
		property name="path" datatype="varchar" length=250 persistent=false default="";

		function getLoadSQLColumnsAndTables(){
			return "tcontentcategoryassign.*,category.name as categoryName, parentCategory.name as parentName,
				category.parentid, category.filename, category.path
				FROM tcontentcategoryassign
				INNER JOIN tcontentcategories category on (tcontentcategoryassign.categoryid=category.categoryid)
				LEFT JOIN tcontentcategories parentCategory on (category.parentid=parentCategory.categoryid)";
		}

		function getKidsIterator(){
			return getBean('category').getFeed().where().prop('parentid').isEQ(get('parentid')).getIterator();
		}

		function getKids(){
			return getKidsIterator();
		}

		function getKidQuery(){
			return getKidsIterator().getQuery();
		}

}
