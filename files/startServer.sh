#!/bin/bash

source /tmp/logger.sh
 

###################### Change file ownership and permission #######################

/tmp/fixpermission.sh  

###################################  Check JRE ################################################

info "Verifying the jdk option"

if [ -z "$jdk" ]; then
	error "no jdk found"
	exit 1
else

	export JAVA_HOME=$JAVA_HOME

fi


#################################  Max Memory ###################################################

info "configuring max memory value $MAX_MEM"

sed -i "s/-Xmx.*/-Xmx${MAX_MEM}\"/" $CATALINA_HOME/bin/setenv.sh

 
################################  Java Optional Parameters #####################################

info "configuring custom java optional parameter value $CUSTOM_JAVA_OPTS"

sed -i -e "s#^CUSTOM_JAVA_OPTS.*#CUSTOM_JAVA_OPTS=\"${CUSTOM_JAVA_OPTS}\"#"  $CATALINA_HOME/bin/setenv.sh

 
#################################  Deploy Apps to the container ###########################
if [ ! -d /tomcatapps ]; then

	info "No Application directory mounted to /tomcatapps"

	info "Will use the Default test war"

else

	info "Removing the test war and deploying application war"

	rm -rf $CATALINA_HOME/webapps/test  

	wars=`ls /tomcatapps|wc -l`

	if [ $wars > 0 ]; then

		for warfile in `ls /tomcatapps`

		do

			dir=${warfile%.war}

			info "Deploying the application $warfile in $CATALINA_HOME/webapps/${dir}"

			unzip /tomcatapps/$warfile -d $CATALINA_HOME/webapps/${dir}

		done

	else

		error "No war files found in the directory /tomcatapps. Pls make sure the apps war files are availble."

		exit 1

	fi

fi
 

exec "$@"
