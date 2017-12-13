#add tomcat pid 
CATALINA_PID="$CATALINA_BASE/tomcat.pid"
#add java opts 
JAVA_OPTS="-server-XX:PermSize=256M -XX:MaxPermSize=1024m -Xms512M -Xmx1024M-XX:MaxNewSize=256m"