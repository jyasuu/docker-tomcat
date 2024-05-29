# First stage: Use a lightweight image to download Tomcat
FROM curlimages/curl:7.85.0 AS downloader

# Set environment variable for Tomcat version
ENV TOMCAT_VERSION 10.1.24

RUN curl https://dlcdn.apache.org/tomcat/tomcat-10/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz -o /tmp/apache-tomcat-$TOMCAT_VERSION.tar.gz

# Second stage: Use OpenJDK JRE image
FROM openjdk:11-jre-slim

# Set environment variables for Tomcat
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV TOMCAT_VERSION 10.1.24

# Create Tomcat directory
RUN mkdir -p "$CATALINA_HOME"

# Copy the downloaded Tomcat tarball from the first stage
COPY --from=downloader /tmp/apache-tomcat-$TOMCAT_VERSION.tar.gz /tmp/

# Extract Tomcat
RUN tar -xvf /tmp/apache-tomcat-$TOMCAT_VERSION.tar.gz -C $CATALINA_HOME --strip-components=1 && \
    rm /tmp/apache-tomcat-$TOMCAT_VERSION.tar.gz

# Expose the default port for Tomcat
EXPOSE 8080

# Set the entry point to run Tomcat
CMD ["catalina.sh", "run"]
