# tomcat7java8-docker-image
tomcat7java8-docker-image

docker run --name kevintest --net host -v /tmp/tomcatapps:/tomcatapps:rw -p 8080:20000 -d tomcat7java8-docker-image