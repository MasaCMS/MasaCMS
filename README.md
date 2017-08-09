# MuraCMS
[![Build Status](https://travis-ci.org/blueriver/MuraCMS.svg?branch=master "master")](https://travis-ci.org/blueriver/MuraCMS)

Mura CMS is an open source content management system for CFML, created by [Blue River Interactive Group](http://www.getmura.com). Mura has been designed to be used by marketing departments, web designers and developers.

##For those with Docker installed:

### Mura CMS Resources

* http://www.getmura.com
* https://groups.google.com/forum/#!forum/mura-cms-developers
* https://cfml.slack.com/messages/C0FBLG0BF>
* https://github.com/blueriver/MuraCMS/tree/7.1

### Official Docker Image

In production can simply use the official docker image available at <https://hub.docker.com/r/blueriver/muracms/>

### Using Docker with Source Code

#### Start up a demo instance pre-populated with content:

```
git clone https://github.com/blueriver/MuraCMS.git
cd MuraCMS
git checkout 7.1
docker-compose -f core/docker/local-demo/docker-compose.yml up
```

#### Start up an instance with no content:

```
git clone https://github.com/blueriver/MuraCMS.git
cd MuraCMS
git checkout 7.1
docker-compose -f core/docker/local-mysql/docker-compose.yml up
```

Then access the application via:

http://localhost:8080

To login type esc-l or go to http://localhost:8080/admin

```
Username:admin
Password:admin
```

#### MYSQL Connection Info:

```
Host: localhost
Port: 55555
Username: root
Passsword: NOT_SECURE_CHANGE
```

Simply hold down control-c to stop the service.
