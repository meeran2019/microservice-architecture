ARG BASE_IMAGE
FROM $BASE_IMAGE
ENV JAVA_APP_DIR=/deploy
ADD *.jar /deploy/
ADD config/* /deploy 
WORKDIR $JAVA_APP_DIR 
EXPOSE 8080
CMD ["/usr/bin/java", "-jar", "student-app-api-0.0.1-SNAPSHOT.jar"]