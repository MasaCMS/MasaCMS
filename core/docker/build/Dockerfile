FROM lucee/lucee5:latest

# Rewrite rules
COPY core/docker/build/rewrite.config /usr/local/tomcat/conf/Catalina/127.0.0.1/

# Logs
RUN ln -sf /dev/stdout /opt/lucee/web/logs/application.log
RUN ln -sf /dev/stdout /opt/lucee/web/logs/exception.log

# Provide app
RUN mkdir -p /var/www
# Copy Mura files
COPY . /var/www
