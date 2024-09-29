#base image
FROM tomcat:10.0.0-jdk11-openjdk-buster
#set environment variables
ENV MAVEN_HOME=/usr/share/maven
ENV MAVEN_VERSION=3.8.8
ENV PATH=$MAVEN_HOME/bin:$PATH
#Since we are using Ubuntu container for Centos Host OS.
#Hence update apt-get package installer for Ubuntu & install Curl.
RUN apt-get update 
RUN apt-get install -y curl
#Using curl donload maven setup.Setup file is zip file hence using tar xzf command to unzip setup.
#AND copy setup to /usr/share path.
RUN curl -fsSL https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share
#move the setup to maven dir.
RUN mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven
#clean the resources and clear listsMAVEN_VERSION.
RUN apt-get clean && \
rm -rf /var/lib/apt/lists/*

WORKDIR /app
#copy ./src folder from the host to the ./src in the container.
COPY ./src ./src
COPY ./pom.xml ./pom.xml
#run this command to create .war file in the target folder.
RUN mvn package
#delete all the files in the webapps folder.
RUN rm -rf /usr/local/tomcat/webapps/*
#copy .war file from target folder to webapps folder
RUN cp /app/target/addressbook.war /usr/local/tomcat/webapps/
#assign port to run your application the container.
EXPOSE 8080
#run tomcat binary file to run application on web-server
CMD ["catalina.sh", "run"]
