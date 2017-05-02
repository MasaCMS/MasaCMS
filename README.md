# MuraCMS
[![Build Status](https://travis-ci.org/blueriver/MuraCMS.svg?branch=master "master")](https://travis-ci.org/blueriver/MuraCMS)

Mura CMS is an open source content management system for CFML, created by [Blue River Interactive Group](http://www.getmura.com). Mura has been designed to be used by marketing departments, web designers and developers.

For those with Docker installed:

Start up a instance pre-populated with content:

```git clone git@github.com:blueriver/MuraCMS.git
cd MuraCMS
docker-compose -f config/docker/local-demo/docker-compose.yml up
```

Start up a instance an empty site:

```git clone git@github.com:blueriver/MuraCMS.git
cd MuraCMS
docker-compose -f config/docker/local-dev/docker-compose.yml up
```

Then access the application via:

http://localhost/8080

username:admin
password:admin

Simply hold down control-c to the service.

[Website (http://www.getmura.com)](http://www.getmura.com)
