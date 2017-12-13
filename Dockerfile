FROM 192.168.153.133:5000/kevinhou/centos:0.0.1

MAINTAINER kevinhou "kevin.hou01@gmail.com"

ADD . /tmp/

ENV CATALINA_HOME=/opt/tomcat \

    PATH=$PATH:$CATALINA_HOME/bin \

    HTTPSPORT=8000 \
	
	FID=kevinhou \

    GID=kevinhou \

    MAX_MEM="1024m" \

    FIND_PATH="/proc /opt /tmp" \


RUN yum -y install unzip; yum -y clean all && \

    yum -y install tar; yum -y clean all && \

    yum -y install ksh; yum -y clean all && \
	
	yum -y install openssh-server; yum -y clean all && \
	
	########## Installing JDK 8 #######################
	###to be updated
	
	########## Installing Tomcat ######################
	groupadd -r $GID && useradd -r --no-log-init -g $GID $FID && \
	
    mkdir -p $CATALINA_HOME && \

    tar xvf /tmp/tomcat.tar  --strip-components=1 -C $CATALINA_HOME && \

    rm -rf /tmp/tomcat.tar && \

    mkdir  $CATALINA_HOME/work && \
	
	cp /tmp/templates/fixpermission.sh $CATALINA_HOME/bin && \

    cp /tmp/templates/tomcat /etc/init.d/ && \

    sed -e "s#JAVALOCATION#$JAVA_HOME#" /tmp/templates/setenv.sh > $CATALINA_HOME/bin/setenv.sh && \

    echo "CLASSPATH=\${CATALINA_BASE}/bin/*:\${CATALINA_BASE}/lib/security/*:\${CATALINA_BASE}/lib/*" >> $CATALINA_HOME/bin/setenv.sh && \

    rm -rf $CATALINA_HOME/webapps/ROOT && \

    rm -rf $CATALINA_HOME/webapps/* && \

    rm -rf  $CATALINA_HOME/conf/Catalina/localhost/* && \

    rm -rf  $CATALINA_HOME/server/webapps/* && \

    unzip /tmp/templates/ok.war -d $CATALINA_HOME/webapps/ok && \

    chmod 755 /etc/init.d/tomcat && \

	mkdir /tomcat-apps && \

    find $CATALINA_HOME -exec chgrp 0 {} \; && \

    find $CATALINA_HOME -exec chmod g+rw {} \; && \

    find $CATALINA_HOME -type d -exec chmod g+x {} + && \

    find /tomcat-apps -exec chgrp 0 {} \; && \

    find /tomcat-apps -exec chmod g+rw {} \; && \

    find /tomcat-apps -type d -exec chmod g+x {} + && \

    find /tmp/templates -exec chgrp 0 {} \; && \

    find /tmp/templates -exec chmod g+rw {} \; && \

    find /tmp/templates -type d -exec chmod g+x {} + 



USER kevinhou

EXPOSE 20000

CMD ["/tmp/startServer.sh","$CATALINA_HOME/bin/catalina.sh","run"]
