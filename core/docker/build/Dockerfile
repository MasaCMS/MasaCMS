FROM blueriver/lucee:5.2.6.47-SNAPSHOT

# Provide app
RUN mkdir -p /var/www
RUN mkdir -p /var/www/etc
RUN mkdir -p /var/www/plugins

# Rewrite rules
COPY core/docker/build/rewrite.config /usr/local/tomcat/conf/Catalina/127.0.0.1/
COPY core/docker/build/urlrewrite.xml /var/www/etc/urlrewrite.xml

# Logs
RUN ln -sf /dev/stdout /opt/lucee/web/logs/application.log
RUN ln -sf /dev/stdout /opt/lucee/web/logs/exception.log

# Copy Mura files
COPY . /var/www
