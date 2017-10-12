# Mura CMS

This is the ["**Official**" Mura CMS Docker image](https://hub.docker.com/r/blueriver/muracms/) built with the forthcoming [Mura 7.1](https://github.com/blueriver/MuraCMS/tree/7.1) release. 

# Supported Tags

* `7.1`, `latest` ([Dockerfile](https://github.com/blueriver/MuraCMS/blob/7.1/core/docker/build/Dockerfile))

# Resources

* **Mura CMS Resources:**
    * http://www.getmura.com
    * https://groups.google.com/forum/#!forum/mura-cms-developers
    * https://cfml.slack.com/messages/C0FBLG0BF
    * https://github.com/blueriver/MuraCMS/tree/7.1
* **Docker & Mura CMS Examples:**
    * https://hub.docker.com/r/blueriver/docker-muracms/
    * https://github.com/blueriver/docker-muracms
* **Where to file issues:**
    * https://github.com/blueriver/MuraCMS/issues
* **Lucee Resources:**
    * http://lucee.org/
    * https://hub.docker.com/r/lucee/lucee5/
* **Docker Resources:**
    * https://docs.docker.com/
    * https://forums.docker.com/
    * https://blog.docker.com/2016/11/introducing-docker-community-directory-docker-community-slack/
    * https://stackoverflow.com/search?tab=newest&q=docker

# Example `docker-compose.yml` For Mura CMS

```
version: '2.1'

services:
  #Mura Server
  mura:
    image: blueriver/muracms:latest
    environment:
        MURA_ADMIN_USERNAME: admin
        MURA_ADMIN_PASSWORD: admin
        MURA_ADMINEMAIL: example@localhost.com
        MURA_APPRELOADKEY: appreload
        MURA_DATASOURCE: muradb
        MURA_DATABASE: muradb
        MURA_DBTYPE: mysql
        MURA_DBUSERNAME: root
        MURA_DBPASSWORD: NOT_SECURE_CHANGE
        MURA_DBHOST: mura_mysql
        MURA_DBPORT: 3306
        MURA_SITEIDINURLS: "false"
        MURA_INDEXFILEINURLS: "true"
    volumes:
        -   mura_sites_data:/var/www/sites
        -   mura_themes_data:/var/www/themes
        -   mura_modules_data:/var/www/modules
        -   mura_plugins_data:/var/www/plugins
    ports:
        - "8888:8888"

  #MySQL
  mura_mysql:
    image: mysql:latest
    environment:
        MYSQL_ROOT_PASSWORD: NOT_SECURE_CHANGE
        MYSQL_DATABASE: muradb
    volumes:
        - mura_mysql_data:/var/lib/mysql
    ports:
        - "55555:3306"

volumes:
    mura_mysql_data:
    mura_sites_data:
    mura_modules_data:
    mura_themes_data:
    mura_plugins_data:
```

# Issues

Please submit issues to https://github.com/blueriver/MuraCMS/issues